import 'package:formz/formz.dart';
import 'package:warehouse_app/logic/authentication/auth_cubit_base.dart';
import 'package:warehouse_app/logic/authentication/auth_state_base.dart';
import 'package:warehouse_app/model/auth/confirmed_password.dart';
import 'package:warehouse_app/model/auth/email.dart';
import 'package:warehouse_app/model/auth/name.dart';
import 'package:warehouse_app/model/auth/password.dart';
import 'package:warehouse_app/services/auth/auth_exceptions.dart';

part 'sign_up_state.dart';

class SignUpCubit extends AuthCubitBase<SignUpState> {
  SignUpCubit() : super(SignUpState());

  Future<void> signUpFormSubmitted() async {
	  var state = _validateFields();
	  if (!state.status.isValidated) {
		  emit(state);
		  return;
	  }
	  emit(state.copyWith(status: FormzStatus.submissionInProgress));
	  try {
		  await authenticationProvider.signUpWithEmail(
			  email: state.email.value,
			  password: state.password.value,
			  name: state.name.value
		  );
		  emit(state.copyWith(status: FormzStatus.submissionSuccess));
	  } on EmailSignUpFailure catch (e) {
		  emit(state.copyWith(status: FormzStatus.submissionFailure, signUpError: e.reason));
	  } on Exception {
		  emit(state.copyWith(status: FormzStatus.submissionFailure));
	  }
  }

  SignUpState _validateFields() {
	  var state = this.state;
	  state = state.copyWith(email: Email.dirty(state.email.value.trim()));
	  state = state.copyWith(name: Name.dirty(state.name.value.trim()));
	  state = state.copyWith(password: Password.dirty(state.password.value));
	  state = state.copyWith(confirmedPassword: state.confirmedPassword.copyDirty(original: state.password));
	  return state.copyWith(status: Formz.validate([state.email, state.password, state.name, state.confirmedPassword]));
  }

	void nameChanged(String value) => emit(state.copyWith(name: Name.pure(value), status: FormzStatus.pure));

  void emailChanged(String value) => emit(state.copyWith(email: Email.pure(value), status: FormzStatus.pure));

  void passwordChanged(String value) => emit(state.copyWith(password: Password.pure(value), status: FormzStatus.pure));

  void confirmedPasswordChanged(String value) => emit(state.copyWith(confirmedPassword: state.confirmedPassword.copyPure(value: value), status: FormzStatus.pure));
}
