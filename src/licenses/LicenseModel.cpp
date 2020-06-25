#include "LicenseModel.h"
#include "LicenseItem.h"

#include <QDirIterator>

namespace licenses {

  namespace {
    const char *const platformRootPath = ":/licenses";
    const char *const qtRootPath = ":/licenses/qt";
    const char *const toolkitRootPath = ":/licenses/qt/licenses";
    const char *const webviewRootPath = ":/licenses/qt/licenses/qtwebengine/src/3rdparty/chromium";

    LicenseItem * getItem(const QModelIndex & index) {
      return static_cast<LicenseItem *>(index.internalPointer());
    }
  }

  LicenseModel::LicenseModel(QObject *parent) : QAbstractItemModel(parent), m_dir(platformRootPath) {
    populate();
  }

  LicenseModel::~LicenseModel() = default;

  void LicenseModel::populate() {
    QList<QVariant> root_categories;
    m_rootItem = std::make_unique<LicenseItem>(QString("Licenses"), QString(platformRootPath), root_categories);

    QHash<QString, LicenseItem *> map;
    map[m_rootItem->path()] = m_rootItem.get();

    QDirIterator it(m_dir, QDirIterator::Subdirectories);

    while (it.hasNext()) {
      QString path = it.next();

      QList<QVariant> categories;
      categories.append(QVariant(static_cast<int>(LicenseCategory::All)));

      if (path.startsWith(webviewRootPath))
        categories.append(QVariant(static_cast<int>(LicenseCategory::WebView)));
      else if (path.startsWith(toolkitRootPath))
        categories.append(QVariant(static_cast<int>(LicenseCategory::Toolkit)));

      if (path.startsWith(platformRootPath) && !path.startsWith(qtRootPath))
        categories.append(QVariant(static_cast<int>(LicenseCategory::Platform)));

      const QFileInfo &fileInfo = it.fileInfo();
      LicenseItem *parent = map[fileInfo.dir().path()];

      auto *child = new LicenseItem(fileInfo.fileName(), fileInfo.absoluteFilePath(), categories, parent);

      if (fileInfo.isDir())
        map[child->path()] = child;
    }
  }

  QModelIndex LicenseModel::index(int row, int column, const QModelIndex &parent) const {
    if (!hasIndex(row, column, parent))
      return QModelIndex();

    LicenseItem *parentItem;

    if (!parent.isValid())
      parentItem = m_rootItem.get();
    else
      parentItem = getItem(parent);

    LicenseItem *childItem = parentItem->child(row);
    if (childItem)
      return createIndex(row, column, childItem);
    return QModelIndex();
  }

  QModelIndex LicenseModel::parent(const QModelIndex &index) const {
    if (!index.isValid())
      return QModelIndex();

    auto *childItem = getItem(index);
    LicenseItem *parentItem = childItem->parentItem();

    if (parentItem == m_rootItem.get())
      return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
  }

  int LicenseModel::rowCount(const QModelIndex &parent) const {
    if (parent.column() > 0)
      return 0;

    LicenseItem * parentItem;

    if (!parent.isValid())
      parentItem = m_rootItem.get();
    else
      parentItem = getItem(parent);

    return parentItem->childCount();
  }

  int LicenseModel::columnCount(const QModelIndex &parent) const {
    return 1;
  }

  QVariant LicenseModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid())
      return QVariant();

    if (role != licenses::LicenseFileName && role != licenses::LicenseFilePath && role != licenses::LicenseCategories)
      return QVariant();

    auto *item = getItem(index);

    return item->data(static_cast<LicenseRoles>(role));
  }

  Qt::ItemFlags LicenseModel::flags(const QModelIndex &index) const {
    if (!index.isValid())
      return Qt::NoItemFlags;

    return QAbstractItemModel::flags(index);
  }

}
