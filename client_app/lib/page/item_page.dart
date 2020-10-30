import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse_app/model/app_page.dart';
import 'package:warehouse_app/model/ui_item.dart';
import 'package:warehouse_app/widgets/form_fields.dart';

class ItemPage extends StatefulWidget {
	final AppFormType mode;
	final UIItem initialItem;
	final Future Function(UIItem) createCallback;
	final Future Function(UIItem) editCallback;

  ItemPage(Map<String, dynamic> params) : mode = params['mode'], initialItem = params['item'] ?? UIItem(),
			createCallback = params['createCallback'], editCallback = params['editCallback'];

  @override
  _ItemPageState createState() => _ItemPageState(UIItem.from(initialItem));
}

class _ItemPageState extends State<ItemPage> {
	UIItem _item;
	final _formKey = GlobalKey<FormState>();
	TextEditingController _modelController = TextEditingController();
	TextEditingController _manufacturerController = TextEditingController();
	TextEditingController _quantityController = TextEditingController();
	TextEditingController _priceController = TextEditingController();

	_ItemPageState(this._item);
	
	@override
  void initState() {
		_modelController.text = _item.model;
		_manufacturerController.text = _item.manufacturer;
		_quantityController.text = '${_item.quantity}';
		_priceController.text = '${_item.price ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
		var fabDisabled = _item == widget.initialItem && widget.mode == AppFormType.edit;
    return Scaffold(
	    appBar: AppBar(
		    title: Text(widget.mode == AppFormType.edit ? 'Edycja produktu' : 'Nowy produkt'),
		  ),
	    floatingActionButton: FloatingActionButton(
		    child: Icon(Icons.save),
		    backgroundColor: !fabDisabled ? Theme.of(context).floatingActionButtonTheme.backgroundColor : Colors.grey,
		    onPressed: () => !fabDisabled ? _onSavePressed() : null,
	    ),
	    body: Padding(
	      padding: const EdgeInsets.symmetric(vertical: 10.0),
	      child: Form(
		      key: _formKey,
		      child: buildForm()
	      ),
	    ),
    );
  }

  Widget buildForm() {
	  return ListView(
		  physics: BouncingScrollPhysics(),
      children: [
			  buildTextField(
				  context: context,
				  title: 'Model',
				  icon: Icons.edit,
				  controller: _modelController,
				  onChanged: (val) => setState(() => _item = _item.copyWith(model: val))
			  ),
			  buildTextField(
				  context: context,
				  title: 'Producent',
				  icon: Icons.home_work,
				  controller: _manufacturerController,
				  onChanged: (val) => setState(() => _item = _item.copyWith(manufacturer: val))
			  ),
	      buildNumberField(
		      context: context,
		      title: 'Ilość',
		      icon: Icons.dynamic_feed,
		      controller: _quantityController,
		      onChanged: (val) => setState(() => _item = _item.copyWith(quantity: val.isNotEmpty ? int.parse(val) : 0))
	      ),
	      buildNumberField(
		      context: context,
		      title: 'Cena',
		      icon: Icons.attach_money,
		      controller: _priceController,
		      onChanged: (val) => setState(() => _item = _item.copyWith(price: val.isNotEmpty ? double.parse(val) : 0)),
		      validator: (val) {
						if (val.isEmpty)
							return 'Pole nie może być puste';
						if (val == '0')
							return 'Cena musi być dodatnia';
						if (!RegExp(r'^\d+(\.\d{2})?$').hasMatch(val))
							return 'Nieprawidłowa wartość';
						return null;
		      },
		      decimal: true
	      ),
		  ]
	  );
  }

  void _onSavePressed() async {
	  if (!_formKey.currentState.validate())
	  	return;
	  Future Function(UIItem) callback = (widget.mode == AppFormType.create ? widget.createCallback : widget.editCallback);
	  await callback(_item);
	  Navigator.of(context).pop();
  }
}
