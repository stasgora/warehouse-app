import 'package:cloud_functions/cloud_functions.dart';
import 'package:warehouse_app/model/item.dart';
import 'package:warehouse_app/model/user.dart';

class BackendService {
	var _api = CloudFunctions.instance.useFunctionsEmulator(origin: 'http://10.0.2.2:5521');
	var _apiVersion = 1.0;

	Future<List<Item>> fetchItems() async => (await _executeItem('getAll') as List).map((element) => Item.fromJson(Map.from(element))).toList();

	Future<int> changeQuantity(String id, int quantityChange) async => await _executeItem('changeQuantity', {'id': id, 'change': quantityChange});
	Future editItem(Item item) => _executeItem('edit', {'item': item.toJson()});

	Future createItem(Item item) => _executeItem('create', {'item': item.toJson()});
	Future removeItem(String id) => _executeItem('remove', {'id': id});

	Future<User> getUser(String authId) async => User.fromJson((await _executeUser('get', {'authId': authId})));
	Future createUser(User user) => _executeUser('create', {'user': user.toJson()});

	Future<dynamic> _executeItem(String function, [Map<String, dynamic> args]) => _execute(function, 'items', args);
	Future<dynamic> _executeUser(String function, [Map<String, dynamic> args]) => _execute(function, 'users', args);

	Future<dynamic> _execute(String function, String category, [Map<String, dynamic> args]) async {
		args ??= {};
		args['apiVersion'] = _apiVersion;
		return (await _api.getHttpsCallable(functionName: '$category-$function').call(args)).data;
	}
}
