import 'package:akanet/app/home_2/job_entries/job_entries_page.dart';
import 'package:akanet/app/home_2/jobs/job_list_tile.dart';
import 'package:akanet/app/home_2/jobs/list_items_builder.dart';
import 'package:akanet/app/home_2/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class ItTicketPage extends StatelessWidget {
  const ItTicketPage({Key key, this.database}) : super(key: key);

  final Database database;

  static Future<void> show(
    BuildContext context, {
    Database database,
    // Job job,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => ItTicketPage(
          database: database,
          // job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('IT Tickets'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            //  => EditJobPage.show(
            //   context,
            //   database: Provider.of<Database>(context, listen: false),

            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildContents(context, screenSize),
    );
  }

  _buildContents(BuildContext context, Size screenSize) {
    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/mue31.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.withOpacity(0.7),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.black54,
                ),
                height: screenSize.height / 10,
              ),
              _listBuilder(context),
            ],
          ),
        ),
      ),
    );
  }

  _listBuilder(BuildContext context) {
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
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
                JobEntriesPage.show(context, database, job);
              },
            ),
          ),
        );
      },
    );
  }
}
