import 'package:warehouse_app/model/db/item.dart';

import 'json_convertible.dart';

class StoredItems implements JsonConvertible {
	final Map<String, Item> items = {};
	
	@override
	List<Map<String, dynamic>> toJson() => items.values.map((e) => e.toJson()).toList();

	@override
	void fromJson(object) {
		List<Map<String, dynamic>> json = object;
		items..clear()..addEntries(json.map((map) => MapEntry(map['id'], Item.fromJson(map))));
	}
}
