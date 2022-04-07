import 'package:akanet/app/sign_in/email_register_form_change_notifier.dart';
import 'package:akanet/app/sign_in/email_register_form_change_notifier_desktop.dart';
import 'package:akanet/app/sign_in/email_sign_in_form_change_notifier_dektop.dart';
import 'package:flutter/material.dart';

class EmailRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Register"),
        ),
        elevation: 10,
      ),
      body: screenSize.height > screenSize.width
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: EmailRegisterFormChangeNotifier.create(context),
                ),
              ),
            )
          : EmailRegisterFormChangeNotifierDektop.create(context),
      backgroundColor: Colors.grey[200],
    );
  }
}
