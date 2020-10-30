enum EmailSignUpError { emailAlreadyUsed, emailInvalid }

extension EmailSignUpErrorCode on EmailSignUpError {
	String get errorCode => const {
		EmailSignUpError.emailAlreadyUsed: 'email-already-in-use',
		EmailSignUpError.emailInvalid: 'invalid-email',
	}[this];
}

class EmailSignUpFailure implements Exception {
	final EmailSignUpError reason;

  EmailSignUpFailure({this.reason});
}

enum EmailSignInError { wrongPassword, userNotFound, userDisabled }

extension EmailSignInErrorCode on EmailSignInError {
	String get errorCode => const {
		EmailSignInError.wrongPassword: 'wrong-password',
		EmailSignInError.userNotFound: 'user-not-found',
		EmailSignInError.userDisabled: 'user-disabled',
	}[this];
}

class EmailSignInFailure implements Exception {
	final EmailSignInError reason;

  EmailSignInFailure({this.reason});
}

enum PasswordConfirmError { wrongPassword }

extension PasswordChangeErrorCode on PasswordConfirmError {
	String get errorCode => const {
		PasswordConfirmError.wrongPassword: 'wrong-password',
	}[this];
}

class PasswordConfirmFailure {
	final PasswordConfirmError reason;

	PasswordConfirmFailure({this.reason});
}

class GoogleSignInFailure implements Exception {}

class SignOutFailure implements Exception {}
