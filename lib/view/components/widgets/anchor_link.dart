import 'package:flutter/material.dart';
import 'package:app/constants.dart';

class AnchorLink extends StatelessWidget {
  final Function onTap;
  final Color color;
  final String text;
  AnchorLink({this.onTap, this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Text(
          text,
          style: Const.defaultTextStyle.merge(TextStyle(
              decoration: TextDecoration.underline,
              color: color,
              fontWeight: FontWeight.w500)),
        ),
        onTap: onTap,
      ),
    );
  }
}
