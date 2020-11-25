import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:warehouse_app/model/db/user.dart';
import 'package:warehouse_app/services/auth/auth_provider.dart';
import 'package:warehouse_app/services/auth/auth_user.dart';
import 'package:warehouse_app/services/data/data_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
	final AuthenticationProvider _authenticationProvider = GetIt.I<AuthenticationProvider>();
	final DataService _dataService = GetIt.I<DataService>();

	StreamSubscription<AuthenticatedUser> _userSubscription;

  AuthenticationBloc() : super(AuthenticationState.unknown()) {
	  _userSubscription = _authenticationProvider.user.listen((user) => add(AuthenticationUserChanged(user)));
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
	  if (event is AuthenticationUserChanged)
		  yield await _processUserChangedEvent(event);
	  else if (event is AuthenticationSignOutRequested)
		  _authenticationProvider.signOut();
  }

	Future<AuthenticationState> _processUserChangedEvent(AuthenticationUserChanged event) async {
		User user;
		if (event.user == AuthenticatedUser.empty)
			return const AuthenticationState.unauthenticated();

		user = await _dataService.getUser(event.user.id);
		if (user == null) {
			if (! (await _authenticationProvider.userExists(event.user.email))) {
				await _authenticationProvider.signOut();
				return const AuthenticationState.unauthenticated();
			}
			print('Creating new user for ${event.user}');
			user = User.fromAuthUser(event.user);
			await _dataService.createUser(user);
		}
		return AuthenticationState.authenticated(user);
	}

	@override
	Future<void> close() {
		_userSubscription?.cancel();
		return super.close();
	}
}
