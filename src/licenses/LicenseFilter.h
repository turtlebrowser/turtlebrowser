#ifndef TURTLEBROWSER_LICENSEFILTER_H
#define TURTLEBROWSER_LICENSEFILTER_H

#include "licenses/LicenseCategory.h"

#include <QtCore/QSortFilterProxyModel>

namespace turtle_browser::licenses {

  class LicenseFilter : public QSortFilterProxyModel {
  Q_OBJECT

  public:

    explicit LicenseFilter(QObject *parent = nullptr);

    Q_INVOKABLE QString readFile(const QModelIndex &index);

    void setCategory(const LicenseCategory &cat) { m_category = cat; }

  protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

  private:
    LicenseCategory m_category;
  };

}

#endif //TURTLEBROWSER_LICENSEFILTER_H
