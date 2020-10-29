import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_app/model/user.dart';
import 'package:warehouse_app/model/user_role.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.unknown());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
		if (event is AuthenticationStarted)
			yield AuthenticationState.authenticated(User(id: '0', name: 'Test', role: UserRole.manager));
  }
}
