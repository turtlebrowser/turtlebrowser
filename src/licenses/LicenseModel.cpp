#include "LicenseModel.h"

#include <QDirIterator>

static const char *const platformRootPath = ":/licenses";
static const char *const qtRootPath = ":/licenses/qt";
static const char *const toolkitRootPath = ":/licenses/qt/licenses";
static const char *const webviewRootPath = ":/licenses/qt/licenses/qtwebengine/src/3rdparty/chromium";

namespace licenses {

  LicenseModel::LicenseModel(QObject *parent) : QAbstractItemModel(parent), m_dir(platformRootPath) {
    populate();
  }

  LicenseModel::~LicenseModel() = default;

  void LicenseModel::populate() {
    QList<QVariant> root_categories;
    QVector<QVariant> rootData = {QString("Licenses"), QString(platformRootPath)};
    rootItem = std::make_unique<LicenseItem>(rootData, root_categories);

    QHash<QString, LicenseItem *> map;
    map[rootItem->path()] = rootItem.get();

    QDirIterator it(m_dir, QDirIterator::Subdirectories);

    while (it.hasNext()) {
      QString path = it.next();

      QList<QVariant> categories;
      categories.append(QVariant(static_cast<int>(LicenseCategory::All)));

      if (path.startsWith(webviewRootPath))
        categories.append(QVariant(static_cast<int>(LicenseCategory::WebView)));

      if (path.startsWith(toolkitRootPath) && !path.startsWith(webviewRootPath))
        categories.append(QVariant(static_cast<int>(LicenseCategory::Toolkit)));

      if (path.startsWith(platformRootPath) && !path.startsWith(qtRootPath))
        categories.append(QVariant(static_cast<int>(LicenseCategory::Platform)));

      const QFileInfo &fileInfo = it.fileInfo();
      LicenseItem *parent = map[fileInfo.dir().path()];

      QVector<QVariant> child_data = {fileInfo.fileName(), fileInfo.absoluteFilePath()};
      auto *child = new LicenseItem(child_data, categories, parent);
      parent->appendChild(child);

      if (fileInfo.isDir())
        map[child->path()] = child;
    }
  }

  QModelIndex LicenseModel::index(int row, int column, const QModelIndex &parent) const {
    if (!hasIndex(row, column, parent))
      return QModelIndex();

    LicenseItem *parentItem;

    if (!parent.isValid())
      parentItem = rootItem.get();
    else
      parentItem = static_cast<LicenseItem *>(parent.internalPointer());

    LicenseItem *childItem = parentItem->child(row);
    if (childItem)
      return createIndex(row, column, childItem);
    return QModelIndex();
  }

  QModelIndex LicenseModel::parent(const QModelIndex &index) const {
    if (!index.isValid())
      return QModelIndex();

    auto *childItem = static_cast<LicenseItem *>(index.internalPointer());
    LicenseItem *parentItem = childItem->parentItem();

    if (parentItem == rootItem.get())
      return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
  }

  int LicenseModel::rowCount(const QModelIndex &parent) const {
    LicenseItem *parentItem;
    if (parent.column() > 0)
      return 0;

    if (!parent.isValid())
      parentItem = rootItem.get();
    else
      parentItem = static_cast<LicenseItem *>(parent.internalPointer());

    return parentItem->childCount();
  }

  int LicenseModel::columnCount(const QModelIndex &parent) const {
    if (parent.isValid())
      return static_cast<LicenseItem *>(parent.internalPointer())->columnCount();
    return rootItem->columnCount();
  }

  QVariant LicenseModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid())
      return QVariant();

    if (role != licenses::LicenseFileName && role != licenses::LicenseFilePath && role != licenses::LicenseCategories)
      return QVariant();

    auto *item = static_cast<LicenseItem *>(index.internalPointer());

    return item->data(role);
  }

  Qt::ItemFlags LicenseModel::flags(const QModelIndex &index) const {
    if (!index.isValid())
      return Qt::NoItemFlags;

    return QAbstractItemModel::flags(index);
  }

  QVariant LicenseModel::headerData(int section, Qt::Orientation orientation,
                                    int role) const {
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole)
      return rootItem->data(section);

    return QVariant();
  }

  LicenseItem::LicenseItem(QVector<QVariant> data, QList<QVariant> categories, LicenseItem *parent)
      : m_itemData(std::move(data)), m_categories(std::move(categories)), m_parentItem(parent) {}

  LicenseItem::~LicenseItem() {
    qDeleteAll(m_childItems);
  }

  void LicenseItem::appendChild(LicenseItem *item) {
    m_childItems.append(item);
  }

  LicenseItem *LicenseItem::child(int row) {
    if (row < 0 || row >= m_childItems.size())
      return nullptr;
    return m_childItems.at(row);
  }

  int LicenseItem::childCount() const {
    return m_childItems.count();
  }

  int LicenseItem::row() const {
    if (m_parentItem)
      return m_parentItem->m_childItems.indexOf(const_cast<LicenseItem *>(this));

    return 0;
  }

  int LicenseItem::columnCount() const {
    return m_itemData.count();
  }

  QVariant LicenseItem::data(int role) const {
    switch (role) {
      case licenses::LicenseFileName :
        return m_itemData.at(0);
      case licenses::LicenseFilePath :
        return m_itemData.at(1);
      case licenses::LicenseCategories :
        return m_categories;
      default:
        return QVariant();
    }
  }

  QString LicenseItem::path() const {
    return data(Qt::UserRole).toString();
  }

  LicenseItem *LicenseItem::parentItem() {
    return m_parentItem;
  }

}
