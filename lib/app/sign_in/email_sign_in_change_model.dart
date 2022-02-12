import 'package:flutter/foundation.dart';
import 'package:akanet/app/sign_in/email_sign_in_model.dart';
import 'package:akanet/app/sign_in/validators.dart';
import 'package:akanet/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = "",
    this.password = "",
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submittedEmail = false,
    this.submittedPassword = false,
    this.submittedPassword2 = false,
    // this.submittedToken = false,
  });
  final AuthBase auth;
  String email;
  String password = "";
  String password2 = "";
  String token = "";
  EmailSignInFormType formType;
  bool isLoading;
  bool submittedEmail;
  bool submittedPassword;
  bool submittedPassword2;
  // bool submittedToken;

  Future<void> submit() async {
    // updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "sign In"
        : "create an account";
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.register
        ? "Need an account? Register here"
        : "Have an account? Sign in";
  }

  bool get canSubmit {
    if (formType == EmailSignInFormType.register) {
      return emailValidator.isValid(email) &&
          passwordValidator.isValid(password) &&
          passwordValidator.isComplicaded(password) &&
          passwordValidator.isSame(password, password2) &&
          // passwordValidator.tokenMatching(token) &&
          !isLoading;
    } else {
      return emailValidator.isValid(email) &&
          passwordValidator.isValid(password) &&
          !isLoading;
    }
  }

  String get passwordConfirmErrorText {
    bool showErrorText =
        submittedPassword2 && !passwordValidator.isSame(password, password2);
    return showErrorText ? notSamePasswordErrorText : null;
  }

  String get passwordErrorText {
    if (submittedPassword && !passwordValidator.isValid(password)) {
      return invalidPasswordErrorText;
    } else if (submittedPassword &&
        !passwordValidator.isComplicaded(password)) {
      return passwordNotComplicaded;
    } else {
      return null;
    }
  }

  // String get tokenErrorText {
  //   if (submittedToken && !passwordValidator.tokenMatching(token)) {
  //     return tokenErrorText;
  //   } else {
  //     return null;
  //   }
  // }

  String get emailErrorText {
    bool showErrorText = submittedEmail && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateEmail(String email) {
    submittedEmail = true;
    updateWith(email: email);
  }

  void updatePassword(String password) {
    submittedPassword = true;
    updateWith(password: password);
  }

  // void updateToken(String token) {
  //   submittedToken = true;
  //   updateWith(token: token);
  // }

  void updateConfirmPassword(String password2) {
    submittedPassword2 = true;
    updateWith(password2: password2);
  }

  void updateWith({
    String email,
    String password,
    String password2,
    // String token,
    EmailSignInFormType formType,
    bool isLoading,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.password2 = password2 ?? this.password2;
    // this.token = token ?? this.token;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}
