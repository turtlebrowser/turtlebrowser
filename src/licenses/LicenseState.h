#ifndef TURTLEBROWSER_LICENSESTATE_H
#define TURTLEBROWSER_LICENSESTATE_H

#include "licenses/LicenseFilter.h"
#include "licenses/LicenseModel.h"

namespace turtle_browser::licenses {

  class LicenseState {
  public:

    LicenseState();

    LicenseFilter * searchModelWebLicenses() { return &m_filterLicenseModelWebView; }
    LicenseFilter * searchModelToolkitLicenses() { return &m_filterLicenseModelToolkit; }
    LicenseFilter * searchModelPlatformLicenses() { return &m_filterLicenseModelPlatform; }
    LicenseFilter * searchModelAllLicenses() { return &m_filterLicenseModelAll; }

  private:
    LicenseModel m_licenseModel;
    LicenseFilter m_filterLicenseModelWebView;
    LicenseFilter m_filterLicenseModelToolkit;
    LicenseFilter m_filterLicenseModelPlatform;
    LicenseFilter m_filterLicenseModelAll;
  };

}

#endif //TURTLEBROWSER_LICENSESTATE_H
