import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home/jobs/job_list_tile.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimeTrackerHomePageMobile extends StatefulWidget {
  const TimeTrackerHomePageMobile({Key key, this.database, this.screenSize})
      : super(key: key);
  final Database database;
  final Size screenSize;
  // final _nowDate = DateTime.now();
  // final String  dropdownValue = _nowDate.year.toString();
  //   _jobYears = _nowDate.year.toString();

  //   _jobMonth = _nowDate.month.toString();

  @override
  _TimeTrackerHomePageMobileState createState() =>
      _TimeTrackerHomePageMobileState();
}

class _TimeTrackerHomePageMobileState extends State<TimeTrackerHomePageMobile> {
  double totalWorkingHours = 0;
  DateTime now = new DateTime.now();
  String dropdownValue = "2021";
  String _jobYears = "2021";

  String _jobMonth = "11";

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
                  setState(() {
                    
                  });
                },
                child: Text("Yes"),
              ),
              TextButton(
                  onPressed: () {
                    _willBeDeleted = false;
                    Navigator.of(context).pop();
                    setState(() {
                    
                  });
                  },
                  child: Text('No'))
            ],
          );
        });
    if (_willBeDeleted) {}
  }

  @override
  void initState() {
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
                    // StreamBuilder<List<String>>(
                    //   stream: widget.database.jobYearsStream(),
                    //   builder: (context, snapshot) {
                    //     if (!snapshot.hasData)
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     final List<String> items = snapshot.data;
                    //     for (int i = 0; i < items.length; i++) {
                    //       print("--------------${items[i]}");
                    //     }
                    //     return DropdownButton(
                    //       onChanged: (valueSelectedByUser) {
                    //         setState(
                    //           () {
                    //             print("--------" +
                    //                 items
                    //                     .firstWhere((element) =>
                    //                         element == valueSelectedByUser)
                    //                     );
                    //             _jobYears = valueSelectedByUser;

                    //           },
                    //         );
                    //       },
                    //       value: _jobYears,
                    //       hint: Text('Choose project'),
                    //       isDense: true,
                    //       items: items.map((value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value),
                    //         );
                    //       }).toList(),
                    //     );
                    //   },
                    // ),
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
                        '1',
                        '2',
                        '3',
                        '4',
                        '5',
                        '6',
                        '7',
                        '8',
                        '9',
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
                        // print("++++++" + snapshot.data.toString());
                        List<Job> jobs = snapshot.data;
                        totalWorkingHours = 0;
                        for (int i = 0; i < jobs.length; i++) {
                          // print(jobs[i].description);
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
