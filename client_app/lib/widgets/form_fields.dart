import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildNumberField<T>({BuildContext context, String title, IconData icon, TextEditingController controller,
		Function(String) onChanged, String Function(String) validator, bool decimal = false}) {
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
				onChanged: (val) => onChanged(val)
		),
	);
}

Widget buildTextField({BuildContext context, String title, IconData icon, TextEditingController controller, Function(String) onChanged}) {
	return Padding(
		padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
		child: TextFormField(
				controller: controller,
				decoration: _buildDecoration(title, icon),
				textCapitalization: TextCapitalization.sentences,
				validator: (value) => value.trim().isEmpty ? 'Pole nie może być puste' : null,
				onChanged: (val) => onChanged(val)
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
