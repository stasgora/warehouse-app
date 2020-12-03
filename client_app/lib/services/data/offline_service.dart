import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/db/user.dart';
import 'package:warehouse_app/model/stored_items.dart';
import 'package:warehouse_app/services/data/data_service.dart';
import 'package:warehouse_app/services/storage/json_storage.dart';

class OfflineService implements DataService {
	final _storageService = JsonStorage('items.json', StoredItems());

  @override
  Future<int> changeQuantity(String id, int quantityChange) => _storageService.execute((model) => model.items[id].quantity += quantityChange);

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