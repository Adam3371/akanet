import 'package:flutter/material.dart';

class MyUser {
  MyUser({
    @required this.id,
    @required this.name,
    @required this.surname,
    @required this.nickname,
    @required this.rank,
    @required this.email,
    @required this.createDateTime,
  });
  final String id;
  final String name;
  final String surname;
  final String nickname;
  final String rank;
  final String email;
  final DateTime createDateTime;

  factory MyUser.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final String name = data['name'];
    final String surname = data['surname'];
    final String nickname = data['nickname'];
    final String rank = data['rank'];
    final String email = data['email'];
    // final DateTime createDateTime = data['createDateTime'];

    return MyUser(
      id: id,
      name: name,
      surname: surname,
      nickname: nickname,
      rank: rank,
      email: email,
      // createDateTime: createDateTime, //Error
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'nickname': nickname,
      'rank': rank,
      'email': email,
      'createDateTime': createDateTime,
    };
  }
}
