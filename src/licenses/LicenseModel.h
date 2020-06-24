#ifndef TURTLEBROWSER_LICENSEMODEL_H
#define TURTLEBROWSER_LICENSEMODEL_H

#include "licenses/LicenseCategory.h"

#include <QtCore/QAbstractItemModel>
#include <QtCore/QDir>
#include <memory>

namespace licenses {

  class LicenseItem {
  public:
    explicit LicenseItem(QVector<QVariant> data, QList<QVariant> categories, LicenseItem *parentItem = nullptr);

    ~LicenseItem();

    void appendChild(LicenseItem *child);

    LicenseItem *child(int row);

    int childCount() const;

    int columnCount() const;

    QVariant data(int role) const;

    QString path() const;

    int row() const;

    LicenseItem *parentItem();

  private:
    QVector<LicenseItem *> m_childItems;
    QList<QVariant> m_categories;
    QVector<QVariant> m_itemData;
    LicenseItem *m_parentItem;
  };

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

    QVariant headerData(int section, Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

  private:
    void populate();

    QDir m_dir;
    std::unique_ptr<LicenseItem> rootItem;
  };

}

#endif //TURTLEBROWSER_LICENSEMODEL_H
