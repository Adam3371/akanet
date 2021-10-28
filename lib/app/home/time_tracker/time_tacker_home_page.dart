import 'package:akanet/app/home/time_tracker/time_tracker_home_page_desktop.dart';
import 'package:akanet/app/home/time_tracker/time_tracker_home_page_mobile.dart';
import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home_2/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class TimeTrackerHomePage extends StatefulWidget {
  const TimeTrackerHomePage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static const routeName = "/TimeTracker";

  static Future<void> show(
    BuildContext context, {
    Database database,
    Job job,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TimeTrackerHomePage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _TimeTrackerHomePageState createState() => _TimeTrackerHomePageState();
}

class _TimeTrackerHomePageState extends State<TimeTrackerHomePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Image.asset("images/akaflieg-logo.png"),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        // title: Text(
        // auth.currentUser.email == null
        //     ? "Anonymous"
        //     : auth.currentUser.email.toString(),
        // ),
        elevation: 5.0,
        actions: [
          IconButton(
            onPressed: () {
              print("Here2");
              WorkTimeEntryPage.show(context, database: widget.database);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: screenSize.height > screenSize.width
          ? TimeTrackerHomePageMobile(
              database: widget.database,
              screenSize: screenSize,
            )
          : TimeTrackerHomePageDesktop(
              database: widget.database,
              screenSize: screenSize,
            ),
    );
  }
}

// Navigator.of(context).pushNamed(WorkTimeEntryPage.routeName,
