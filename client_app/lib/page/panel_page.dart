import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_app/logic/authentication/bloc/authentication_bloc.dart';

import 'package:warehouse_app/logic/item_list_cubit.dart';
import 'package:warehouse_app/logic/reloadable/reloadable_cubit.dart';
import 'package:warehouse_app/model/ui/app_page.dart';
import 'package:warehouse_app/model/ui/ui_button.dart';
import 'package:warehouse_app/services/exceptions.dart';
import 'package:warehouse_app/model/ui/ui_item.dart';
import 'package:warehouse_app/model/ui/user_role.dart';
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
		    actions: [
		      IconButton(
				    icon: Icon(Icons.logout),
				    onPressed: () => context.bloc<AuthenticationBloc>().add(AuthenticationSignOutRequested()),
		        tooltip: 'Wyloguj: ${context.bloc<AuthenticationBloc>().state.user.name}',
			    )
		    ],
		  ),
		  body: BlocListener<ItemListCubit, LoadableState>(
			  listenWhen: (oldState, newState) => newState is ItemListLoadSuccess,
			  listener: (context, state) {
				  var error = (state as ItemListLoadSuccess).exception;
				  if (error != null)
					  Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(
						  SnackBar(content: Text(error.description)),
					  );
			  },
			  child: LoadableBlocBuilder<ItemListCubit>(
				  builder: (context, state) => _buildItemList(state as ItemListLoadSuccess, context)
			  ),
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

  Widget _buildItemList(ItemListLoadSuccess state, BuildContext context) {
  	return ListView(
		  physics: BouncingScrollPhysics(),
		  children: [
		  	SwitchListTile(
				  title: Text('Połączenie internetowe'),
				  secondary: Icon(state.connectionOverride ? Icons.wifi : Icons.wifi_off),
				  value: state.connectionOverride,
				  onChanged: (val) => context.bloc<ItemListCubit>().setNetworkOverride(val)
			  ),
		  	for (var item in state.items)
		  		Card(
					  child: ListTile(
						  title: Text('${item.manufacturer} ${item.model}', maxLines: 1, overflow: TextOverflow.ellipsis),
						  subtitle: Text('Ilość: ${item.quantity}　Cena: ${item.price.toStringAsFixed(2)}', maxLines: 2, overflow: TextOverflow.ellipsis),
						  trailing: PopupMenuList(
							  items: [
								  UIButton('Edytuj', () => pushItemPage(context, item), null, Icons.edit),
								  UIButton('Zwiększ ilość', () => showQuantityDialog(item, context, adding: true), null, Icons.add),
								  if (item.quantity > 0)
								    UIButton('Zmniejsz ilość', () => showQuantityDialog(item, context, adding: false), null, Icons.remove),
								  if (context.bloc<AuthenticationBloc>().state.user.role == UserRole.manager)
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
					  focus: true,
					  icon: Icons.dynamic_feed,
					  controller: _quantityController,
					  onChanged: (val) => quantity = val.isNotEmpty ? int.parse(val) : 0,
				  )
			  ],
			  onConfirm: () async {
			    await context.bloc<ItemListCubit>().changeItemQuantity(item, (adding ? 1 : -1) * quantity);
			    Navigator.of(ctx).pop();
			  },
		  ),
	  );
  }
}
