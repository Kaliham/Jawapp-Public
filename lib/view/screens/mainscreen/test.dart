import 'package:flutter/material.dart';
import 'package:app/model/rule.dart';
import 'package:app/services/database_services.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:provider/provider.dart';

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          StreamProvider<List<Rule>>.value(
            value: (context.watch<DatabaseService>()).rulesStream,
            catchError: (_, __) => null,
          ),
        ],
        builder: (context, child) {
          List<Rule> list = context.watch<List<Rule>>() ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) => Util.buildValid(
              data: list[index],
              validChild: RuleCard(list[index]),
              invalidChild: Container(),
            ),
          );
        },
      ),
    );
  }
}
