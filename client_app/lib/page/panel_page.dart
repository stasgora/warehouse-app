import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:warehouse_app/logic/item_list_cubit.dart';
import 'package:warehouse_app/model/app_page.dart';
import 'package:warehouse_app/model/ui_button.dart';
import 'package:warehouse_app/model/ui_item.dart';
import 'package:warehouse_app/widgets/loadable_bloc_builder.dart';
import 'package:warehouse_app/widgets/popup_menu_list.dart';

class PanelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('Panel'),
	    ),
	    body: LoadableBlocBuilder<ItemListCubit>(
			  builder: (context, state) => _buildItemList((state as ItemListLoadSuccess).items, context)
	    ),
	    floatingActionButton: FloatingActionButton(
		    child: Icon(Icons.add),
		    onPressed: () => pushItemPage(context),
	    ),
    );
  }

  void pushItemPage(BuildContext context, [UIItem item]) async {
  	var cubit = context.bloc<ItemListCubit>();
	  Navigator.of(context).pushNamed(
		  AppPage.itemPage.name,
		  arguments: {
		  	'mode': item != null ? AppFormType.edit : AppFormType.create,
			  'item': item,
			  'createCallback': cubit.createItem,
			  'editCallback': cubit.editItem
		  }
	  );
  }

  Widget _buildItemList(List<UIItem> items, BuildContext context) {
  	return ListView(
		  physics: BouncingScrollPhysics(),
		  children: [
		  	for (var item in items)
		  		Card(
					  child: ListTile(
						  title: Text(item.model),
						  subtitle: Text(item.manufacturer),
						  trailing: PopupMenuList(
							  items: [
								  UIButton('Edytuj', () => pushItemPage(context, item), null, Icons.edit),
								  UIButton('Zmień ilość', () => {}, null, Icons.multiple_stop),
								  UIButton('Usuń', () => {}, null, Icons.delete),
							  ],
						  ),
					  ),
				  )
		  ],
	  );
  }
}
