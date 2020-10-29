import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse_app/model/app_page.dart';
import 'package:warehouse_app/model/ui_item.dart';

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
			  _buildTextField(
				  title: 'Model',
				  icon: Icons.edit,
				  controller: _modelController,
				  onChanged: (val) => _item = _item.copyWith(model: val)
			  ),
			  _buildTextField(
				  title: 'Producent',
				  icon: Icons.home_work,
				  controller: _manufacturerController,
				  onChanged: (val) => _item = _item.copyWith(manufacturer: val)
			  ),
	      _buildNumberField(
		      title: 'Ilość',
		      icon: Icons.dynamic_feed,
		      controller: _quantityController,
		      onChanged: (val) => _item = _item.copyWith(quantity: val.isNotEmpty ? int.parse(val) : 0)
	      ),
	      _buildNumberField(
		      title: 'Cena',
		      icon: Icons.attach_money,
		      controller: _priceController,
		      onChanged: (val) => _item = _item.copyWith(price: val.isNotEmpty ? double.parse(val) : 0),
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

  Widget _buildNumberField<T>({String title, IconData icon, TextEditingController controller, Function(String) onChanged, String Function(String) validator, bool decimal = false}) {
	  validator ??= (_) => null;
	  return Padding(
	    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
	    child: TextFormField(
		  controller: controller,
		  decoration: _buildDecoration(title, icon).copyWith(
			  hintText: "0",
			  suffixIcon: IconButton(
				  onPressed: () {
					  FocusScope.of(context).requestFocus(FocusNode());
					  controller.clear();
				  },
				  icon: Icon(Icons.clear)
			  )
		  ),
		  validator: validator,
		  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: decimal),
		  inputFormatters: <TextInputFormatter>[decimal ? FilteringTextInputFormatter.allow(RegExp('[0-9.]*')) : FilteringTextInputFormatter.digitsOnly],
		  onChanged: (val) => setState(() => onChanged(val))
	    ),
	  );
  }

  Widget _buildTextField({String title, IconData icon, TextEditingController controller, Function(String) onChanged}) {
		return Padding(
		  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
		  child: TextFormField(
		  	controller: controller,
		  	decoration: _buildDecoration(title, icon),
		  	textCapitalization: TextCapitalization.sentences,
		  	validator: (value) => value.trim().isEmpty ? 'Pole nie może być puste' : null,
		  	onChanged: (val) => setState(() => onChanged(val))
		  ),
		);
  }

  InputDecoration _buildDecoration(String title, IconData icon) {
		return InputDecoration(
			icon: Padding(padding: EdgeInsets.all(5.0), child: Icon(icon)),
			border: OutlineInputBorder(),
			contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
			labelText: title
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
