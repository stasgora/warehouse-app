import 'package:flutter/material.dart';
import 'package:warehouse_app/model/ui/ui_button.dart';

class PopupMenuList extends StatelessWidget {
  final List<UIButton> items;
	final bool includeDivider;

	PopupMenuList({this.items, this.includeDivider = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
			customBorder: new CircleBorder(),
			child: PopupMenuButton(
				onSelected: (Function a) => a(),
				icon: Icon(Icons.more_vert, size: 26.0),
				itemBuilder: (BuildContext context) => _menuItemFactory(items,  context),
			)
		);
  }

  List<PopupMenuEntry<Function>> _menuItemFactory(List<UIButton> items, context) {
		List<PopupMenuEntry<Function>> popupMenuEntries = [];
  	for (var item in items) {
			popupMenuEntries.add(
				PopupMenuItem(
					value: item.action,
					child: Row(
						children: <Widget>[
							Padding(
								padding: EdgeInsets.only(right: 10.0),
								child: Icon(item.icon, color: Colors.grey[600])
							),
							Text(item.text),
						]
					)
				)
			);
			if(includeDivider && popupMenuEntries.length > 1)
				popupMenuEntries.insert(popupMenuEntries.length-1, PopupMenuDivider());
		}
  	return popupMenuEntries;
	}
}
