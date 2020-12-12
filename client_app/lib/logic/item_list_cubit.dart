import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/logic/reloadable/reloadable_cubit.dart';
import 'package:warehouse_app/model/db/item.dart';
import 'package:warehouse_app/model/ui/ui_item.dart';
import 'package:warehouse_app/services/api/operation_service.dart';
import 'package:warehouse_app/services/connectivity_service.dart';
import 'package:warehouse_app/services/api/interface/data_service.dart';
import 'package:warehouse_app/services/exceptions.dart';

class ItemListCubit extends ReloadableCubit {
	final ApiService _dataService = GetIt.I<ApiService>();
	final _operations = GetIt.I<OperationService>();
	final _connectivityService = GetIt.I<ConnectivityService>();

  ItemListCubit(ModalRoute<Object> modalRoute) : super(modalRoute);

  @override
  Future doLoadData({List<String> syncStatus}) async {
  	var items = (await _dataService.fetchItems()).map((item) => UIItem.fromDBModel(item)).toList();
  	emit(ItemListLoadSuccess(items: items, connectionOverride: _connectivityService.override, syncStatus: syncStatus));
  	if (syncStatus != null) {
		  Timer.periodic(Duration(seconds: 2), (timer) {
			  syncStatus = List.from(syncStatus)..removeAt(0);
			  emit((state as ItemListLoadSuccess).copyWith(syncStatus: List.from(syncStatus)));
			  if (syncStatus.isEmpty)
			  	timer.cancel();
		  });
	  }
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

	void setNetworkOverride(bool override) async {
	  _connectivityService.override = override;
	  emit((state as ItemListLoadSuccess).copyWith(overrideConnected: override));
	  if (await _connectivityService.hasConnectivity()) {
		  var syncStatus = await _operations.synchronize();
		  doLoadData(syncStatus: syncStatus);
	  }
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
	final List<String> syncStatus;

	ItemListLoadSuccess({this.items, this.exception, this.syncStatus, this.connectionOverride = true});
	ItemListLoadSuccess copyWith({List<UIItem> items, BackendException exception, List<String> syncStatus, bool overrideConnected}) {
		return ItemListLoadSuccess(
			items: items ?? this.items,
			exception: exception,
			syncStatus: syncStatus,
			connectionOverride: overrideConnected ?? this.connectionOverride
		);
	}

	@override
	List<Object> get props => [items, exception, connectionOverride, syncStatus];
}
