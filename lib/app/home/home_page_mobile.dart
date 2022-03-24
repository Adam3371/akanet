import 'package:akanet/app/home/IT-Ticket/it_ticket_page.dart';
import 'package:akanet/app/home/time_manager/time_manager_home_page.dart';
import 'package:akanet/app/home/time_tracker/time_tacker_home_page.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/my_user.dart';

class HomePageMobile extends StatelessWidget {
  const HomePageMobile({Key key, this.screenSize, this.database})
      : super(key: key);
  final Size screenSize;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background.jpg"),
          fit: BoxFit.cover,

          // scale: 0.3,
        ),
      ),
      child: Container(
        width: 2 * screenSize.width / 3.0,
        child: Padding(
          padding: EdgeInsets.only(
            top: (screenSize.height / 20.0),
            left: screenSize.width / 15,
            right: screenSize.width / 15,
          ),
          child: GridView.count(
            crossAxisCount: 3,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () {
                    TimeTrackerHomePage.show(
                      context,
                      database: Provider.of<Database>(context, listen: false),
                    );
                    print("Click");
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                            color: Colors.white,
                            // fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Test3"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () {
                    ItTicketPage.show(
                      context,
                      database: Provider.of<Database>(context, listen: false),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.black54.withOpacity(0.5),
                  elevation: 10.0,
                  child: ListTile(
                    leading: Text(
                      "Aircraft",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.black54.withOpacity(0.5),
                  elevation: 10.0,
                  child: ListTile(
                    leading: Text(
                      "GV-Pro",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.black54.withOpacity(0.5),
                  elevation: 10.0,
                  child: ListTile(
                    leading: Text(
                      "Setting",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              StreamBuilder<MyUser>(
                  stream: database.userStream(),
                  builder: (context, snapshot) {
                    // print("snapshot: " + snapshot.data.name.toString());
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.black54.withOpacity(0.5),
                        elevation: 10.0,
                        child: snapshot.hasData
                            ? ListTile(
                                leading: Text(
                                  snapshot.data.rank,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : CircularProgressIndicator(),
                      ),
                    );
                  }),
              StreamBuilder<MyUser>(
                stream: database.userStream(),
                builder: (context, snapshot) {
                  // print("snapshot: " + snapshot.data.name.toString());
                  return GestureDetector(
                    onTap: () {
                      TimeManagerHomePage.show(
                        context,
                        database: Provider.of<Database>(context, listen: false),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.black54.withOpacity(0.5),
                          elevation: 10.0,
                          child: snapshot.hasData
                              ? snapshot.data.rank == "Admin"
                                  ? ListTile(
                                      leading: Text(
                                        "Time Manager",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    )
                              : CircularProgressIndicator()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
