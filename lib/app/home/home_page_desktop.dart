import 'package:akanet/app/home/aircraft-tickets/aircraft_home.dart';
import 'package:akanet/app/home/time_manager/time_manager_home_page.dart';
import 'package:akanet/app/home/time_tracker/time_tacker_home_page.dart';
import 'package:akanet/app/home/job_entries/job_entries_page.dart';
import 'package:akanet/app/home/jobs/edit_job_page.dart';
import 'package:akanet/app/home/jobs/job_list_tile.dart';
import 'package:akanet/app/home/jobs/list_items_builder.dart';
import 'package:akanet/app/home/models/job.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageDesktop extends StatelessWidget {
  const HomePageDesktop({
    Key key,
    this.screenSize,
    this.database,
  }) : super(key: key);
  final Size screenSize;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background_desktop.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          chat(context),
          Container(
            width: 2 * screenSize.width / 3.0,
            child: Padding(
              padding: EdgeInsets.only(
                top: (screenSize.height / 20.0),
                left: 100,
                right: 100,
              ),
              child: GridView.count(
                crossAxisCount: 3,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        TimeTrackerHomePage.show(
                          context,
                          database:
                              Provider.of<Database>(context, listen: false),
                        );
                        print("Click");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.black54.withOpacity(0.5),
                        elevation: 10.0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Time Tracker",
                              style: TextStyle(
                                // fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Test2"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.black54.withOpacity(0.5),
                        elevation: 10.0,
                        child: ListTile(
                          leading: Text(
                            "IT Ticket",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.black54.withOpacity(0.5),
                      elevation: 10.0,
                      child: ListTile(
                        leading: Text(
                          "Schnorr",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        AircraftHome.show(
                          context,
                          database:
                              Provider.of<Database>(context, listen: false),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.black54.withOpacity(0.5),
                        elevation: 10.0,
                        child: ListTile(
                          leading: Text(
                            "Aircrafts",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.black54.withOpacity(0.5),
                      elevation: 10.0,
                      child: ListTile(
                        leading: Text(
                          "GV Protokolle",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        TimeManagerHomePage.show(
                          context,
                          database:
                              Provider.of<Database>(context, listen: false),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.black54.withOpacity(0.5),
                        elevation: 10.0,
                        child: ListTile(
                          leading: Text(
                            "Time Manager",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.black54.withOpacity(0.5),
                      elevation: 10.0,
                      child: ListTile(
                        leading: Text(
                          "Settings",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chat(BuildContext context) {
    return Container(
      width: screenSize.width / 3.0,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenSize.height / 20.0,
          bottom: screenSize.height / 20.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: screenSize.height / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.blueGrey.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => EditJobPage.show(
                    context,
                    database: Provider.of<Database>(context, listen: false),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Chat",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.orange,
                  child: Text(
                    "Sorry, this feature is currently under construction...",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Spacer(),
                Container(
                  color: Colors.green.withOpacity(0.5),
                  child: Row(
                    children: [
                      Container(
                        width: 500,
                        child: TextField(),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
