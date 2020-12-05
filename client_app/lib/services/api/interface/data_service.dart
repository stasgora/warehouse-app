import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/db/user.dart';
import 'package:warehouse_app/services/api/interface/item_api_service.dart';

abstract class ApiService extends ItemApiService {
	Future<List<Item>> fetchItems();

	Future<User> getUser(String authId);
	Future createUser(User user);
}