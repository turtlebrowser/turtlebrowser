#include "LicenseFilter.h"

#include <QtCore/QFile>
#include <QTextStream>

namespace licenses {

  LicenseFilter::LicenseFilter(QObject *parent) : QSortFilterProxyModel(parent) {}

  bool LicenseFilter::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const {
    QModelIndex index = sourceModel()->index(source_row, 0, source_parent);

    auto categories = sourceModel()->data(index, LicenseCategories).toList();

    bool support = false;

    for (const auto &category : categories) {
      auto cat = static_cast<LicenseCategory>(category.toInt());
      if (cat == m_category)
        support = true;
    }

    if (!support)
      return false;

    QString filename = sourceModel()->data(index).toString();
    QString path = sourceModel()->data(index, Qt::UserRole).toString();
    return (filename.contains(filterRegExp()) || path.contains(filterRegExp()));
  }

  QString LicenseFilter::readFile(const QModelIndex &index) {

    QString fileName = sourceModel()->data(mapToSource(index), Qt::UserRole).toString();

    if (fileName.isEmpty())
      return QString();

    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QFile::Text)) {
      QTextStream t(&file);
      return t.readAll();
    }
    return QString();
  }

}
