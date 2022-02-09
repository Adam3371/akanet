import 'package:flutter/material.dart';
import 'package:akanet/app/home/models/job.dart';

class JobApproveListTile extends StatelessWidget {
  const JobApproveListTile({
    Key key,
    @required this.job,
    this.approve,
  }) : super(key: key);
  final Job job;
  final Function approve;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            tileColor: job.approveStatus == "approved"
                ? Colors.green[300]
                : job.approveStatus == "rejected"
                    ? Colors.red[300]
                    : null,
            isThreeLine: true,
            leading: Column(
              children: [
                Text(
                  job.workingHours.toString() + " h",
                  style: TextStyle(
                    fontSize: 20,
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
            trailing: Container(
              width: MediaQuery.of(context).size.width / 3.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    color: Colors.red,
                    onPressed: () {
                      if(job.approveStatus == "rejected")
                      {
                        approve(job, "open");
                      }
                      else
                      {
                        approve(job, "rejected");
                      }
                    },
                    icon: Icon(
                      Icons.cancel_presentation_outlined,
                    ),
                  ),
                  IconButton(
                    color: Colors.green,
                    onPressed: () {
                      if(job.approveStatus == "approved")
                      {
                        approve(job, "open");
                      }
                      else
                      {
                        approve(job, "approved");
                      }
                      
                    },
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
