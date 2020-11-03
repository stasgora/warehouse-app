import 'package:equatable/equatable.dart';
import 'package:warehouse_app/model/user_role.dart';
import 'package:warehouse_app/services/auth/auth_user.dart';

class User extends Equatable {
	final String id;
	final String authId;
	final String name;
	final UserRole role;

  User({this.id, this.name, this.role, this.authId});
	User.fromAuthUser(AuthenticatedUser authUser) : this(name: authUser.name, role: UserRole.employee, authId: authUser.id);

	factory User.fromJson(Map<dynamic, dynamic> json) {
		return json != null && json.isNotEmpty ? User(
			id: json['id'],
			authId: json['authId'],
			name: json['name'],
			role: UserRole.values[json['role']]
		) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = {};
		if (id != null)
			data['id'] = id;
		if (authId != null)
			data['authId'] = authId;
		if (name != null)
			data['name'] = name;
		if (role != null)
			data['role'] = role.index;
		return data;
	}

  @override
  List<Object> get props => [id, name, role];
}
