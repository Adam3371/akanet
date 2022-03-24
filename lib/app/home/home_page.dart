import 'package:akanet/app/home/home_page_desktop.dart';
import 'package:akanet/app/home/home_page_mobile.dart';
import 'package:akanet/app/home/register_data.dart';
import 'package:akanet/common_widgets/show_alert_dialog.dart';
import 'package:akanet/services/auth.dart';
import 'package:akanet/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/my_user.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset("images/akaflieg-logo.png"),
          centerTitle: true,
          title: StreamBuilder<MyUser>(
            stream: database.userStream(),
            builder: (context, snapshot) {
              return Text(
                snapshot.hasData ? snapshot.data.nickname : "Anonymous",
              );
            },
          ),
          elevation: 5.0,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.person),
            ),
            IconButton(
              onPressed: () => _confirmSignOut(context),
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: StreamBuilder<MyUser>(
          stream: database.userStream(),
          builder: (context, snapshot) {
            Future.delayed(Duration(milliseconds: 1000));
            try {
              snapshot.data.name;
            } catch (e) {
              return RegisterData(
                database: database,
              );
            }

            return screenSize.height < screenSize.width
                ? HomePageDesktop(
                    database: database,
                    screenSize: screenSize,
                  )
                : HomePageMobile(
                    database: database,
                    screenSize: screenSize,
                  );
          },
        ));
  }
}
