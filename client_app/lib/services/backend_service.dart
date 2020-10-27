import 'package:cloud_functions/cloud_functions.dart';
import 'package:warehouse_app/model/item.dart';

class BackendService {
	var _api = CloudFunctions.instance.useFunctionsEmulator(origin: 'http://10.0.2.2:5521');

	Future<List<Item>> fetchItems() async => (await _execute('getItems') as List).map((element) => Item.fromJson(Map.from(element))).toList();

	Future changeQuantity(String id, int quantityChange) => _execute('changeQuantity', {'id': id, 'change': quantityChange});
	Future editItem(Item item) => _execute('editItem', item.toJson());

	Future createItem(Item item) => _execute('createItem', item.toJson());
	Future removeItem(String id) => _execute('removeItem', {'id': id});
	
	Future<dynamic> _execute(String function, [dynamic args]) async => (await _api.getHttpsCallable(functionName: 'db-$function').call(args)).data;
}
