part of 'sign_in_cubit.dart';

class SignInState extends AuthStateBase {
	final Email email;
	final Password password;

	SignInState({
		this.email = const Email.pure(),
		this.password = const Password.pure('', false),
		EmailSignInError signInError,
		FormzStatus status = FormzStatus.pure,
	}) : super(status, signInError);

	@override
	List<Object> get props => super.props..addAll([email, password]);

	SignInState copyWith({Email email, Password password, FormzStatus status, EmailSignInError signInError}) {
		return SignInState(
			email: email ?? this.email,
			password: password ?? this.password,
			status: status ?? this.status,
			signInError: signInError
		);
	}
}
