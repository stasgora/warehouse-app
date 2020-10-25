import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_app/logic/authentication/authentication_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	  return Scaffold(
		  appBar: AppBar(
			  title: Text('Login'),
		  ),
		  body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
			  builder: (context, state) {
			  	if (state.status == AuthenticationStatus.initial)
						context.bloc<AuthenticationBloc>().add(AuthenticationStarted());
			  	return Container();
			  },
		  ),
	  );
  }
}
