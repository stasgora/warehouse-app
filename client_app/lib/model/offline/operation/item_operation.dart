import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/offline/operation/operation.dart';
import 'package:warehouse_app/model/offline/operation/operation_type.dart';

class ItemOperation extends Operation {
	Item item;

	ItemOperation(this.item);
	ItemOperation.edit(this.item) : super(type: OperationType.edit);
	ItemOperation.create(this.item) : super(type: OperationType.create);

	factory ItemOperation.fromJson(dynamic object) => ItemOperation(Item.fromJson(object))..fromJson(object);

  @override
  Map<String, dynamic> toJson() {
		var json = super.toJson();
		json['item'] = item.toJson();
		return json;
  }
}
