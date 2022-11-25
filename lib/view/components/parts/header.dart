import 'package:flutter/material.dart';

import 'package:app/view/components/inputFields/search_bar.dart';
import 'package:app/view/components/tags.dart';
import 'package:app/view/screens/settings_screen.dart';

import '../../../constants.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  final Widget tags;
  final String title;
  final bool showSearchBar;
  Function searchFunction;
  TextEditingController textController;
  Header(
      {this.title,
      this.tags,
      this.showSearchBar = true,
      this.searchFunction,
      this.textController});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Text(
              title,
              style: Const.defaultTextStyle.merge(TextStyle(fontSize: 32)),
            ),
            SizedBox(
              height: 30,
            ),
            if (showSearchBar)
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SearchBar(
                  searchFunction: searchFunction,
                  textController: textController,
                ),
              ),
            tags ?? Container(),
          ],
        ),
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.settings),
            onPressed: () => goToSettings(context),
            color: Const.grey,
            iconSize: 32,
          ),
        ),
      ],
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }
}
