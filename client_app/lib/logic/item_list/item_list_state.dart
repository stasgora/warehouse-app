part of 'item_list_cubit.dart';

abstract class ItemListState extends Equatable {
  @override
  List<Object> get props => [];
}

class ItemListInitial extends ItemListState {}

class ItemListLoadSuccess extends ItemListState {
	final List<UIItem> items;

	ItemListLoadSuccess(this.items);

	@override
	List<Object> get props => [items];
}
