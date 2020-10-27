class Item {
	String model;
	String manufacturer;
	int price;
	int quantity;

	Item({this.model, this.manufacturer, this.price, this.quantity});

	factory Item.fromJson(Map<String, dynamic> json) {
		return json != null ? Item(
			model: json['model'],
			manufacturer: json['manufacturer'],
			price: json['price'],
			quantity: json['quantity'],
		) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = {};
		data['model'] = model;
		data['manufacturer'] = manufacturer;
		data['price'] = price;
		data['quantity'] = quantity;
		return data;
	}
}
