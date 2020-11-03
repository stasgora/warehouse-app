import 'package:flutter/material.dart';

class AuthGroup extends StatelessWidget {
	final String title;
	final String hint;
	final Widget content;
	final EdgeInsets padding;
	final bool isLoading;

	AuthGroup({
		this.title,
		this.hint,
		this.isLoading = false,
		this.padding,
		@required this.content
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.all(20).copyWith(top: 10.0),
			padding: EdgeInsets.all(6.0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					if(title != null)
						Padding(
							padding: EdgeInsets.symmetric(horizontal: 10.0),
							child: Text(title, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white))
						),
					if(hint != null)
						Padding(
							padding: EdgeInsets.symmetric(horizontal: 10.0),
							child: Text(hint, style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white))
						),
					Container(
						decoration: BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.all(Radius.circular(5))
						),
						margin: EdgeInsets.only(top: (title != null || hint != null) ? 12.0 : 0.0),
						child: Stack(
							children: [
								Padding(
									padding: padding != null ? padding : EdgeInsets.all(8.0),
									child: content
								),
								Positioned.fill(
									child: AnimatedSwitcher(
										duration: Duration(milliseconds: 500),
										switchOutCurve: Curves.fastOutSlowIn,
										child: isLoading ? CircularProgressIndicator(): SizedBox.shrink()
									)
								)
							]
						)
					)
				]
			)
		);
	}
}

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
