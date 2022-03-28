import 'package:akanet/app/sign_in/email_sign_in_form_change_notifier_dektop.dart';
import 'package:flutter/material.dart';
import 'package:akanet/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Sign in   "),
        ),
        elevation: 10,
      ),
      body: screenSize.height > screenSize.width
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: EmailSignInFormChangeNotifier.create(context),
                ),
              ),
            )
          : EmailSignInFormChangeNotifierDesktop.create(context),
      backgroundColor: Colors.grey[200],
    );
  }
}
