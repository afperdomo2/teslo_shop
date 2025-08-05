import 'package:teslo_app/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      roles: List<String>.from(json['roles'].map((role) => role as String)),
      isActive: json['isActive'] as bool,
      token: json['token'] as String,
    );
  }
}
