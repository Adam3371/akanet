import 'package:flutter/material.dart';

class SubProject {
  SubProject({@required this.id, @required this.name});
  final String id;
  final String name;

  factory SubProject.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    return SubProject(
      id: documentId,
      name: name,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}