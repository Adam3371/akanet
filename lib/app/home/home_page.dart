import 'package:akanet/common_widgets/show_alert_dialog.dart';
import 'package:akanet/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:settings_button/Constants.dart';

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Settings', icon: Icons.settings),
  const Choice(title: 'Sign Out', icon: Icons.logout),
];

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
    print("Here");
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
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Akanet"),
        elevation: 5.0,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            icon: Icon(Icons.person),
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () => _confirmSignOut(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/mue31.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _select(Choice choice) {
    if (choice.title == "Settings") {
      print("Settings");
    } else {
      // _confirmSignOut(context);
    }
    // setState(() {});
  }
}
