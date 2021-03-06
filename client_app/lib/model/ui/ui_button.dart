import 'package:flutter/material.dart';

enum ButtonType { exit, ok, retry, close, details, edit, delete, unpair, signIn, signUp }

class UIButton {
	final String text;
	final Color color;
	final IconData icon;
	final void Function() action;

	UIButton(this.text, this.action, [this.color, this.icon]);
	UIButton.ofType(ButtonType type, this.action, [this.color, this.icon]) : text = type.key;

  Widget getWidget(BuildContext context) {
    return FlatButton(
			child: Text(text),
			textColor: color,
			onPressed: action ?? () => Navigator.of(context).pop()
		);
  }
}

extension TextButtonType on ButtonType {
	String get key => const {
		ButtonType.signIn: 'Zaloguj',
		ButtonType.signUp: 'Załóż konto'
	}[this];
}
