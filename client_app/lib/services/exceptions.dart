enum BackendException {
	userNotAuthorized,
	noItemInStock,
	itemNotFound
}

extension BackendExceptionCode on BackendException {
	String get code => const {
		BackendException.userNotAuthorized: 'PERMISSION_DENIED',
		BackendException.noItemInStock: 'RESOURCE_EXHAUSTED',
		BackendException.itemNotFound: 'NOT_FOUND',
	}[this];
}

extension BackendExceptionDescription on BackendException {
	String get description => const {
		BackendException.userNotAuthorized: 'Nie masz wystarczających uprawnień',
		BackendException.noItemInStock: 'Brak wystarczającej ilości w magazynie',
		BackendException.itemNotFound: 'Przedmiot nie istnieje',
	}[this];
}
