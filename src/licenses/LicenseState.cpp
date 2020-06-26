#include "LicenseState.h"

namespace turtle_browser::licenses {

  namespace {
    void connectSearchModel(LicenseModel & model,
                            LicenseFilter & search_model,
                            LicenseCategory category) {
      search_model.setCategory(category);
      search_model.setSourceModel(&model);
      search_model.sort(0);
      search_model.setFilterKeyColumn(0);
      search_model.setFilterRole(Qt::DisplayRole);
      search_model.setRecursiveFilteringEnabled(true);
      search_model.setFilterCaseSensitivity(Qt::CaseInsensitive);
      search_model.setSortCaseSensitivity(Qt::CaseInsensitive);
    }
  }

  LicenseState::LicenseState() {
    connectSearchModel(m_licenseModel, m_filterLicenseModelWebView, LicenseCategory::WebView);
    connectSearchModel(m_licenseModel, m_filterLicenseModelToolkit, LicenseCategory::Toolkit);
    connectSearchModel(m_licenseModel, m_filterLicenseModelPlatform, LicenseCategory::Platform);
    connectSearchModel(m_licenseModel, m_filterLicenseModelAll, LicenseCategory::All);
  }

}
