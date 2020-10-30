import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:warehouse_app/logic/item_list_cubit.dart';
import 'package:warehouse_app/model/app_page.dart';
import 'package:warehouse_app/model/ui_button.dart';
import 'package:warehouse_app/model/ui_item.dart';
import 'package:warehouse_app/widgets/app_dialog.dart';
import 'package:warehouse_app/widgets/form_fields.dart';
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
						  title: Text(item.model, maxLines: 1, overflow: TextOverflow.ellipsis),
						  subtitle: Text('Producent: ${item.manufacturer}', maxLines: 1, overflow: TextOverflow.ellipsis),
						  trailing: PopupMenuList(
							  items: [
								  UIButton('Edytuj', () => pushItemPage(context, item), null, Icons.edit),
								  UIButton('Zwiększ ilość', () => showQuantityDialog(item, context, adding: true), null, Icons.add),
								  UIButton('Zmniejsz ilość', () => showQuantityDialog(item, context, adding: false), null, Icons.remove),
								  UIButton('Usuń', () => context.bloc<ItemListCubit>().removeItem(item), null, Icons.delete),
							  ],
						  ),
					  ),
				  )
		  ],
	  );
  }

  Future showQuantityDialog(UIItem item, BuildContext context, {bool adding}) {
	  TextEditingController _quantityController = TextEditingController();
	  int quantity = 0;
  	return showDialog(
		  context: context,
		  builder: (ctx) => AppDialog(
			  title: '${adding ? 'Zwiększ' : 'Zmniejsz'} ilość (${item.model})',
			  fields: [
				  buildNumberField(
					  context: ctx,
					  title: 'Zmiana',
					  icon: Icons.dynamic_feed,
					  controller: _quantityController,
					  onChanged: (val) => quantity = val.isNotEmpty ? int.parse(val) : 0,
				  )
			  ],
			  onConfirm: () async {
			    await context.bloc<ItemListCubit>().changeItemQuantity(item.id, (adding ? 1 : -1) * quantity);
			    Navigator.of(ctx).pop();
			  },
		  ),
	  );
  }
}
