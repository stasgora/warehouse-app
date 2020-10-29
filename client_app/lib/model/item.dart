import 'package:warehouse_app/model/ui_item.dart';

class Item {
	String id;
	String model;
	String manufacturer;
	double price;
	int quantity;

	Item({this.id, this.model, this.manufacturer, this.price, this.quantity});
	Item.fromUIModel(UIItem item) : this(id: item.id, model: item.model, manufacturer: item.manufacturer, price: item.price, quantity: item.quantity);

	factory Item.fromJson(Map<String, dynamic> json) {
		return json != null ? Item(
			id: json['id'],
			model: json['model'],
			manufacturer: json['manufacturer'],
			price: json['price']?.toDouble(),
			quantity: json['quantity'],
		) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = {};
		if (id != null)
			data['id'] = id;
		if (model != null)
			data['model'] = model;
		if (manufacturer != null)
			data['manufacturer'] = manufacturer;
		if (price != null)
			data['price'] = price;
		if (quantity != null)
			data['quantity'] = quantity;
		return data;
	}
}
