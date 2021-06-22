import 'package:flutter/material.dart';

class AircraftTicket {
  AircraftTicket({
    this.id,
    this.creator,
    this.creatorId,
    this.dateCreate,
    this.dateLastUpdate,
    this.dateClosed,
    this.status,
    this.prio,
    this.title,
    this.description,
  });

  final String id;
  final String creator;
  final String creatorId;
  final String dateCreate;
  final String dateLastUpdate;
  final String dateClosed;
  final int status;
  final int prio;
  final String title;
  final String description;

  factory AircraftTicket.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String creator = data['creator'];
    final String creatorId = data['creatorId'];
    final String dateCreate = data['dateCreate'];
    final String dateLastUpdate = data['dateLastUpdate'];
    final String dateClosed = data['dateClosed'];
    final int status = data['status'];
    final int prio = data['prio'];
    final String title = data['title'];
    final String description = data['description'];
    return AircraftTicket(
      id: documentId,
      creator: creator,
      creatorId: creatorId,
      dateCreate: dateCreate,
      dateLastUpdate: dateLastUpdate,
      dateClosed: dateClosed,
      status: status,
      prio: prio,
      title: title,
      description: description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'creatorId': creatorId,
      'dateCreate': dateCreate,
      'dateLastUpdate': dateLastUpdate,
      'dateClosed': dateClosed,
      'status': status,
      'prio': prio,
      'title': title,
      'description': description,
    };
  }
}
