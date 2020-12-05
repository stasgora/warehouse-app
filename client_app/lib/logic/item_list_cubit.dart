import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/logic/reloadable/reloadable_cubit.dart';
import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/ui/ui_item.dart';
import 'package:warehouse_app/services/connectivity_service.dart';
import 'package:warehouse_app/services/api/interface/data_service.dart';
import 'package:warehouse_app/services/exceptions.dart';

class ItemListCubit extends ReloadableCubit {
	final ApiService _dataService = GetIt.I<ApiService>();
	final _connectivityService = GetIt.I<ConnectivityService>();

  ItemListCubit(ModalRoute<Object> modalRoute) : super(modalRoute);

  @override
  Future doLoadData() async {
  	var items = (await _dataService.fetchItems()).map((item) => UIItem.fromDBModel(item)).toList();
  	emit(ItemListLoadSuccess(items: items, connectionOverride: _connectivityService.override));
  }

	Future createItem(UIItem item) => _dataService.createItem(Item.fromUIModel(item));
	Future editItem(UIItem item) => _dataService.editItem(Item.fromUIModel(item));

	Future changeItemQuantity(UIItem item, int quantityChange) async {
		var state = this.state as ItemListLoadSuccess;
	  try {
		  var quantity = await _dataService.changeQuantity(item.id, quantityChange);
		  var newList = List.of(state.items);
		  newList[newList.indexOf(item)] = item.copyWith(quantity: quantity);
		  emit(state.copyWith(items: newList));
	  } on BackendException catch(e) {
	  	emit(state.copyWith(exception: e));
	  }
	}

	void setNetworkOverride(bool override) {
	  _connectivityService.override = override;
	  emit((state as ItemListLoadSuccess).copyWith(overrideConnected: override));
	  doLoadData();
	}

	Future removeItem(UIItem item) async {
		var state = this.state as ItemListLoadSuccess;
		try {
		  await _dataService.removeItem(item.id);
		  var newList = List.of(state.items)..remove(item);
		  emit(state.copyWith(items: newList));
		} on BackendException catch(e) {
			emit(state.copyWith(exception: e));
		}
	}
}

class ItemListLoadSuccess extends DataLoadSuccess {
	final List<UIItem> items;
	final bool connectionOverride;
	final BackendException exception;

	ItemListLoadSuccess({this.items, this.exception, this.connectionOverride = true});
	ItemListLoadSuccess copyWith({List<UIItem> items, BackendException exception, bool overrideConnected}) {
		return ItemListLoadSuccess(
			items: items ?? this.items,
			exception: exception,
			connectionOverride: overrideConnected ?? this.connectionOverride
		);
	}

	@override
	List<Object> get props => [items, exception, connectionOverride];
}
