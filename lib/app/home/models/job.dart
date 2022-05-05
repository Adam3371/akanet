import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Job {
  Job({
    @required this.id,
    @required this.project,
    @required this.projectId,
    @required this.subproject,
    @required this.subprojectId,
    @required this.description,
    @required this.workingHours,
    @required this.workDate,
    @required this.approveStatus,
    @required this.isWerk,
  });
  final String id;
  final String project;
  final String projectId;
  final String subproject;
  final String subprojectId;
  final String description;
  final String approveStatus;
  final double workingHours;
  final bool isWerk;
  final DateTime workDate;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String description = data['description'];
    final String project = data['project'];
    final String projectId = data['projectId'];
    final String subproject = data['subproject'];
    final String subprojectId = data['subprojectId'];
    final String approveStatus = data['approveStatus'];
    final double workingHours = data['workingHours'];
    final bool isWerk = data['isWerk'];
    Timestamp timestamp = data['workDate'];
    DateTime workDate = timestamp.toDate();

    return Job(
      id: documentId,
      project: project,
      projectId: projectId,
      subproject: subproject,
      subprojectId: subprojectId,
      approveStatus: approveStatus,
      description: description,
      workingHours: workingHours,
      workDate: workDate,
      isWerk: isWerk,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project': project,
      'projectId': projectId,
      'subproject': subproject,
      'subprojectId': subprojectId,
      'approveStatus': approveStatus,
      'description': description,
      'workingHours': workingHours,
      'workDate': workDate,
      'isWerk': isWerk,
    };
  }
}
