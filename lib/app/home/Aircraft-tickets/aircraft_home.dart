import 'package:akanet/app/home/Aircraft-tickets/edit_aircraft_page.dart';
import 'package:akanet/app/home/aircraft-tickets/aircraft_home_desktop.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class AircraftHome extends StatefulWidget {
  const AircraftHome({Key key, this.database, this.job})
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
        builder: (context) => AircraftHome(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AircraftHomeState createState() => _AircraftHomeState();
}

class _AircraftHomeState extends State<AircraftHome> {
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
          ? AircraftHomeDesktop(
              //Mobile
              database: widget.database,
              screenSize: screenSize,
            )
          : AircraftHomeDesktop(
              database: widget.database,
              screenSize: screenSize,
            ),
    );
  }
}
