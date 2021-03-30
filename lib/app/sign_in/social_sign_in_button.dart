import 'package:flutter/material.dart';
import 'package:akanet/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String asssetName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(asssetName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(asssetName),
              Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700),
              ),
              Opacity(
                opacity: 0,
                child: Image.asset("images/google-logo.png"),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
