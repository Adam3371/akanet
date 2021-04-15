
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akanet/app/landing_page.dart';
import 'package:akanet/services/auth.dart';

import 'app/home/time_tracker/time_tacker_home_page.dart';
import 'app/home/time_tracker/work_time_entry_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Akanet",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        // home: LandingPage(),
        initialRoute: "/",
        routes: {
          "/": (context) => LandingPage(),
          // TimeTrackerHomePage.routeName: (context) => TimeTrackerHomePage(),
          // WorkTimeEntryPage.routeName: (context) => WorkTimeEntryPage(),
        },
      ),
    );
  }
}
