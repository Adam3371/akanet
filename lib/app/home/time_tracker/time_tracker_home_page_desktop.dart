import 'dart:async';
import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home/jobs/job_list_tile.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimeTrackerHomePageDesktop extends StatefulWidget {
  const TimeTrackerHomePageDesktop({Key key, this.database, this.screenSize})
      : super(key: key);
  final Database database;
  final Size screenSize;
  // final _nowDate = DateTime.now();
  // final String  dropdownValue = _nowDate.year.toString();
  //   _jobYears = _nowDate.year.toString();

  //   _jobMonth = _nowDate.month.toString();

  @override
  _TimeTrackerHomePageDesktopState createState() =>
      _TimeTrackerHomePageDesktopState();
}

class _TimeTrackerHomePageDesktopState
    extends State<TimeTrackerHomePageDesktop> {
  bool isGettingUpdated = false;
  double totalHours = 0;
  double approvedHours = 0;
  double totWerkHours = 0;
  double appWerkHours = 0;
  DateTime now = new DateTime.now();
  String dropdownValue;
  String _jobYears;

  String _jobMonth;

  List<String> _yearsList = [];
  List<String> _monthList = [];

  StreamSubscription<List<Job>> myStream;
  Stream<List<Job>> jobstream;

  Future<void> _delete(BuildContext context, Job job) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want delete the hours?"),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await widget.database.deleteJob(job);
                  } on FirebaseException catch (e) {
                    showExceptionAlertDialog(
                      context,
                      title: 'Operation failed',
                      exception: e,
                    );
                  }

                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Text(
                  'No',
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    _jobYears = now.year.toString();

    final years = widget.database.jobYearsStream();
    years.listen((year) {
      _yearsList = year;
      print(year);
      final month = widget.database.jobMonthStream(_jobYears);
      month.listen((month) {
        _monthList = month;

        print(_monthList);
        _jobMonth = now.month.toString();
        if (!_monthList.contains(now.month.toString())) {
          widget.database
              .setMonthUpdate(widget.database.getMyUid(), _jobYears, _jobMonth);
          _jobMonth = _monthList.last;
        }
        setState(() {});
      });
    });
    super.initState();
  }

  TextStyle myTextStyle =
      new TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
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
                //rgba(96,125,139,255)
                //rgba(63,81,181,255)
                color: Color.fromARGB(80, 103, 160, 255),
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      "Year: ",
                      style: myTextStyle,
                    ),
                    DropdownButton<String>(
                      value: _jobYears,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: myTextStyle,
                      onChanged: (String newValue) {
                        _jobYears = newValue;
                        final month = widget.database.jobMonthStream(_jobYears);
                        month.listen((month) {
                          setState(() {
                            _monthList = month;
                            _jobMonth =
                                _monthList.contains(now.month.toString())
                                    ? now.month.toString()
                                    : _monthList.last;
                          });
                        });
                      },
                      items: _yearsList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Spacer(),
                    Text(
                      "Month: ",
                      style: myTextStyle,
                    ),
                    DropdownButton<String>(
                      value: _jobMonth,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: myTextStyle,
                      onChanged: (String newValue) {
                        setState(() {
                          _jobMonth = newValue;
                        });
                      },
                      items: _monthList
                          .map<DropdownMenuItem<String>>((String value) {
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
                child: StreamBuilder(
                    stream: widget.database.jobsStream(_jobYears, _jobMonth),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      List<Job> jobs = snapshot.data;

                      // print("jobs:" + jobs.toString());
                      for (int i = 0; i < jobs.length; i++) {
                        // print(jobs[i].description);
                        Job job = jobs[i];
                        totalHours += job.workingHours;
                        if (job.approveStatus == "approved") {
                          approvedHours += job.workingHours;
                        }

                        try {
                          if (job.isWerk) {
                            if (job.approveStatus == "approved") {
                              appWerkHours += job.workingHours;
                            }
                            totWerkHours += job.workingHours;
                          }
                        } catch (_) {}
                      }

                      return Container(
                        color: Colors.black54,
                        height: widget.screenSize.height / 10,
                        child: Container(
                          color: Colors.blueGrey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Total: $totalHours h",
                                style: myTextStyle,
                              ),
                              Text(
                                "Werkstatt: $totWerkHours h",
                                style: myTextStyle,
                              ),
                              Text(
                                "Approved: $approvedHours h",
                                style: myTextStyle,
                              ),
                              Text(
                                "Appr. Werk: $appWerkHours h",
                                style: myTextStyle,
                              ),
                              Row(
                                children: [
                                  Text("Progress"),
                                  StreamBuilder<Object>(
                                      stream: widget.database.userStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }

                                        // MyUser myUser = snapshot.data;

                                        return CircularProgressIndicator(
                                          value: 0.4,
                                        );
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
      stream: database.jobsStream(_jobYears, _jobMonth),
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
