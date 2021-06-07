import 'package:akanet/app/home/Aircraft-tickets/aircraft_tickets_home_desktop.dart';
import 'package:akanet/app/home/Aircraft-tickets/edit_aircraft_page.dart';
import 'package:akanet/app/home/time_tracker/work_time_entry_page.dart';
import 'package:akanet/app/home_2/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class AircraftTicketsHome extends StatefulWidget {
  const AircraftTicketsHome({Key key, this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static const routeName = "/AircraftTicket";

  static Future<void> show(
    BuildContext context, {
    Database database,
    Job job,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => AircraftTicketsHome(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AircraftTicketsHomeState createState() => _AircraftTicketsHomeState();
}

class _AircraftTicketsHomeState extends State<AircraftTicketsHome> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Aircrafts"),
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
              EditAircraftPage.show(context, database: widget.database);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: screenSize.height > screenSize.width
          ? AircraftTicketsHomeDesktop(
              //Mobile
              database: widget.database,
              screenSize: screenSize,
            )
          : AircraftTicketsHomeDesktop(
              database: widget.database,
              screenSize: screenSize,
            ),
    );
  }
}
