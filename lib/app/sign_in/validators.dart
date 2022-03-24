
abstract class StringValidator {
  bool isValid(String value);
  bool isComplicaded(String value);
  bool isSame(String pass1, String pass2);
  // bool tokenMatching(String token);
}


class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
  @override
  bool isComplicaded(String value) {
    String  pattern = r'^(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regExp = new RegExp(pattern);
        return regExp.hasMatch(value);
      // r'^
      // (?=.*[A-Z])       // should contain at least one upper case
      // (?=.*[a-z])       // should contain at least one lower case
      // (?=.*?[0-9])      // should contain at least one digit
      // (?=.*?[!@#\$&*~]) // should contain at least one Special character
      // .{8,}             // Must be at least 8 characters in length  
      // $
  }
    @override
  bool isSame(String pass1, String pass2) {
    return pass1 == pass2;
  }

}

  class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
  final String notSamePasswordErrorText = "Passwords are not matching";
  final String passwordNotComplicaded = "The password must at least be 8 char long, contain a digit and a special character";

}