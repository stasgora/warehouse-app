part of 'sign_up_cubit.dart';

class SignUpState extends AuthStateBase {
	final Name name;
	final Email email;
	final Password password;
	final ConfirmedPassword confirmedPassword;
	final EmailSignUpError signUpError;

	SignUpState({
		this.name = const Name.pure(),
		this.email = const Email.pure(),
		this.password = const Password.pure(),
		this.confirmedPassword = const ConfirmedPassword.pure(),
		this.signUpError,
		EmailSignInError signInError,
		FormzStatus status = FormzStatus.pure,
	}) : super(status, signInError);

	@override
	List<Object> get props => super.props..addAll([name, email, password, confirmedPassword, signUpError]);

	SignUpState copyWith({Name name, Email email, Password password, ConfirmedPassword confirmedPassword, EmailSignInError signInError, EmailSignUpError signUpError, FormzStatus status}) {
		return SignUpState(
			name: name ?? this.name,
			email: email ?? this.email,
			password: password ?? this.password,
			confirmedPassword: confirmedPassword ?? this.confirmedPassword,
			status: status ?? this.status,
			signUpError: signUpError,
			signInError: signInError
		);
	}
}
