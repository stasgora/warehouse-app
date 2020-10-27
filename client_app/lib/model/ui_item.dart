import 'package:equatable/equatable.dart';

import 'item.dart';

class UIItem extends Equatable {
	final String model;
	final String manufacturer;
	final int price;
	final int quantity;

  UIItem({this.model, this.manufacturer, this.price, this.quantity});
  UIItem.fromDBModel(Item item) : this(model: item.model, manufacturer: item.manufacturer, price: item.price, quantity: item.quantity);

  @override
  List<Object> get props => [model, manufacturer, price, quantity];
}
