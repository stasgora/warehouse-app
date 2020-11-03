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

extension EmailSignUpErrorTextKey on EmailSignUpError {
	String get key => const {
		EmailSignUpError.emailAlreadyUsed: 'Adres e-mail jest już zajęty',
		EmailSignUpError.emailInvalid: 'Adres e-mail jest nieprawidłowy',
	}[this];
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

extension EmailSignInErrorTextKey on EmailSignInError {
	String get key => const {
		EmailSignInError.wrongPassword: 'Nieprawidłowy e-mail lub hasło',
		EmailSignInError.userNotFound: 'Nieprawidłowy e-mail lub hasło',
		EmailSignInError.userDisabled: 'Użytkownik został wyłączony',
	}[this];
}

class GoogleSignInFailure implements Exception {}

class SignOutFailure implements Exception {}
