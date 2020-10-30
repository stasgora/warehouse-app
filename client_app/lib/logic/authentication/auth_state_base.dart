import 'package:formz/formz.dart';
import 'package:warehouse_app/services/auth/auth_exceptions.dart';

import 'formz_state.dart';


abstract class AuthStateBase extends FormzState {
	final EmailSignInError signInError;

  AuthStateBase(FormzStatus status, [this.signInError]) : super(status);

	AuthStateBase copyWith({FormzStatus status, EmailSignInError signInError});

	@override
  List<Object> get props => [signInError, status];
}
