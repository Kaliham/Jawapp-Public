import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';

class SearchBar extends StatelessWidget {
  final String hint;
  final TextInputType textInputType;
  final Color color;
  final double width;
  final Function searchFunction;
  TextEditingController textController;
  SearchBar(
      {this.hint = "بحث...",
      this.textInputType = TextInputType.text,
      this.color = Colors.white,
      this.width = double.infinity,
      this.searchFunction,
      TextEditingController textController}) {
    this.textController =
        (textController != null) ? textController : new TextEditingController();
  }

  final double height = 40.0;
  final BorderRadius borderRadius = BorderRadius.circular(15.0);
  final EdgeInsets outerPadding = const EdgeInsets.all(4.0);
  final EdgeInsets innerPadding = const EdgeInsets.fromLTRB(10, 0, 4, 0);
  final EdgeInsets buttonPadding = const EdgeInsets.fromLTRB(5, 0, 5, 0);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: Container(
        //decoration container
        height: height,
        width: width,
        decoration: decorateContainer(),
        child: Padding(
          padding: innerPadding,
          child: buildContent(context),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5),
        Flexible(
          fit: FlexFit.tight,
          flex: 6,
          child: buildTextField(context),
        ),
        Flexible(
          child: buildButton(context),
        ),
      ],
    );
  }

  InputDecoration getInputDecoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: Const.defaultTextStyle.apply(color: Const.lightGrey),
    );
  }

  Widget buildTextField(BuildContext context) {
    return TextField(
      controller: textController,
      style: Const.defaultTextStyle,
      keyboardType: textInputType,
      cursorColor: Const.grey,
      decoration: getInputDecoration(context),
    );
  }

  Widget buildButton(BuildContext context) {
    return Container(
      padding: buttonPadding,
      margin: EdgeInsets.all(0.0),
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: Icon(Icons.search),
        onPressed: searchFunction,
      ),
    );
  }

  BoxDecoration decorateContainer() {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: color,
      boxShadow: [
        BoxShadow(
          color: Const.shadowColor,
          blurRadius: 8.0,
        ),
      ],
    );
  }
}
