import 'package:warehouse_app/model/offline/operation/change_quantity_operation.dart';
import 'package:warehouse_app/model/offline/operation/delete_operation.dart';
import 'package:warehouse_app/model/offline/operation/item_operation.dart';

import 'operation_type.dart';

abstract class Operation {
	int timestamp;
	OperationType type;

  Operation({this.type}) : timestamp = DateTime.now().millisecondsSinceEpoch;

  void fromJson(dynamic object) {
		timestamp = object['timestamp'];
		type = OperationType.values[object['type']];
  }

  factory Operation.typedFromJson(dynamic object) {
		if (object['type'] == OperationType.edit.key || object['type'] == OperationType.create.key)
			return ItemOperation.fromJson(object);
		else if (object['type'] == OperationType.delete.key)
			return DeleteOperation.fromJson(object);
		else if (object['type'] == OperationType.changeQuantity.key)
			return ChangeQuantityOperation.fromJson(object);
		return null;
  }

	Map<String, dynamic> toJson() {
		return {
			'timestamp': timestamp,
			'type': type.index
		};
  }
}
