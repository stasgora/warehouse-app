import 'package:cloud_functions/cloud_functions.dart';
import 'package:warehouse_app/model/item.dart';

class BackendService {
	var _api = CloudFunctions.instance.useFunctionsEmulator(origin: 'http://10.0.2.2:5521');
	var _apiVersion = 1.0;

	Future<List<Item>> fetchItems() async => (await _execute('getItems') as List).map((element) => Item.fromJson(Map.from(element))).toList();

	Future changeQuantity(String id, int quantityChange) => _execute('changeQuantity', {'id': id, 'change': quantityChange});
	Future editItem(Item item) => _execute('editItem', {'item': item.toJson()});

	Future createItem(Item item) => _execute('createItem', {'item': item.toJson()});
	Future removeItem(String id) => _execute('removeItem', {'id': id});
	
	Future<dynamic> _execute(String function, [Map<String, dynamic> args]) async {
		args ??= {};
		args['apiVersion'] = _apiVersion;
	  return (await _api.getHttpsCallable(functionName: 'db-$function').call(args)).data;
	}
}
