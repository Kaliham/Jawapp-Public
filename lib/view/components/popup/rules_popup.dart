import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/rule.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:provider/provider.dart';

class RulesPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.secondBackground,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        title: Text("تاريخ القوانين",
            style: Const.helveticaTitle.merge(TextStyle(fontSize: 21))),
      ),
      body: Container(
        width: double.infinity,
        color: Const.secondBackground,
        child: StreamProvider<List<ArchiveRule>>.value(
          value: locators.databaseService.rulesArchiveStream,
          builder: (context, child) {
            return Container(
              child: ListView.builder(
                itemCount:
                    Provider.of<List<ArchiveRule>>(context).length ?? [].length,
                itemBuilder: (context, index) {
                  ArchiveRule rule =
                      Provider.of<List<ArchiveRule>>(context)[index];
                  return itemBuilder(rule);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget itemBuilder(ArchiveRule rule) {
    return Util.buildValid(
      data: rule,
      validChild: RuleCard(rule),
      invalidChild: Container(),
    );
  }
}
