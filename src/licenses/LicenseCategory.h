#ifndef TURTLEBROWSER_LICENSECATEGORY_H
#define TURTLEBROWSER_LICENSECATEGORY_H

#include <QObject>

namespace licenses {

  enum class LicenseCategory : uint8_t {
    All = 0,
    Platform = 1,
    Toolkit = 2,
    WebView = 3
  };

  enum LicenseRoles {
    LicenseFileName = Qt::DisplayRole,
    LicenseFilePath = Qt::UserRole,
    LicenseCategories = Qt::UserRole + 1
  };

}

#endif //TURTLEBROWSER_LICENSECATEGORY_H
