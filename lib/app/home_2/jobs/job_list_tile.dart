import 'package:flutter/material.dart';
import 'package:akanet/app/home_2/models/job.dart';

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
            title: Text(job.description),
            subtitle: Text("Date"),
            onTap: onTap,
            trailing: Text(job.workingHours.toString()),
          ),
        ),
      ],
    );
  }
}
