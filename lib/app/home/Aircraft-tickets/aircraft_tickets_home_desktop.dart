import 'package:akanet/app/home/aircraft-tickets/aircraft_ticket_list_tile.dart';
import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/app/home/models/aircraft_ticket.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';

class AircraftTicketsHomeDesktop extends StatelessWidget {
  const AircraftTicketsHomeDesktop({Key key, this.database, this.screenSize, this.aircraft})
      : super(key: key);
  final Database database;
  final Size screenSize;
  final Aircraft aircraft;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/mue31.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
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
                  child: _listBuilder(context, database),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _listBuilder(BuildContext context, Database database) {
    return StreamBuilder<List<AircraftTicket>>(
      stream: database.aircraftTicketsStream(aircraftId: aircraft.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<AircraftTicket>(
          snapshot: snapshot,
          itemBuilder: (context, aircraftTicket) => Dismissible(
            key: Key('job-${aircraftTicket.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            // onDismissed: (direction) => _delete(context, job),
            child: AircraftTicketListTile(
              aircraftTicket: aircraftTicket,
              onTap: () {
                /* WorkTimeEntryPage.show(
                  context,
                  database: database,
                  job: job,
                ); */
              },
            ),
          ),
        );
      },
    );
  }
}
