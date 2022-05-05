import 'package:flutter/material.dart';

class MyUser {
  MyUser({
    @required this.uid,
    @required this.id,
    @required this.name,
    @required this.surname,
    @required this.nickname,
    @required this.rank,
    @required this.role,
    @required this.email,
    @required this.phoneNum,
    @required this.totHours,
    @required this.apprHours,
    @required this.hourPerYear,
    // @required this.fb,
    @required this.flugberechtigung,
    @required this.createDateTime,
  });
  final String uid;
  final String id;
  final String name;
  final String surname;
  final String nickname;
  final String rank;
  final String role;
  final String email;
  final String phoneNum;
  final int totHours;
  final int apprHours;
  final int hourPerYear;
  // final List<DateTime> fb;
  final bool flugberechtigung;
  final DateTime createDateTime;

  factory MyUser.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    // final String uid = documentId;
    final String id = data['id'];
    final String name = data['name'];
    final String surname = data['surname'];
    final String nickname = data['nickname'];
    final String rank = data['rank'];
    final String role = data['role'];
    final String email = data['email'];
    final String phoneNum = data['phoneNum'];
    final int totHours = data['totHours'];
    final int apprHours = data['apprHours'];
    final int hourPerYear = data['hourPerYear'];
    // final List<DateTime> fb = data['fb'];
    final bool flugberechtigung = data['flugberechtigung'];

    // final DateTime createDateTime = data['createDateTime'];

    return MyUser(
      uid: documentId,
      id: id,
      name: name,
      surname: surname,
      nickname: nickname,
      rank: rank,
      role: role,
      email: email,
      phoneNum: phoneNum,
      totHours: totHours,
      apprHours: apprHours,
      hourPerYear: hourPerYear,
      // fb: fb,
      flugberechtigung: flugberechtigung, 
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
      'role': role,
      'email': email,
      'phoneNum': phoneNum,
      'totHours': totHours,
      'apprHours': apprHours,
      'hourPerYear': hourPerYear,
      // 'fb': fb,
      'flugberechtigung': flugberechtigung, 
      'createDateTime': createDateTime,
    };
  }
}
