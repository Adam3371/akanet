import 'package:flutter/cupertino.dart';
import 'package:akanet/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          color: color,
          onPressed: onPressed,
          borderRadius: 4.0,
        );
}
