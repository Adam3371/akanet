import 'package:akanet/app/home/models/aircraft_ticket.dart';
import 'package:akanet/app/home/models/my_user.dart';
import 'package:flutter/material.dart';

class AircraftTicketListTile extends StatelessWidget {
  const AircraftTicketListTile({
    Key key,
    @required this.aircraftTicket,
    this.onTap,
  }) : super(key: key);
  final AircraftTicket aircraftTicket;  
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<MyUser>(
          builder: (context, snapshot) {
            return Expanded(
              child: ListTile(
                title: Text(aircraftTicket.title),
                subtitle: Text(aircraftTicket.dateCreate != null ? aircraftTicket.dateCreate : "0"),
                onTap: onTap,
                // trailing: Text("Status:" + aircraftTicket.status.toString() + " Prio: " + aircraftTicket.prio.toString()),
                // tileColor: aircraftTicket.prio > 2 ? Colors.red : Colors.green,
              ),
            );
          }
        ),
      ],
    );
  }
}
