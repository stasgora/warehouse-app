import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/logic/reloadable/reloadable_cubit.dart';
import 'package:warehouse_app/model/item.dart';
import 'package:warehouse_app/services/backend_service.dart';
import 'package:warehouse_app/model/ui_item.dart';
import 'package:warehouse_app/services/exceptions.dart';

class ItemListCubit extends ReloadableCubit {
	final BackendService _backendConnector = GetIt.I<BackendService>();

  ItemListCubit(ModalRoute<Object> modalRoute) : super(modalRoute);

  @override
  Future doLoadData() async {
  	var items = (await _backendConnector.fetchItems()).map((item) => UIItem.fromDBModel(item)).toList();
  	emit(ItemListLoadSuccess(items));
  }

	Future createItem(UIItem item) => _backendConnector.createItem(Item.fromUIModel(item));
	Future editItem(UIItem item) => _backendConnector.editItem(Item.fromUIModel(item));

	Future changeItemQuantity(UIItem item, int quantityChange) async {
		var state = this.state as ItemListLoadSuccess;
	  try {
		  var quantity = await _backendConnector.changeQuantity(item.id, quantityChange);
		  var newList = List.of(state.items);
		  newList[newList.indexOf(item)] = item.copyWith(quantity: quantity);
		  emit(ItemListLoadSuccess(newList));
	  } on BackendException catch(e) {
	  	emit(state.copyWith(exception: e));
	  }
	}

	Future removeItem(UIItem item) async {
		var state = this.state as ItemListLoadSuccess;
		try {
		  await _backendConnector.removeItem(item.id);
		  var newList = List.of(state.items)..remove(item);
		  emit(ItemListLoadSuccess(newList));
		} on BackendException catch(e) {
			emit(state.copyWith(exception: e));
		}
	}
}

class ItemListLoadSuccess extends DataLoadSuccess {
	final List<UIItem> items;
	final BackendException exception;

	ItemListLoadSuccess(this.items, [this.exception]);
	ItemListLoadSuccess copyWith({List<UIItem> items, BackendException exception}) {
		return ItemListLoadSuccess(
			items ?? this.items,
			exception
		);
	}

	@override
	List<Object> get props => [items, exception];
}
