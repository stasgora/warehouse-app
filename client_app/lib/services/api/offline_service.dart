import 'package:get_it/get_it.dart';
import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/db/user.dart';
import 'package:warehouse_app/model/offline/stored_items.dart';
import 'package:warehouse_app/services/api/interface/data_service.dart';
import 'package:warehouse_app/services/connectivity_service.dart';
import 'package:warehouse_app/services/exceptions.dart';
import 'package:warehouse_app/services/storage/json_storage.dart';

class OfflineService implements ApiService {
	final _connectivityService = GetIt.I<ConnectivityService>();
	final _storageService = JsonStorage('items.json', StoredItems());

  @override
  Future<int> changeQuantity(String id, int quantityChange) => _storageService.execute((model) {
  	if (model.items[id].quantity + quantityChange < 0)
  		throw BackendException.noItemInStock;
    return model.items[id].quantity += quantityChange;
  });

  @override
  Future createItem(Item item) => _storageService.execute((model) => model.items[item.id] = item);

  @override
  Future editItem(Item item) => _storageService.execute((model) => model.items[item.id] = item);

  @override
  Future<List<Item>> fetchItems() async => (await _storageService.model).items.values.toList();

  @override
  Future removeItem(String id) => _storageService.execute((model) => model.items.remove(id));

  Future refreshItems(List<Item> items) {
    return _storageService.execute((model) => model.items..clear()..addEntries(items.map((e) => MapEntry(e.id, e))));
  }

	@override
	Future<User> getUser(String authId) {
		throw UnsupportedError('Offline caching does not support users');
	}

	@override
	Future createUser(User user) {
		throw UnsupportedError('Offline caching does not support users');
	}
}