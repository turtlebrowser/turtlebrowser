#ifndef TURTLEBROWSER_LICENSEMODEL_H
#define TURTLEBROWSER_LICENSEMODEL_H

#include "licenses/LicenseCategory.h"

#include <QtCore/QAbstractItemModel>
#include <QtCore/QDir>

namespace licenses {

  class LicenseItem;

  class LicenseModel : public QAbstractItemModel {

  public:
    explicit LicenseModel(QObject *parentObject = nullptr);

    ~LicenseModel() override;

    QModelIndex index(int row, int column, const QModelIndex &parentIndex) const override;

    QModelIndex parent(const QModelIndex &childIndex) const override;

    int rowCount(const QModelIndex &parentIndex) const override;

    int columnCount(const QModelIndex &parentIndex) const override;

    QVariant data(const QModelIndex &index, int role) const override;

  private:
    void populate();

    QDir m_dir;
    std::unique_ptr<LicenseItem> m_rootItem;
  };

}

#endif //TURTLEBROWSER_LICENSEMODEL_H
