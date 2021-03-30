import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akanet/app/sign_in/email_sign_in_change_model.dart';
import 'package:akanet/common_widgets/form_submit_button.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/auth.dart';

class EmailSignInFormChangeNotifierDesktop extends StatefulWidget {
  EmailSignInFormChangeNotifierDesktop({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifierDesktop(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierDesktopState createState() =>
      _EmailSignInFormChangeNotifierDesktopState();
}

class _EmailSignInFormChangeNotifierDesktopState
    extends State<EmailSignInFormChangeNotifierDesktop> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign in Failed",
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Widget _buildPasswordTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white.withOpacity(0.8),
      ),
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          labelText: "Password",
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false,
        ),
        textInputAction: TextInputAction.done,
        obscureText: true,
        onEditingComplete: _submit,
        onChanged: model.updatePasswor,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white.withOpacity(0.8),
      ),
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "test@test.com",
          errorText: model.emailErrorText,
          enabled: model.isLoading == false,
        ),
        // autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingComplete(),
        onChanged: model.updateEmail,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
                        child: Text(
                          "Sign In with Email",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height > 600
                            ? screenSize.height / 8
                            : screenSize.height / 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildEmailTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildPasswordTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FormSubmitButton(
                          onPressed: model.canSubmit ? _submit : null,
                          text: model.primaryButtonText,
                        ),
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
}
