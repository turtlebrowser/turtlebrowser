#include "LicenseItem.h"

#include <QVariant>

namespace turtle_browser::licenses {

  LicenseItem::LicenseItem(QString file_name, QString file_path, QList<QVariant> categories, LicenseItem * parent)
      : QObject(parent),
        m_file_name(std::move(file_name)),
        m_file_path(std::move(file_path)),
        m_categories(std::move(categories)) {}

  LicenseItem *LicenseItem::child(int row) {
    if (row < 0 || row >= childCount())
      return nullptr;
    return static_cast<LicenseItem *>(children().at(row));
  }

  int LicenseItem::childCount() const {
    return children().count();
  }

  int LicenseItem::row() const {
    if (parentItem())
      return parentItem()->children().indexOf(const_cast<LicenseItem *>(this));
    return 0;
  }

  QVariant LicenseItem::data(LicenseRoles role) const {
    switch (role) {
      case licenses::LicenseFileName :
        return m_file_name;
      case licenses::LicenseFilePath :
        return m_file_path;
      case licenses::LicenseCategories :
        return m_categories;
      default:
        return QVariant();
    }
  }

  QString LicenseItem::path() const {
    return m_file_path;
  }

  LicenseItem *LicenseItem::parentItem() const {
    return static_cast<LicenseItem*>(parent());
  }

}
