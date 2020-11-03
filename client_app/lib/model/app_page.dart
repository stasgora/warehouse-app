enum AppPage {
  loadingPage, signInPage, signUpPage, panelPage, itemPage
}

extension AppPageName on AppPage {
	String get name => const {
		AppPage.loadingPage: '/loading',
		AppPage.signInPage: '/signIn',
		AppPage.signUpPage: '/signUp',
		AppPage.panelPage: '/panel',
		AppPage.itemPage: '/item',
	}[this];
}

enum AppFormType { create, edit, copy }
