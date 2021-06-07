import 'package:flutter/material.dart';

class AircraftTicket {
  AircraftTicket({@required this.id, @required this.name});
  final String id;
  final String name;

  factory AircraftTicket.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    return AircraftTicket(
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