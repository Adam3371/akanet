import 'package:akanet/app/home_2/job_entries/job_entries_page.dart';
import 'package:akanet/app/home_2/jobs/edit_job_page.dart';
import 'package:akanet/app/home_2/jobs/job_list_tile.dart';
import 'package:akanet/app/home_2/jobs/list_items_builder.dart';
import 'package:akanet/app/home_2/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        leading: Image.asset("images/akaflieg-logo.png"),
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
              EditJobPage.show(context, database: widget.database);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/mue31.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: screenSize.width / 4,
              // color: Colors.amber,
            ),
            Container(
              width: 2 * screenSize.width / 4,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: _listBuilder(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _listBuilder(BuildContext context) {
    return StreamBuilder<List<Job>>(
      stream: widget.database.jobsStream(),
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
                  print("Here");
                  JobEntriesPage.show(context, widget.database, job);
                }),
          ),
        );
      },
    );
  }
}

// Navigator.of(context).pushNamed(WorkTimeEntryPage.routeName,
