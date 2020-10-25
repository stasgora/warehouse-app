part of 'item_list_cubit.dart';

abstract class ItemListState extends Equatable {
  const ItemListState();
}

class ItemListInitial extends ItemListState {
  @override
  List<Object> get props => [];
}
