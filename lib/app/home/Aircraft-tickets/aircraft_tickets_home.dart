import 'package:akanet/app/home/aircraft-tickets/aircraft_tickets_home_desktop.dart';
import 'package:akanet/app/home/aircraft-tickets/edit_aircraft_ticket_page.dart';
import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class AircraftTicketsHome extends StatefulWidget {
  const AircraftTicketsHome(
      {Key key, this.database, this.screenSize, this.aircraft})
      : super(key: key);
  final Database database;
  final Size screenSize;
  final Aircraft aircraft;

  static const routeName = "/AircraftTickets";

  static Future<void> show(
    BuildContext context, {
    Database database,
    Aircraft aircraft,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => AircraftTicketsHome(
          database: database,
          aircraft: aircraft,
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
        title: Text(widget.aircraft.name),
        leading: InkWell(
          child: Image.asset("images/akaflieg-logo.png"),
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
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
              // print("Here223");a
              EditAircraftTicketPage.show(context, database: widget.database, aircraft: widget.aircraft);
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
              aircraft: widget.aircraft,
            )
          : AircraftTicketsHomeDesktop(
              //Desktop
              database: widget.database,
              screenSize: screenSize,
              aircraft: widget.aircraft,
            ),
    );
  }
}
