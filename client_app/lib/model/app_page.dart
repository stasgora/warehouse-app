enum AppPage {
  loginPage, panelPage, itemPage
}

extension AppPageName on AppPage {
	String get name => const {
		AppPage.loginPage: '/login',
		AppPage.panelPage: '/panel',
		AppPage.itemPage: '/item',
	}[this];
}

enum AppFormType { create, edit, copy }
