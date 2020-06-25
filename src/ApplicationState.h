#ifndef TURTLEBROWSER_APPLICATIONSTATE_H
#define TURTLEBROWSER_APPLICATIONSTATE_H

#include "licenses/LicenseFilter.h"
#include "licenses/LicenseModel.h"

namespace turtle_browser {

  class ApplicationState {
  public:

    ApplicationState();

    licenses::LicenseFilter * searchModelWebLicenses() { return &m_filterLicenseModelWebView; }
    licenses::LicenseFilter * searchModelToolkitLicenses() { return &m_filterLicenseModelToolkit; }
    licenses::LicenseFilter * searchModelPlatformLicenses() { return &m_filterLicenseModelPlatform; }
    licenses::LicenseFilter * searchModelAllLicenses() { return &m_filterLicenseModelAll; }

  private:
    licenses::LicenseModel m_licenseModel;
    licenses::LicenseFilter m_filterLicenseModelWebView;
    licenses::LicenseFilter m_filterLicenseModelToolkit;
    licenses::LicenseFilter m_filterLicenseModelPlatform;
    licenses::LicenseFilter m_filterLicenseModelAll;
  };

}

#endif //TURTLEBROWSER_APPLICATIONSTATE_H
