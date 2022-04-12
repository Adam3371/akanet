import 'package:akanet/app/home/models/job_month_overview.dart';
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
  double totalWorkingHours = 0;
  double openWorkingHours = 0;
  double approvedWorkingHours = 0;
  DateTime now = new DateTime.now();
  String dropdownValue;
  String _jobYears;

  String _jobMonth;

  List<String> _yearsList = [];
  List<String> _monthList = [];

  Future<void> _updateMonthHours() async {
    try {
      setState(() {
        isGettingUpdated = true;
      });

      double totalHours = 0;
      double approvedHours = 0;
      double totWerkHours = 0;
      double appWerkHours = 0;

      final years = widget.database.jobYearsStream();
      years.listen((year) {
        _yearsList = year;
        for (String y in year) {
          final months = widget.database.jobMonthStream(_jobYears);
          months.listen((month) {
            print(_monthList);
            _monthList = month;
            for (String m in month) {
              JobMonthOverview jMO;
              final jobs = widget.database.jobsStream(_jobYears, m);
              jobs.listen((j) {
                for (Job job in j) {
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
                  } catch (e) {
                    print("Internal Error: " + e.toString());
                  }
                }
                final jobMonthOverview = JobMonthOverview(
                  totalHours: totalHours,
                  approvedHours: approvedHours,
                  totWerkHours: totWerkHours,
                  appWerkHours: appWerkHours,
                );
                jMO = jobMonthOverview;
                print("hours: " + jobMonthOverview.totalHours.toString());
              });
              widget.database.setMonthUpdate(widget.database.getMyUid(), y, m, jMO);
            }
          });
        }

        setState(() {
          isGettingUpdated = false;
        });
      });
    } catch (e) {
      print("External Error: " + e);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async {
    bool _willBeDeleted = true;
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want delete the hours?"),
            actions: [
              TextButton(
                onPressed: () async {
                  _willBeDeleted = true;
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
                  _willBeDeleted = false;
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
    if (_willBeDeleted) {}
  }

  @override
  void initState() {
    final years = widget.database.jobYearsStream();
    years.listen((year) {
      _yearsList = year;

      final month = widget.database.jobMonthStream(_jobYears);
      month.listen((month) {
        // if (month != null) _monthList = ['y', '1', '2', '4'];
        print(_monthList);
        _monthList = month;

        // for (String m in month) {}
        // print(_yearsList);
        print(_monthList);
        setState(() {});
      });
    });

    _jobYears = now.year.toString();
    _jobMonth = now.month.toString();

    super.initState();
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
                color: Colors.black54,
                height: widget.screenSize.height / 10,
                child: StreamBuilder(
                  stream: widget.database.jobsStream(_jobYears, _jobMonth),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    // print("++++++" + snapshot.data.toString());
                    List<Job> jobs = snapshot.data;
                    totalWorkingHours = 0;
                    openWorkingHours = 0;
                    approvedWorkingHours = 0;
                    for (int i = 0; i < jobs.length; i++) {
                      // print(jobs[i].description);
                      Job job = jobs[i];
                      totalWorkingHours += job.workingHours;
                      if (job.approveStatus == "approved") {
                        approvedWorkingHours += job.workingHours;
                      } else {
                        openWorkingHours += job.workingHours;
                      }
                    }
                    TextStyle myTextStyle = new TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold);

                    return Container(
                      color: Colors.blueGrey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Total: $totalWorkingHours h",
                            style: myTextStyle,
                          ),
                          Text(
                            "Approved: $approvedWorkingHours h",
                            style: myTextStyle,
                          ),
                          isGettingUpdated
                              ? CircularProgressIndicator()
                              : MaterialButton(
                                  child: Text(
                                    "update",
                                    style: myTextStyle,
                                  ),
                                  onPressed: () {
                                    _updateMonthHours();
                                  },
                                )
                          // StreamBuilder(
                          //   stream: widget.database.jobYearsStream(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.waiting) {
                          //       return CircularProgressIndicator();
                          //     }

                          //     QuerySnapshot snap = snapshot.data;
                          //     List<DocumentSnapshot> documents = snap.docs;
                          //     print(documents.length);

                          //     return StreamBuilder(
                          //         stream:
                          //             widget.database.jobMonthStream("2022"),
                          //         builder: (context, snapshot1) {
                          //           QuerySnapshot snap1 = snapshot1.data;
                          //           List<DocumentSnapshot> documents1 =
                          //               snap1.docs;
                          //               print("instream: " + documents1.length.toString());
                          //           documents1.forEach(
                          //             (element) {
                          //               print(element.id.toString());
                          //             },
                          //           );

                          //           return Text("test");
                          //         });

                          //   },
                          // ),
                        ],
                      ),
                    );
                  },
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
