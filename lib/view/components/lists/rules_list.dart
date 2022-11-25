import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/rule.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:provider/provider.dart';

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        "القانون",
        style: Const.helveticaTitle,
      ),
    );
  }
}

class RulesList extends StatefulWidget {
  @override
  _RulesListState createState() => _RulesListState();
}

class _RulesListState extends State<RulesList> {
  double _width, _height;
  List<Rule> _rules;
  void init(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _rules = Provider.of<List<Rule>>(context) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Const.secondBackground,
          height: _height * 0.5,
          width: _width * 0.85,
          child: Column(
            children: [
              _Header(),
              Expanded(child: _List(rules: _rules)),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<Rule> rules;
  /*====constructor======*/
  _List({
    Key key,
    @required this.rules,
  }) : super(key: key);

  /*===build====*/
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rules.length,
      itemBuilder: itemBuilder,
    );
  }

  Widget itemBuilder(context, index) {
    return Util.buildValid(
      data: rules[index],
      validChild: RuleCard(rules[index]),
      invalidChild: Container(),
    );
  }
}
