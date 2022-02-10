import 'package:flutter/cupertino.dart';

class Project {
  Project({
    @required this.id,
    @required this.name,
    @required this.isWerkstatt,
  });
  final String id;
  final String name;
  final bool isWerkstatt;

  factory Project.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final bool isWerkstatt = data['isWerkstatt'];
    return Project(
      id: documentId,
      name: name,
      isWerkstatt: isWerkstatt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isWerkstatt': isWerkstatt,
    };
  }
}
