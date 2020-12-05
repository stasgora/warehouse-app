import 'package:warehouse_app/model/offline/operation/operation.dart';
import 'package:warehouse_app/model/offline/operation/operation_type.dart';

class DeleteOperation extends Operation {
	String id;

  DeleteOperation(this.id) : super(type: OperationType.delete);
	factory DeleteOperation.fromJson(dynamic object) => DeleteOperation(object['id'])..fromJson(object);

  @override
  Map<String, dynamic> toJson() {
	  var json = super.toJson();
	  json['id'] = id;
	  return json;
  }
}