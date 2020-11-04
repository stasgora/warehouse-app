import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/logic/reloadable/reloadable_cubit.dart';
import 'package:warehouse_app/model/item.dart';
import 'package:warehouse_app/services/backend_service.dart';
import 'package:warehouse_app/model/ui_item.dart';

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
	  var quantity = await _backendConnector.changeQuantity(item.id, quantityChange);
	  var newList = List.of((state as ItemListLoadSuccess).items);
	  newList[newList.indexOf(item)] = item.copyWith(quantity: quantity);
	  emit(ItemListLoadSuccess(newList));
	}

	Future removeItem(UIItem item) async {
	  await _backendConnector.removeItem(item.id);
	  var newList = List.of((state as ItemListLoadSuccess).items)..remove(item);
	  emit(ItemListLoadSuccess(newList));
	}
}

class ItemListLoadSuccess extends DataLoadSuccess {
	final List<UIItem> items;

	ItemListLoadSuccess(this.items);

	@override
	List<Object> get props => [items];
}
