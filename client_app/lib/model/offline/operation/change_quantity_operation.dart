import 'package:warehouse_app/model/offline/operation/operation.dart';
import 'package:warehouse_app/model/offline/operation/operation_type.dart';

class ChangeQuantityOperation extends Operation {
	String id;
	int quantity;

  ChangeQuantityOperation({this.id, this.quantity}) : super(type: OperationType.changeQuantity);
	factory ChangeQuantityOperation.fromJson(dynamic object) {
	  return ChangeQuantityOperation(
		  id: object['id'],
		  quantity: object['quantity'].toInt()
	  )..fromJson(object);
	}

  @override
  Map<String, dynamic> toJson() {
	  var json = super.toJson();
	  json['id'] = id;
	  json['quantity'] = quantity;
	  return json;
  }

	@override
  String toString() => '${super.toString()} ($quantity)';
}