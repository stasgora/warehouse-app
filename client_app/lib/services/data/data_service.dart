import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/db/user.dart';

abstract class DataService {
	Future<List<Item>> fetchItems();

	Future<int> changeQuantity(String id, int quantityChange);
	Future editItem(Item item);

	Future createItem(Item item);
	Future removeItem(String id);

	Future<User> getUser(String authId);
	Future createUser(User user);
}