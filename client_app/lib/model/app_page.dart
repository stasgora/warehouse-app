enum AppPage {
  login, panel
}

extension AppPageName on AppPage {
	String get name => const {
		AppPage.login: '/login',
		AppPage.panel: '/panel'
	}[this];
}