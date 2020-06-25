#ifndef TURTLEBROWSER_LICENSEMODEL_H
#define TURTLEBROWSER_LICENSEMODEL_H

#include "licenses/LicenseCategory.h"

#include <QtCore/QAbstractItemModel>
#include <QtCore/QDir>

namespace licenses {

  class LicenseItem;

  class LicenseModel : public QAbstractItemModel {

  public:
    explicit LicenseModel(QObject *parent = nullptr);

    ~LicenseModel() override;

    QModelIndex index(int row, int column, const QModelIndex &parent) const override;

    QModelIndex parent(const QModelIndex &child) const override;

    int rowCount(const QModelIndex &parent) const override;

    int columnCount(const QModelIndex &parent) const override;

    QVariant data(const QModelIndex &index, int role) const override;

    Qt::ItemFlags flags(const QModelIndex &index) const override;

  private:
    void populate();

    QDir m_dir;
    std::unique_ptr<LicenseItem> rootItem;
  };

}

#endif //TURTLEBROWSER_LICENSEMODEL_H
