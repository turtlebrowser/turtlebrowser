#include "LicenseFilter.h"
#include "LicenseRole.h"

#include <QTextStream>
#include <QtCore/QFile>

namespace turtle_browser::licenses {

  LicenseFilter::LicenseFilter(QObject * parent)
    : QSortFilterProxyModel(parent) {}

  bool LicenseFilter::filterAcceptsRow(int source_row, const QModelIndex & source_parent) const {
    QModelIndex index = sourceModel()->index(source_row, 0, source_parent);

    auto categories = getCategories(index);

    if (!categories.contains(static_cast<int>(m_category)))
      return false;

    QString filename = getFileName(index);
    QString path = getFilePath(index);
    return (filename.contains(filterRegExp()) || path.contains(filterRegExp()));
  }

  QString LicenseFilter::readFile(const QModelIndex & index) {

    QString fileName = getFilePath(mapToSource(index));

    if (fileName.isEmpty())
      return QString();

    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QFile::Text)) {
      QTextStream t(&file);
      return t.readAll();
    }
    return QString();
  }

  QList<QVariant> LicenseFilter::getCategories(const QModelIndex & index) const {
    return sourceModel()->data(index, static_cast<int>(LicenseRole::LicenseCategories)).toList();
  }

  QString LicenseFilter::getFileName(const QModelIndex & index) const {
    return sourceModel()->data(index, static_cast<int>(LicenseRole::LicenseFileName)).toString();
  }

  QString LicenseFilter::getFilePath(const QModelIndex & index) const {
    return sourceModel()->data(index, static_cast<int>(LicenseRole::LicenseFilePath)).toString();
  }

}
