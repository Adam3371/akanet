import 'package:flutter/material.dart';
import 'package:akanet/app/home/models/job.dart';

class JobApproveListTile extends StatelessWidget {
  const JobApproveListTile({
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
            isThreeLine: true,
            leading: Column(
              children: [
                Text(
                  job.workingHours.toString() + " h",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(job.workDate.day.toString() +
                        "." +
                        job.workDate.month.toString() //+
                    // "." +
                    // job.workDate.year.toString(),
                    ),
              ],
            ),
            title: job.subproject != null
                ? Text(job.project + "> " + job.subproject)
                : Text(job.project),
            subtitle: Text(job.description),
            onTap: onTap,
            trailing: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    color: Colors.red,
                    onPressed: () {},
                    icon: Icon(
                      Icons.cancel_presentation_outlined,
                    ),
                  ),
                  // Spacer(),
                  // IconButton(
                  //   color: Colors.yellow,
                  //   onPressed: () {},
                  //   icon: Icon(Icons.question_mark),
                  // ),
                  IconButton(
                    color: Colors.green,
                    onPressed: () {},
                    icon: Icon(Icons.assignment_turned_in_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
