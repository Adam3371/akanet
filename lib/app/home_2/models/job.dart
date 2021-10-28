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
  });
  final String id;
  final String project;
  final String projectId;
  final String subproject;
  final String subprojectId;
  final String description;
  final double workingHours;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String description = data['description'];
    final String project = data['project'];
    final String projectId = data['projectId'];
    final String subproject = data['subproject'];
    final String subprojectId = data['subprojectId'];
    final double workingHours = data['workingHours'];
    return Job(
      id: documentId,
      project: project,
      projectId	: projectId,
      subproject: subproject,
      subprojectId: subprojectId,
      description: description,
      workingHours: workingHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project' : project,
      'projectId' : projectId,
      'subproject' : subproject,
      'subprojectId' : subprojectId,
      'description': description,
      'workingHours': workingHours,
    };
  }
}
