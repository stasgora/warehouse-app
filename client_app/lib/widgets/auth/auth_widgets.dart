import 'package:flutter/material.dart';

class AuthFloatingButton extends StatelessWidget {
	final String text;
	final IconData icon;
	final Function action;

	AuthFloatingButton({
		this.text,
		this.icon,
		this.action
	});

  @override
  Widget build(BuildContext context) {
		return FlatButton.icon(
			onPressed: action,
			icon: Icon(icon, color: Colors.white),
			label: Text(text, style: Theme.of(context).textTheme.button)
		);
  }
}


class AuthDivider extends StatelessWidget {
	final String text;

	AuthDivider({
		this.text = 'Lub'
	});

  @override
  Widget build(BuildContext context) {
		return Row(
			children: <Widget>[
				Expanded(
					child: Container(
						margin: const EdgeInsets.only(left: 10.0, right: 20.0),
						child: Divider(
							color: Colors.black,
							height: 36,
						)
					)
				),
				Text((text ?? 'or').toUpperCase()),
				Expanded(
					child: Container(
						margin: const EdgeInsets.only(left: 20.0, right: 10.0),
						child: Divider(
							color: Colors.black,
							height: 36,
						)
					)
				)
			]
		);
	}
	
}
