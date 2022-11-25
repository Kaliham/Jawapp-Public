import 'package:flutter/material.dart';
import 'package:app/view/components/cards/article_card.dart';
import 'package:app/view/components/cards/cards.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:app/view/components/lists/volunteer_list.dart';
import 'package:app/view/components/parts/header.dart';
import 'package:app/view/screens/searchscreen/volunteer_search.dart';

// ignore: must_be_immutable
class VolunteerScreen extends StatefulWidget {
  Color color;
  VolunteerScreen(this.color);
  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen>
    with
        AutomaticKeepAliveClientMixin,
        cardListItemTester,
        articleCardTester,
        ruleCardTester {
  TextEditingController textEditingController = new TextEditingController();
  @override
  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(child: VolunteerList()),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Header(
      title: "عمل تطوعي",
      searchFunction: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VolunteerSearchScreen(
              textController: textEditingController,
              title: "عمل تطوعي",
            ),
          ),
        );
      },
      textController: textEditingController,
    );
  }
}
