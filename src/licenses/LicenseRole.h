#ifndef TURTLEBROWSER_LICENSEROLE_H
#define TURTLEBROWSER_LICENSEROLE_H

#include <QObject>

namespace turtle_browser::licenses {

  enum class LicenseRole : int {
    LicenseFileName = Qt::DisplayRole,
    LicenseFilePath = Qt::UserRole,
    LicenseCategories = Qt::UserRole + 1
  };

}

#endif //TURTLEBROWSER_LICENSEROLE_H
