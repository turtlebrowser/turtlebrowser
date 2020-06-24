#include "Context.h"

#include "licenses/LicenseCategory.h"

Context::Context() {
  connectSearchModel(&m_licenseModel, m_filterLicenseModelWebView, licenses::LicenseCategory::WebView);
  connectSearchModel(&m_licenseModel, m_filterLicenseModelToolkit, licenses::LicenseCategory::Toolkit);
  connectSearchModel(&m_licenseModel, m_filterLicenseModelPlatform, licenses::LicenseCategory::Platform);
  connectSearchModel(&m_licenseModel, m_filterLicenseModelAll, licenses::LicenseCategory::All);
}

void Context::connectSearchModel(licenses::LicenseModel * model, licenses::LicenseFilter & search_model, licenses::LicenseCategory category) {
  search_model.setCategory(category);
  search_model.setSourceModel(model);
  search_model.sort(0);
  search_model.setFilterKeyColumn(0);
  search_model.setFilterRole(Qt::DisplayRole);
  search_model.setRecursiveFilteringEnabled(true);
  search_model.setFilterCaseSensitivity(Qt::CaseInsensitive);
  search_model.setSortCaseSensitivity(Qt::CaseInsensitive);
}
