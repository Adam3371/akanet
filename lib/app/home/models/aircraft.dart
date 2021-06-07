import 'package:flutter/material.dart';

class Aircraft {
  Aircraft({@required this.id, @required this.name, @required this.mantainer, @required this.mantainerId});
  final String id;
  final String name;
  final String mantainer;
  final String mantainerId;

  factory Aircraft.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String mantainer = data['mantainer'];
    final String mantainerId = data['mantainerid'];
    return Aircraft(
      id: documentId,
      name: name,
      mantainer: mantainer,
      mantainerId: mantainerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mantainer': mantainer,
      'mantianerId': mantainer,
    };
  }
}
