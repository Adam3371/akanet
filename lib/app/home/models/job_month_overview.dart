import 'package:flutter/material.dart';

class JobMonthOverview {
  JobMonthOverview({
    @required this.totalHours,
    @required this.approvedHours,
    @required this.totWerkHours,
    @required this.appWerkHours,
  });

  final double totalHours;
  final double approvedHours;
  final double totWerkHours;
  final double appWerkHours;

  factory JobMonthOverview.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final double totalHours = data['totalHours'];
    final double approvedHours = data['approvedHours'];
    final double totWerkHours = data['totWerkHours'];
    final double appWerkHours = data['appWerkHours'];

    return JobMonthOverview(
      totalHours: totalHours,
      approvedHours: approvedHours,
      totWerkHours: totWerkHours,
      appWerkHours: appWerkHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalHours': totalHours,
      'approvedHours': approvedHours,
      'totWerkHours': totWerkHours,
      'appWerkHours': appWerkHours,
    };
  }
}
