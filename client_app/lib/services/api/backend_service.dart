import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/db/user.dart';
import 'package:warehouse_app/model/offline/operation/operation.dart';
import 'package:warehouse_app/services/exceptions.dart';

import 'interface/data_service.dart';

class BackendService implements ApiService {
	var _api = CloudFunctions.instance.useFunctionsEmulator(origin: 'http://10.0.2.2:5521');
	var _apiVersion = 1.0;

	@override
	Future<List<Item>> fetchItems() async => (await _executeItem('getAll') as List).map((element) => Item.fromJson(Map.from(element))).toList();

	@override
	Future<int> changeQuantity(String id, int quantityChange) async => await _executeItem('changeQuantity', {'id': id, 'change': quantityChange});
	@override
	Future editItem(Item item) => _executeItem('edit', {'item': item.toJson()});

	@override
	Future createItem(Item item) => _executeItem('create', {'item': item.toJson()});
	@override
	Future removeItem(String id) => _executeItem('remove', {'id': id});

	@override
	Future<User> getUser(String authId) async => User.fromJson((await _executeUser('get', {'authId': authId})));
	@override
	Future createUser(User user) => _executeUser('create', {'user': user.toJson()});

	Future syncOperations(List<Operation> operations) => _execute('synchronize', 'operations', {'ops': operations.map((e) => e.toJson()).toList()});

	Future<dynamic> _executeItem(String function, [Map<String, dynamic> args]) => _execute(function, 'items', args);
	Future<dynamic> _executeUser(String function, [Map<String, dynamic> args]) => _execute(function, 'users', args);

	Future<dynamic> _execute(String function, String category, [Map<String, dynamic> args]) async {
		args ??= {};
		args['apiVersion'] = _apiVersion;
		try {
			return (await _api.getHttpsCallable(functionName: '$category-$function').call(args)).data;
		} on PlatformException catch(e) {
			for (var error in BackendException.values) {
				if (e.details['code'] == error.code)
					throw error;
			}
			throw e;
		}
	}
}
