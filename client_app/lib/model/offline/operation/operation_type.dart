enum OperationType {
	edit, changeQuantity, delete, create
}

extension OperationTypeKey on OperationType {
	String get key => const {
		OperationType.edit: 'edit',
		OperationType.changeQuantity: 'changeQuantity',
		OperationType.delete: 'delete',
		OperationType.create: 'create',
	}[this];
}
