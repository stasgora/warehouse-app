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
  Future<List<Item>> fetchItems() => Future.value(_storageService.model.items.values.toList());

  @override
  Future removeItem(String id) => _storageService.execute((model) => model.items.remove(id));

	@override
	Future<User> getUser(String authId) {
	}

	@override
	Future createUser(User user) {
	}
}