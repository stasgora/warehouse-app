import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AuthenticatedUser extends Equatable {
	final String name;
	final String email;
	final String id;
	final String photoURL;
	final AuthMethod authMethod;
	final bool emailVerified;

	const AuthenticatedUser({@required this.id, @required this.email, @required this.name, @required this.authMethod, this.photoURL, this.emailVerified});

	static const empty = AuthenticatedUser(id: '', name: '', email: '', authMethod: null);

  @override
  List<Object> get props => [id];

	@override
  String toString() => 'AuthUser{name: $name, email: $email}';
}

enum AuthMethod {
	EMAIL, GOOGLE
}
