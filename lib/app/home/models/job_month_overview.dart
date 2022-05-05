import 'package:flutter/material.dart';

class JobMonthOverview {
  JobMonthOverview({
    @required this.totalHours,
    @required this.approvedHours,
    @required this.totWerkHours,
    @required this.appWerkHours,
  });

  double totalHours;
  double approvedHours;
  double totWerkHours;
  double appWerkHours;

  factory JobMonthOverview.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    double totalHours = data['totalHours'];
    double approvedHours = data['approvedHours'];
    double totWerkHours = data['totWerkHours'];
    double appWerkHours = data['appWerkHours'];

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
