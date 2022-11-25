import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/view/components/generics/generic_card.dart';

class TextCard extends StatefulWidget {
  final String text;
  TextCard({this.text = "Empty text!"});
  @override
  _TextCardState createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  String get text => widget.text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GenericCardItem(
        color: Colors.white,
        rightFlex: 0,
        leftChild: buildContent(context),
        height: Const.smallCardHeight,
        function: () {},
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Const.defaultTextStyle.merge(
          TextStyle(fontWeight: FontWeight.w500, color: Const.accent),
        ),
      ),
    );
  }
}
