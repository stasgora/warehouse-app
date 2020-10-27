import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/model/backend_connector.dart';
import 'package:warehouse_app/model/ui_item.dart';

part 'item_list_state.dart';

class ItemListCubit extends Cubit<ItemListState> {
	final BackendConnector _backendConnector = GetIt.I<BackendConnector>();

  ItemListCubit() : super(ItemListInitial());

  Future loadItems() async {
  	var items = (await _backendConnector.fetchItems()).map((item) => UIItem.fromDBModel(item)).toList();
  	emit(ItemListLoadSuccess(items));
  }
}
