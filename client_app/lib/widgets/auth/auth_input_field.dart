import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:warehouse_app/logic/authentication/formz_state.dart';

class AuthenticationInputField<Bloc extends Cubit<State>, State extends FormzState> extends StatefulWidget {
	final String Function(State) getError;
	final FormzInput Function(State) getField;
	final Function(Bloc, String) changedAction;

	final String label;
	final TextInputType inputType;
	final bool hideInput;
	final IconData icon;
	final bool clearable;
	final bool disabled;

  AuthenticationInputField({
		this.getField,
		this.changedAction,
		this.label,
		this.getError,
		this.inputType = TextInputType.text,
		this.hideInput = false,
		this.icon = Icons.edit,
	  this.clearable = false,
	  this.disabled = false,
	});

  @override
  _AuthenticationInputFieldState<Bloc, State> createState() => _AuthenticationInputFieldState<Bloc, State>();
}

class _AuthenticationInputFieldState<Bloc extends Cubit<CubitState>, CubitState extends FormzState> extends State<AuthenticationInputField<Bloc, CubitState>> {
	TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
	  return BlocBuilder<Bloc, CubitState>(
		  buildWhen: (previous, current) => widget.getField(previous).status != widget.getField(current).status,
		  builder: (context, state) {
			  _controller ??= TextEditingController(text: widget.getField(state).value)..addListener(() {
			    return widget.changedAction(context.bloc<Bloc>(), _controller.value.text);
			  });
			  return Padding(
			    padding: const EdgeInsets.all(8.0),
			    child: TextField(
				    enabled: !widget.disabled,
					  controller: _controller,
					  keyboardType: widget.inputType,
					  obscureText: widget.hideInput,
						style: widget.disabled ? TextStyle(color: Colors.grey[600]) : null,
						decoration: InputDecoration(
							icon: Padding(padding: EdgeInsets.all(5.0), child: Icon(widget.icon)),
							contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
							border: OutlineInputBorder(),
							labelText: widget.label,
						  errorText: widget.getField(state).invalid ? widget.getError(state) : null,
							suffixIcon: widget.clearable ? IconButton(
								onPressed: () => _controller.clear(),
								icon: Icon(Icons.clear),
							) : null,
						)
			    ),
			  );
		  },
	  );
  }
}
