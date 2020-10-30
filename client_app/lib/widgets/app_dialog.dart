import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
	final String title;
	final List<Widget> fields;
	final Function onConfirm;

	AppDialog({this.title, this.fields, this.onConfirm});

	@override
	Widget build(BuildContext context) {
		return Dialog(
			insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
			child: ListView(
				shrinkWrap: true,
				children: [
					Column(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Padding(
								padding: EdgeInsets.all(24.0).copyWith(bottom: 8.0),
								child: Text(
									title,
									style: Theme.of(context).textTheme.headline6,
									maxLines: 2,
									overflow: TextOverflow.ellipsis,
								)
							),
							...fields,
							Padding(
								padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										FlatButton(
											textColor: Colors.grey[600],
											child: Text("Anuluj"),
											onPressed: () => Navigator.of(context).pop()
										),
										FlatButton(
											textColor: Color.fromARGB(255, 30, 121, 233),
											child: Text("Zapisz"),
											onPressed: () => onConfirm()
										)
									]
								)
							)
						]
					)
				]
			)
		);
	}
}