import 'dart:html';

import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home_2/jobs/job_list_tile.dart';
import 'package:akanet/app/home_2/jobs/list_items_builder.dart';
import 'package:akanet/app/home_2/models/job.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimeTrackerHomePageMobile extends StatefulWidget {
  const TimeTrackerHomePageMobile({Key key, this.database, this.screenSize})
      : super(key: key);
  final Database database;
  final Size screenSize;

  @override
  _TimeTrackerHomePageMobileState createState() =>
      _TimeTrackerHomePageMobileState();
}

class _TimeTrackerHomePageMobileState extends State<TimeTrackerHomePageMobile> {
  double totalWorkingHours = 0;

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      await widget.database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenSize.width,
      // decoration: BoxDecoration(
      // image: DecorationImage(
      //   image: AssetImage("images/mue31.jpg"),
      //   fit: BoxFit.cover,
      // ),
      // ),
      child: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(30),
        color: Colors.grey.withOpacity(0.7),
        height: double.infinity,
        // ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(30),
                //     topRight: Radius.circular(30),
                // ),
                color: Colors.black54,
                // ),
                height: widget.screenSize.height / 10,
                child: Row(
                  children: [
                    StreamBuilder(
                      stream: widget.database.jobsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        List<Job> jobs = snapshot.data;
                        totalWorkingHours = 0;
                        for (int i = 0; i < jobs.length; i++) {
                          Job job = jobs[i];
                          totalWorkingHours += job.workingHours;
                        }

                        return Text("Total: $totalWorkingHours");
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // totalWorkingHours = 0;
                        setState(() {});
                      },
                      child: Text("update"),
                    ),
                  ],
                ),
              ),
              _listBuilder(context, widget.database),
            ],
          ),
        ),
      ),
    );
  }

  _listBuilder(BuildContext context, Database database) {
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) {
            // totalWorkingHours += job.ratePerHour;
            // print(totalWorkingHours);
            return Dismissible(
              key: Key('job-${job.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
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
            );
          },
        );
      },
    );
  }
}
