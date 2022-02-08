import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home/jobs/job_list_tile.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class TimeTrackerHomePageDesktop extends StatelessWidget {
  const TimeTrackerHomePageDesktop({Key key, this.database, this.screenSize})
      : super(key: key);

  final Database database;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("images/mue31.jpg"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Container(
        child: Row(
          children: [
            Container(
              width: screenSize.width / 4,
              // color: Colors.amber,
            ),
            Container(
              width: 2 * screenSize.width / 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: _listBuilder(context, database),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _listBuilder(BuildContext context, Database database) {
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream("2021", "10"),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            // onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () {
                WorkTimeEntryPage.show(
                  context,
                  database: database,
                  job: job,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
