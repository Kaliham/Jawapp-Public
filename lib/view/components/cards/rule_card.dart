import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';
import 'package:app/model/rule.dart';
import 'package:app/view/components/generics/circle.dart';
import 'package:app/view/components/popup/area_control_popup.dart';

import '../generics/generic_card.dart';

// ignore: must_be_immutable
class RuleCard extends StatefulWidget {
  Rule rule;
  RuleCard(this.rule);
  @override
  _RuleCardState createState() => _RuleCardState();
}

class _RuleCardState extends State<RuleCard> {
  Color get color => widget.rule.color;
  String get content => widget.rule.content;
  String get related => widget.rule.related;
  String get description => widget.rule.description;
  // ignore: non_constant_identifier_names
  final double HEIGHT = 65;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GenericCardItem(
        hasShadow: false,
        height: HEIGHT,
        color: Colors.white,
        leftFlex: 1,
        rightFlex: 4,
        leftChild: buildLeftChild(context),
        rightChild: buildRightChild(context),
        function: () {
          showDialog(
            context: context,
            builder: (_) => AreaControlPopup(
              buttonColor: color,
              text: description,
              buttonText: content,
            ),
          );
          // AreaControlPopup areaControlPopup = new AreaControlPopup();
          // areaControlPopup.show(context);
        },
      ),
    );
  }

  Widget buildLeftChild(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircleContainer(
        size: 18,
        color: color,
      ),
    );
  }

  Widget buildRightChild(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Text(
                content,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Const.defaultTextStyle.merge(TextStyle(fontSize: 18)),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  related,
                  overflow: TextOverflow.clip,
                  style: Const.defaultTextStyle.apply(color: Const.accent),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

mixin ruleCardTester {
  Widget testRuleCard() {
    Rule rule = new Rule(
      color: Colors.amber,
      content: "ddd ddddddd dd ddd dddd dddddddddd dd ddd dddd dddddddddd ",
      related: "every monday mongo gg",
    );
    return RuleCard(rule);
  }
}
