import 'package:warehouse_app/model/db/item.dart';

import '../json_convertible.dart';

class StoredItems implements JsonConvertible {
	final Map<String, Item> items = {};
	
	@override
	List<Map<String, dynamic>> toJson() => items.values.map((e) => e.toJson()).toList();

	@override
	void fromJson(object) {
		items..clear()..addEntries((object as List).map((map) => MapEntry(map['id'], Item.fromJson(map))));
	}
}
