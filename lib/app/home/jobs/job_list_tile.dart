import 'package:flutter/material.dart';
import 'package:akanet/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({
    Key key,
    @required this.job,
    this.onTap,
  }) : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Text(
              job.workingHours.toString() + " h",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            title: job.subproject != null
                ? Text(job.project + "> " + job.subproject)
                : Text(job.project),
            subtitle: Text(job.description),
            onTap: onTap,
            trailing: Text(
              job.workDate.day.toString() +
                  "." +
                  job.workDate.month.toString() +
                  "." +
                  job.workDate.year.toString(),
            ),
          ),
        ),
      ],
    );
  }
}
