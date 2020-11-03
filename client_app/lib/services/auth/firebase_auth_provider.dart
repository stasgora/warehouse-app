import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'auth_user.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';

class FirebaseAuthProvider implements AuthenticationProvider {
	final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
	final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

	String signedUpUserName;

	@override
	Stream<AuthenticatedUser> get user {
		return _firebaseAuth.authStateChanges().skip(1).map((firebaseUser) {
			return firebaseUser == null ? AuthenticatedUser.empty : _asAuthUser(firebaseUser);
		});
	}

	@override
	Future<void> signInWithEmail({@required String email, @required String password}) async {
		assert(email != null && password != null);
		try {
			await signOut();
			await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
		} catch (e) {
			var reason = _checkForKnownError(e);
			if (reason == null)
				_logException('Sign In', e);
			throw EmailSignInFailure(reason: reason);
		}
	}

	@override
	Future<void> signUpWithEmail({@required String email, @required String password, String name = ''}) async {
		assert(email != null && password != null);
		signedUpUserName = name;
		try {
			await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((user) => changeName(name));
		} catch (e) {
			EmailSignUpError reason;
			if (e is FirebaseAuthException)
				for (var error in EmailSignUpError.values)
					if (e.code == error.errorCode) {
						reason = error;
						break;
					}
			if (reason == null)
				_logException('Sign Up', e);
			throw EmailSignUpFailure(reason: reason);
		}
	}

	@override
	Future<void> signInWithGoogle() async {
		try {
			await signOut();
			var credential = await _getGoogleCredential();
			if (credential == null)
				return;
			await _firebaseAuth.signInWithCredential(credential);
		} catch (e) {
			var reason = _checkForKnownError(e);
			if (reason == null)
				_logException('Sign In', e);
			throw EmailSignInFailure(reason: reason);
		}
	}

	@override
	Future<bool> userExists(String email) async => (await _firebaseAuth.fetchSignInMethodsForEmail(email)).isNotEmpty;

	@override
	Future<void> signOut() async {
		try {
			await Future.wait([
				_firebaseAuth.signOut(),
				_googleSignIn.signOut(),
			]);
		} catch (e) {
			throw SignOutFailure();
		}
	}

	@override
	Future<void> changeName(String name) => _firebaseAuth.currentUser.updateProfile(displayName: name);

	Future<AuthCredential> _getGoogleCredential() async {
		final googleUser = await _googleSignIn.signIn();
		if (googleUser == null)
			return null;
		final googleAuth = await googleUser.authentication;
		return GoogleAuthProvider.credential(
			accessToken: googleAuth.accessToken,
			idToken: googleAuth.idToken,
		);
	}

	EmailSignInError _checkForKnownError(Exception e) {
		EmailSignInError reason;
		if (e is FirebaseAuthException)
			for (var error in EmailSignInError.values)
				if (e.code == error.errorCode) {
					reason = error;
					break;
				}
		return reason;
	}

	AuthMethod _getUserAuthMethod() {
		for (var value in _firebaseAuth.currentUser.providerData) {
			if (value.providerId == GoogleAuthProvider.PROVIDER_ID)
				return AuthMethod.GOOGLE;
			if (value.providerId == EmailAuthProvider.PROVIDER_ID)
				return AuthMethod.EMAIL;
		}
		return null;
	}

	AuthenticatedUser _asAuthUser(User user) {
	  var authUser = AuthenticatedUser(
		  id: user.uid,
		  email: user.email,
		  name: user.displayName ?? signedUpUserName,
		  authMethod: _getUserAuthMethod()
	  );
	  signedUpUserName = null;
	  return authUser;
	}

	void _logException(String method, Exception exception) {
		print('Firebase $method thrown: $exception');
	}
}
