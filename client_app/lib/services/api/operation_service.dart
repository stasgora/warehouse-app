import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/offline/operation/change_quantity_operation.dart';
import 'package:warehouse_app/model/offline/operation/delete_operation.dart';
import 'package:warehouse_app/model/offline/operation/item_operation.dart';
import 'package:warehouse_app/model/offline/operation/operation.dart';
import 'package:warehouse_app/model/offline/operation/operation_type.dart';
import 'package:warehouse_app/model/offline/stored_operations.dart';
import 'package:warehouse_app/services/exceptions.dart';
import 'package:warehouse_app/services/api/interface/item_api_service.dart';
import 'package:warehouse_app/services/exceptions.dart';
import 'package:warehouse_app/model/offline/operation/operation_type.dart';
import 'package:warehouse_app/services/storage/json_storage.dart';

import 'interface/data_service.dart';

class OperationService implements ItemApiService {
	ApiService dataService;
	final _operationService = JsonStorage('operations.json', StoredOperations());

  @override
  Future<int> changeQuantity(String id, int quantityChange) async {
    return _operationService.execute((model) {
      model.operations.add((ChangeQuantityOperation(id: id, quantity: quantityChange)));
      return 0;
    });
  }

  @override
  Future createItem(Item item)  => _saveOperation(ItemOperation.create(item));

  @override
  Future editItem(Item item)  => _saveOperation(ItemOperation.edit(item));

  @override
  Future removeItem(String id)  => _saveOperation(DeleteOperation(id));

  Future _saveOperation(Operation operation) => _operationService.execute((model) => model.operations.add(operation));
  
  Future<List<String>> synchronize() async {
	  List<String> status = [];
	  for (var op in (await _operationService.model).operations) {
		  try {
			  if (op is ItemOperation)
				  await (op.type == OperationType.edit ? dataService.editItem(op.item) : dataService.createItem(op.item));
			  else if (op is DeleteOperation)
				  await dataService.removeItem(op.id);
			  else if (op is ChangeQuantityOperation)
				  await dataService.changeQuantity(op.id, op.quantity);
			  status.add('Sukces: $op');
		  } catch(e) {
		  	if (e is BackendException)
				  status.add('$op: ${e.description}');
		  	else
		  		status.add('Wystąpił błąd synchronizacji');
		  }
	  }
	  await _operationService.execute((model) => model.operations.clear());
	  return status;
  }
}
