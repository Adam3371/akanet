import 'package:flutter/material.dart';

class ItTicketCategory {
  ItTicketCategory({@required this.id, @required this.name});
  final String id;
  final String name;

  factory ItTicketCategory.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    return ItTicketCategory(
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