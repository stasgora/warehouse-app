import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:warehouse_app/services/auth/auth_exceptions.dart';
import 'package:warehouse_app/services/auth/auth_provider.dart';

import 'auth_state_base.dart';

class AuthCubitBase<State extends AuthStateBase> extends Cubit<State> {
	@protected
	final AuthenticationProvider authenticationProvider = GetIt.I<AuthenticationProvider>();

  AuthCubitBase(State state) : super(state);

	Future<void> logInWithGoogle() async {
		emit(state.copyWith(status: FormzStatus.submissionInProgress));
		try {
			await authenticationProvider.signInWithGoogle();
			emit(state.copyWith(status: FormzStatus.submissionSuccess));
		} on EmailSignInFailure catch (e) {
			emit(state.copyWith(status: FormzStatus.submissionFailure, signInError: e.reason));
		} on Exception {
			emit(state.copyWith(status: FormzStatus.submissionFailure));
		}
	}
}
