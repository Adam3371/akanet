import 'package:akanet/app/sign_in/email_sign_in_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:akanet/app/sign_in/email_sign_in_change_model.dart';
import 'package:akanet/common_widgets/form_submit_button.dart';
import 'package:akanet/common_widgets/show_exception_alert_dialog.dart';
import 'package:akanet/services/auth.dart';

import 'dart:convert';

import 'package:crypto/crypto.dart';

String tokenValue =
    "4fccf741af7e4e0ee281a9796a47482e718bce41903083559e7cd30cbf0805ae"; //AkafliegMunichRocks7824!

class EmailRegisterFormChangeNotifier extends StatefulWidget {
  EmailRegisterFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailRegisterFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailRegisterFormChangeNotifierState createState() =>
      _EmailRegisterFormChangeNotifierState();
}

class _EmailRegisterFormChangeNotifierState
    extends State<EmailRegisterFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _tokenFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tokenController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _tokenFocusNode.dispose();
    super.dispose();
  }

  bool validateToken(String token) {
    var output = sha256.convert(utf8.encode(token)).toString();
    return tokenValue == output;
  }

  Future<void> _submit() async {
    if (!validateToken(_tokenController.text)) {
      showExceptionAlertDialog(
        context,
        title: "Wrong Token!",
        exception: Exception("Contact your admin to get the right token"),
      );
    } else {
      try {
        // model.submitted = true;
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
  }

  // TODO:
  // Add other focus node

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 10.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 20.0,
      ),
      _buildConfirmPasswordTextField(),
      SizedBox(
        height: 20.0,
      ),
      _buildTokenTextField(),
      SizedBox(
        height: 40.0,
      ),
      FormSubmitButton(
        onPressed: model.canSubmit ? _submit : null,
        text: model.primaryButtonText,
      ),
      SizedBox(
        height: 10.0,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
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
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      obscureText: true,
      // onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildConfirmPasswordTextField() {
    return TextField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        errorText: model.passwordConfirmErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      obscureText: true,
      // onEditingComplete: _submit,
      onChanged: model.updateConfirmPassword,
    );
  }

  TextField _buildTokenTextField() {
    return TextField(
      controller: _tokenController,
      focusNode: _tokenFocusNode,
      decoration: InputDecoration(
        labelText: "Token",
        // errorText: model.tokenErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: model.canSubmit ? _submit : null,
      // onChanged: model.updateToken,
    );
  }

  @override
  void initState() {
    model.formType = EmailSignInFormType.register;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
