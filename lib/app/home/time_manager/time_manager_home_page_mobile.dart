import 'package:akanet/app/home/models/my_user.dart';
import 'package:akanet/app/home/time_manager/time_manager_approve_page_desktop.dart';
import 'package:akanet/app/home/time_manager/time_manager_approve_page_mobile.dart';
import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home/jobs/job_list_tile.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimeManagerHomePageMobile extends StatefulWidget {
  const TimeManagerHomePageMobile({Key key, this.database, this.screenSize})
      : super(key: key);
  final Database database;
  final Size screenSize;
  // final _nowDate = DateTime.now();
  // final String  dropdownValue = _nowDate.year.toString();
  //   _jobYears = _nowDate.year.toString();

  //   _jobMonth = _nowDate.month.toString();

  @override
  _TimeManagerHomePageMobileState createState() =>
      _TimeManagerHomePageMobileState();
}

class _TimeManagerHomePageMobileState extends State<TimeManagerHomePageMobile> {
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

                        return Text("Open Hours to Approve: $totalWorkingHours");
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
    return StreamBuilder<List<MyUser>>(
      stream: database.usersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return ListItemsBuilder<MyUser>(
          snapshot: snapshot,
          itemBuilder: (context, user) {
            // totalWorkingHours += job.ratePerHour;
            // print(totalWorkingHours);
            return Dismissible(
              key: Key('user-${user.name}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              child: ListTile(
                onTap: () {
                  print("Here12");
                  TimeTrackerApprovePageMobile.show(
                    context,
                    user: user,
                    screenSize: widget.screenSize,
                    database: database,
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const TimeManagerApprovePageDesktop()),
                  // );
                },
                title: Text(user.nickname),
              ),
            );
          },
        );
      },
    );
  }
}
