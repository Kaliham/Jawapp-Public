import 'package:app/view/components/generics/generic_card.dart';
import 'package:app/view/components/lists/volunteer_list.dart';
import 'package:app/view/screens/historyscreen/order_history_screen.dart';
import 'package:app/view/screens/historyscreen/user_volunteer_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/tags.dart';
import 'package:app/view/components/cards/article_card.dart';
import 'package:app/view/components/cards/cards.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:app/view/components/lists/rules_list.dart';
import 'package:app/view/components/parts/header.dart';
import 'package:app/view/components/popup/rules_popup.dart';
import 'package:app/view/components/inputFields/search_bar.dart';
import 'package:app/view/components/tags.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  Color color;
  HomeScreen(this.color);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        AutomaticKeepAliveClientMixin,
        cardListItemTester,
        articleCardTester,
        ruleCardTester {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    final List<TagInfo> tags = [];
    return Column(
      children: [
        Header(
          title: "القانون",
          showSearchBar: false,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: 25, right: 25),
            children: [
              RulesList(),
              SizedBox(
                height: 20,
              ),
              _buildButton(context, "عرض تاريخ القانون", () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RulesPopup(),
                    ));
              }),
              SizedBox(
                height: 20,
              ),
              _buildButton(context, "عرض قائمة التطوع", () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserVolunteeringScreen(),
                    ));
              }),
              SizedBox(
                height: 20,
              ),
              _buildButton(context, "عرض محفوظات الطلبات", () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryScreen(),
                    ));
              }),
              buildFooter(),
              buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, Function onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Const.secondBackground,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.85,
        child: FlatButton(
          child: Center(
            child: Text(
              text,
              style: Const.helveticaTitle.apply(color: Const.accent),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hello',
          style: Const.defaultTextStyle.merge(TextStyle(fontSize: 28)),
        ),
        SizedBox(
          height: 30,
        ),
        SearchBar(),
        buildTags(context),
      ],
    );
  }

  Widget buildTags(BuildContext context) {
    return TagsStrip().temp(context);
  }

  Widget buildFooter() {
    return SizedBox(
      height: 65,
    );
  }
}
