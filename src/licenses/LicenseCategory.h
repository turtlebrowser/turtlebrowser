#ifndef TURTLEBROWSER_LICENSECATEGORY_H
#define TURTLEBROWSER_LICENSECATEGORY_H

namespace turtle_browser::licenses {

  enum class LicenseCategory : int {
    All = 0,
    Platform = 1,
    Toolkit = 2,
    WebView = 3
  };

}

#endif //TURTLEBROWSER_LICENSECATEGORY_H
