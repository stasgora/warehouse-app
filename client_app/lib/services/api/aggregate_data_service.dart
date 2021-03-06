import 'package:get_it/get_it.dart';
import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/db/user.dart';
import 'package:warehouse_app/services/connectivity_service.dart';
import 'package:warehouse_app/services/api/backend_service.dart';
import 'package:warehouse_app/services/api/interface/data_service.dart';
import 'package:warehouse_app/services/api/offline_service.dart';

import 'interface/item_api_service.dart';
import 'operation_service.dart';

class AggregateDataService implements ApiService {
	final _backend = BackendService();
	final _offline = OfflineService();
	final _operations = GetIt.I<OperationService>();
	final _connectivityService = GetIt.I<ConnectivityService>();

	AggregateDataService() {
		_operations.dataService = this;
	}

  @override
	Future<List<Item>> fetchItems() async {
		List<Item> items;
		if (await _connectivityService.hasConnectivity()) {
			items = await _backend.fetchItems();
			_offline.refreshItems(items);
		} else
			items = await _offline.fetchItems();
		return items;
	}

  @override
  Future<int> changeQuantity(String id, int quantityChange) async => _executeUpdate((service) => service.changeQuantity(id, quantityChange));

  @override
  Future<String> createItem(Item item) => _executeUpdate((service) => service.createItem(item));

  @override
  Future editItem(Item item) => _executeUpdate((service) => service.editItem(item));

  @override
  Future removeItem(String id) => _executeUpdate((service) => service.removeItem(id));

	Future<T> _executeUpdate<T>(Future Function(ItemApiService) operation) async {
		var hasConnectivity = await _connectivityService.hasConnectivity();
		T value;
		try {
			value = await operation(_offline);
		} catch(e) {
			if (!hasConnectivity)
				throw e;
		}
		if (hasConnectivity)
			value = await operation(_backend);
		else
			operation(_operations);
		return value;
	}

  @override
  Future<User> getUser(String authId) async => _backend.getUser(authId);

  @override
  Future createUser(User user) async => _backend.createUser(user);
}