import 'package:flutter/cupertino.dart';

class Project {
  Project({@required this.id, @required this.name});
  final String id;
  final String name;

  factory Project.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    return Project(
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