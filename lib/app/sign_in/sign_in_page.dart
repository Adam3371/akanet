import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akanet/app/sign_in/email_sign_in_page.dart';
import 'package:akanet/app/sign_in/sign_in_manager.dart';
import 'package:akanet/app/sign_in/sign_in_button.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception.toString() ==
        "PlatformException(popup_closed_by_user, Exception raised from GoogleAuth.signIn(), https://developers.google.com/identity/sign-in/web/reference#error_codes_2, null)") {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: "Sign in failed",
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => EmailSignInPage(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    print(screenSize);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Akanet",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Image.asset("images/akaflieg-logo.png"),
        elevation: 10,
      ),
      backgroundColor: Colors.grey[300],
      body: screenSize.height > screenSize.width
          ? _buildContentMobile(context, screenSize)
          : _buildContentDesktop(context, screenSize),
    );
  }

  Padding _buildContentMobile(BuildContext context, Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.0,
            child: _buildHeader(screenSize),
          ),
          SizedBox(
            height: 48.0,
          ),
          SignInButton(
            text: "Sign in with email",
            color: Colors.teal[600],
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "or",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SignInButton(
            text: "Go anonymous",
            color: Colors.black26,
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _buildContentDesktop(BuildContext context, Size screenSize) {
    return SingleChildScrollView(
      child: Container(
        width: screenSize.width,
        height: screenSize.height / 1.05,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/gruppenbild.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: screenSize.width / 3.0,
            ),
            Container(
              width: screenSize.width / 3.0,
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenSize.height / 20.0,
                  bottom: screenSize.height / 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.blueGrey.withOpacity(0.5),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        height: 80.0,
                        child: _buildHeader(screenSize),
                      ),
                      SizedBox(
                        height: screenSize.height > 500
                            ? screenSize.height / 4
                            : screenSize.height / 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SignInButton(
                          text: "Sign in with email",
                          // color: Colors.teal[600],
                          // textColor: Colors.white,
                          onPressed: isLoading
                              ? null
                              : () => _signInWithEmail(context),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "or",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SignInButton(
                          text: "Request Credentials",
                          color: Colors.black54,
                          textColor: Colors.white,
                          onPressed: isLoading
                              ? null
                              : () => _signInAnonymously(context),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: screenSize.width / 3.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
