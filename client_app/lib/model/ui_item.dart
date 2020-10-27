import 'package:equatable/equatable.dart';

import 'item.dart';

class UIItem extends Equatable {
	final String id;
	final String model;
	final String manufacturer;
	final int price;
	final int quantity;

  UIItem({this.id, this.model, this.manufacturer, this.price, this.quantity});
  UIItem.fromDBModel(Item item) : this(id: item.id, model: item.model, manufacturer: item.manufacturer, price: item.price, quantity: item.quantity);

  @override
  List<Object> get props => [model, manufacturer, price, quantity, id];
}
