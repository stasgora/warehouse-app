import 'package:warehouse_app/model/json_convertible.dart';
import 'package:warehouse_app/model/offline/operation/operation.dart';

class StoredOperations implements JsonConvertible {
	List<Operation> operations = [];
	
  @override
  void fromJson(object) {
		operations..clear()..addAll((object as List).map((object) => Operation.typedFromJson(object)));
  }

  @override
  List<Map<String, dynamic>> toJson() => operations.map((e) => e.toJson()).toList();
}