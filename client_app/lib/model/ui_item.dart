import 'package:equatable/equatable.dart';

import 'item.dart';

class UIItem extends Equatable {
	final String id;
	final String model;
	final String manufacturer;
	final double price;
	final int quantity;

  UIItem({this.id, this.model, this.manufacturer, this.price, this.quantity = 0});
	UIItem.fromDBModel(Item item) : this(id: item.id, model: item.model, manufacturer: item.manufacturer, price: item.price, quantity: item.quantity);
	UIItem.from(UIItem item) : this(id: item.id, model: item.model, manufacturer: item.manufacturer, price: item.price, quantity: item.quantity);

	UIItem copyWith({String model, String manufacturer, double price, int quantity}) {
		return UIItem(
			id: id,
			model: model ?? this.model,
			manufacturer: manufacturer ?? this.manufacturer,
			price: price ?? this.price,
			quantity: quantity ?? this.quantity,
		);
	}

  @override
  List<Object> get props => [model, manufacturer, price, quantity, id];
}
