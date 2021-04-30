import 'package:flutter/material.dart';

class User {
  User(
      {@required this.id,
      @required this.name,
      @required this.surname,
      @required this.nickname,
      @required this.role});
  final String id;
  final String name;
  final String surname;
  final String nickname;
  final String role;

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String surname = data['surname'];
    final String nickname = data['nickname'];
    final String role = data['role'];

    return User(
      id: documentId,
      name: name,
      surname: surname,
      nickname: nickname,
      role: role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'nickname': nickname,
      'role': role,
    };
  }
}
