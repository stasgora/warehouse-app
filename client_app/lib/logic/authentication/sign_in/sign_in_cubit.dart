import 'package:formz/formz.dart';

import 'package:warehouse_app/logic/authentication/auth_cubit_base.dart';
import 'package:warehouse_app/logic/authentication/auth_state_base.dart';
import 'package:warehouse_app/model/auth/email.dart';
import 'package:warehouse_app/model/auth/password.dart';
import 'package:warehouse_app/services/auth/auth_exceptions.dart';

part 'sign_in_state.dart';


class SignInCubit extends AuthCubitBase<SignInState> {
  SignInCubit() : super(SignInState());

	Future<void> logInWithCredentials() async {
		var state = _validateFields();
		if (!state.status.isValidated) {
			emit(state);
			return;
		}
		emit(state.copyWith(status: FormzStatus.submissionInProgress));
		try {
			await authenticationProvider.signInWithEmail(
				email: state.email.value,
				password: state.password.value,
			);
			emit(state.copyWith(status: FormzStatus.submissionSuccess));
		} on EmailSignInFailure catch (e) {
			emit(state.copyWith(status: FormzStatus.submissionFailure, signInError: e.reason));
		} on Exception {
			emit(state.copyWith(status: FormzStatus.submissionFailure));
		}
	}

  SignInState _validateFields() {
	  var state = this.state;
	  state = state.copyWith(email: Email.dirty(state.email.value.trim()));
	  state = state.copyWith(password: Password.dirty(state.password.value, false));
	  return state.copyWith(status: Formz.validate([state.email, state.password]));
  }

  void emailChanged(String value) => emit(state.copyWith(email: Email.pure(value), status: FormzStatus.pure));

  void passwordChanged(String value) => emit(state.copyWith(password: Password.pure(value, false), status: FormzStatus.pure));
}
