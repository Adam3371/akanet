import 'package:flutter/material.dart';

class JobYearOverview {
  JobYearOverview({
    @required this.totalHours,
    @required this.approvedHours,
    @required this.totWerkHours,
    @required this.appWerkHours,
  });

  double totalHours;
  double approvedHours;
  double totWerkHours;
  double appWerkHours;

  factory JobYearOverview.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    double totalHours = data['totalHours'];
    double approvedHours = data['approvedHours'];
    double totWerkHours = data['totWerkHours'];
    double appWerkHours = data['appWerkHours'];

    return JobYearOverview(
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
