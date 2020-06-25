#ifndef TURTLEBROWSER_CONTEXT_H
#define TURTLEBROWSER_CONTEXT_H

#include "licenses/LicenseFilter.h"
#include "licenses/LicenseModel.h"

class Context {
public:

  Context();

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

  static void connectSearchModel(licenses::LicenseModel & model, licenses::LicenseFilter & search_model, licenses::LicenseCategory category);
};

#endif //TURTLEBROWSER_CONTEXT_H
