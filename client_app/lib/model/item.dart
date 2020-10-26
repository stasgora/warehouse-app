class Item {
	String name;
	String manufacturer;
	int price;
	int quantity;

	Item({this.name, this.manufacturer, this.price, this.quantity});

	factory Item.fromJson(Map<String, dynamic> json) {
		return json != null ? Item(
			name: json['name'],
			manufacturer: json['manufacturer'],
			price: json['price'],
			quantity: json['quantity'],
		) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = {};
		data['name'] = name;
		data['manufacturer'] = manufacturer;
		data['price'] = price;
		data['quantity'] = quantity;
		return data;
	}
}
