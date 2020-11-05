enum BackendException {
	userNotAuthorized,
	noItemInStock
}

extension BackendExceptionCode on BackendException {
	String get code => const {
		BackendException.userNotAuthorized: 'PERMISSION_DENIED',
		BackendException.noItemInStock: 'RESOURCE_EXHAUSTED',
	}[this];
}

extension BackendExceptionDescription on BackendException {
	String get description => const {
		BackendException.userNotAuthorized: 'Nie masz wystarczających uprawnień',
		BackendException.noItemInStock: 'Brak wystarczającej ilości w magazynie',
	}[this];
}
