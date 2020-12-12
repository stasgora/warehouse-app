import 'package:warehouse_app/model/db/item.dart';

abstract class ItemApiService {
	Future<int> changeQuantity(String id, int quantityChange);
	Future editItem(Item item);

	Future<String> createItem(Item item);
	Future removeItem(String id);
}