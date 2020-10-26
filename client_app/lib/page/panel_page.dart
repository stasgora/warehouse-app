import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_app/logic/item_list/item_list_cubit.dart';
import 'package:warehouse_app/model/ui_item.dart';

class PanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('Panel'),
	    ),
	    body: BlocBuilder<ItemListCubit, ItemListState>(
			  builder: (context, state) {
				  if (state is ItemListInitial) {
				  	context.bloc<ItemListCubit>().loadItems();
					  return Center(child: CircularProgressIndicator());
				  }
				  return _buildItemList((state as ItemListLoadSuccess).items);
			  }
	    ),
    );
  }

  Widget _buildItemList(List<UIItem> items) {
  	return ListView(
		  physics: BouncingScrollPhysics(),
		  children: [
		  	for (var item in items)
		  		Card(
					  child: ListTile(
						  title: Text(item.name),
						  subtitle: Text(item.manufacturer),
						  trailing: IconButton(
							  icon: Icon(Icons.more_vert),
							  onPressed: () {},
						  ),
					  ),
				  )
		  ],
	  );
  }
}
