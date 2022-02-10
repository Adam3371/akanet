import 'package:akanet/app/home/models/aircraft.dart';
import 'package:akanet/app/home/models/my_user.dart';
import 'package:flutter/material.dart';

class AircraftListTile extends StatelessWidget {
  const AircraftListTile({
    Key key,
    @required this.aircraft,
    this.openJobs,
    this.onTap,
  }) : super(key: key);
  final Aircraft aircraft;
  
  final VoidCallback onTap;
  final int openJobs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<MyUser>(
          builder: (context, snapshot) {
            return Expanded(
              child: ListTile(
                title: Text(aircraft.name),
                subtitle: Text(aircraft.mantainer),
                onTap: onTap,
                trailing: Text(openJobs != null ? openJobs.toString() : "0"),
              ),
            );
          }
        ),
      ],
    );
  }
}
