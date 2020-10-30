import 'package:meta/meta.dart';

import 'auth_user.dart';
import 'firebase_auth_provider.dart';

abstract class AuthenticationProvider {
	static final AuthenticationProvider instance = FirebaseAuthProvider();

	Stream<AuthenticatedUser> get user;

	Future<void> signInWithEmail({@required String email, @required String password});
	Future<void> signUpWithEmail({@required String email, @required String password, String name = ''});
	Future<void> signInWithGoogle();
	Future<void> signOut();

	Future<bool> userExists(String email);
	Future<void> confirmPassword(String currentPassword);
	Future<void> deleteAccount(String currentPassword);

	Future<void> changePassword(String currentPassword, String newPassword);
	Future<void> changeName(String name);
}
