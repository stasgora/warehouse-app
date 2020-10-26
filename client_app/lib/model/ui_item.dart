import 'package:equatable/equatable.dart';

import 'item.dart';

class UIItem extends Equatable {
	final String name;
	final String manufacturer;
	final int price;
	final int quantity;

  UIItem({this.name, this.manufacturer, this.price, this.quantity});
  UIItem.fromDBModel(Item item) : this(name: item.name, manufacturer: item.manufacturer, price: item.price, quantity: item.quantity);

  @override
  List<Object> get props => [name, manufacturer, price, quantity];
}
