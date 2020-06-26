#ifndef TURTLEBROWSER_APPLICATIONSTATE_H
#define TURTLEBROWSER_APPLICATIONSTATE_H

#include "licenses/LicenseState.h"

namespace turtle_browser {

  class ApplicationState {
  public:
    licenses::LicenseState & licenseState() { return m_licenseState; }

  private:
    licenses::LicenseState m_licenseState;
  };

}

#endif //TURTLEBROWSER_APPLICATIONSTATE_H
