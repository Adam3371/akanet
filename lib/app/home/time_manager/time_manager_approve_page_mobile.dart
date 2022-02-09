import 'package:akanet/app/home/jobs/job_approve_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:akanet/app/home/models/my_user.dart';
import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeTrackerApprovePageMobile extends StatefulWidget {
  const TimeTrackerApprovePageMobile(
      {Key key, this.user, this.database, this.screenSize, this.job})
      : super(key: key);
  final Database database;
  final Size screenSize;
  final MyUser user;
  final Job job;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Size screenSize,
    MyUser user,
    Job job,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TimeTrackerApprovePageMobile(
          database: database,
          screenSize: screenSize,
          user: user,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _TimeTrackerApprovePageMobileState createState() =>
      _TimeTrackerApprovePageMobileState();
}

class _TimeTrackerApprovePageMobileState
    extends State<TimeTrackerApprovePageMobile> {
  double totalWorkingHours = 0;
  String dropdownValue = "2021";
  String _jobYears = "2021";
  String _jobMonth = "11";

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
      child: Container(
        color: Colors.grey.withOpacity(0.7),
        height: double.infinity,
        // ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.nickname),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // color: Colors.green,
                  child: Row(
                    children: [
                      Spacer(),
                      DropdownButton<String>(
                        value: _jobYears,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _jobYears = newValue;
                          });
                        },
                        items: <String>[
                          '2022',
                          '2021',
                          '2020',
                          '2019',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Spacer(),
                      DropdownButton<String>(
                        value: _jobMonth,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _jobMonth = newValue;
                          });
                        },
                        items: <String>[
                          '01',
                          '02',
                          '03',
                          '04',
                          '05',
                          '06',
                          '07',
                          '08',
                          '09',
                          '10',
                          '11',
                          '12'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black54,
                  height: widget.screenSize.height / 10,
                  child: Row(
                    children: [
                      StreamBuilder(
                        stream: widget.database.jobsStream(_jobYears, _jobMonth),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          print("++++++" + snapshot.data.toString());
                          List<Job> jobs = snapshot.data;
                          totalWorkingHours = 0;
                          for (int i = 0; i < jobs.length; i++) {
                            print(jobs[i].description);
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
                _listBuilder(context, widget.user ,widget.database),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _listBuilder(BuildContext context, MyUser user, Database database) {
    return StreamBuilder<List<Job>>(
      stream: database.jobsToApproveStream(user.id ,_jobYears, _jobMonth),
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
              child: JobApproveListTile(
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
