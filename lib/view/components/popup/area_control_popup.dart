import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/view/components/generics/generic_popup.dart';
import 'package:provider/provider.dart';

class AreaControlPopup extends StatefulWidget {
  final Color buttonColor, buttonFontColor;
  final String text, buttonText;
  AreaControlPopup({
    this.buttonColor = const Color(0xffFC5C5C),
    this.buttonFontColor = Colors.white,
    this.text = "نص فارغ!",
    this.buttonText = "غير معرف!",
  });

  @override
  _AreaControlPopupState createState() => _AreaControlPopupState();
  // void show(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AreaControlPopup(),
  //   );
  // }
}

class _AreaControlPopupState extends State<AreaControlPopup> {
  Color get buttonColor => widget.buttonColor;
  Color get buttonFontColor => widget.buttonFontColor;
  String get text => widget.text;
  String get buttonText => widget.buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopUpGeneric(
        topChild: _buildTop(context),
        midChild: _buildMid(context),
        botChild: _buildBot(context),
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey[700],
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Widget _buildMid(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: Const.defaultTextStyle.merge(
          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBot(BuildContext context) {
    return FlatButton(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          buttonText,
          style: Const.defaultTextStyle.merge(TextStyle(
            color: buttonFontColor,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          )),
        ),
      ),
      onPressed: () {},
      color: buttonColor,
    );
  }
}
