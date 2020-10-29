import 'package:equatable/equatable.dart';
import 'package:warehouse_app/model/user_role.dart';

class User extends Equatable {
	final String id;
	final String name;
	final UserRole role;

  User({this.id, this.name, this.role});

	factory User.fromJson(Map<String, dynamic> json) {
		return json != null ? User(
			id: json['id'],
			name: json['name'],
			role: UserRole.values[json['role']]
		) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = {};
		data['id'] = id;
		data['name'] = name;
		data['role'] = role.index;
		return data;
	}

  @override
  List<Object> get props => [id, name, role];
}
