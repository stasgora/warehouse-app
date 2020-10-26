import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_app/model/ui_item.dart';

part 'item_list_state.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit() : super(ItemListInitial());

  Future loadItems() async {
  	await Future.delayed(Duration(microseconds: 1));
  	emit(ItemListLoadSuccess([UIItem(name: 'Test', manufacturer: 'Someone')]));
  }
}
