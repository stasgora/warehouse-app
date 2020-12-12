enum OperationType {
	edit, changeQuantity, delete, create
}

extension OperationTypeName on OperationType {
	String get name => const {
		OperationType.edit: 'Edycja towaru',
		OperationType.create: 'Nowy towar',
		OperationType.changeQuantity: 'Zmiana ilości',
		OperationType.delete: 'Usunięcie towaru',
	}[this];
}
