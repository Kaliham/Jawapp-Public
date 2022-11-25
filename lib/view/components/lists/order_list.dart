import 'package:app/model/order.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderList extends StatelessWidget {
  List<OrderModel> list = [];
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<OrderModel>>.value(
        value: locators.databaseService.orders,
        builder: (context, widget) {
          list = context.watch() ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: itemBuilder,
          );
        });
  }

  Widget itemBuilder(context, index) {
    return Util.buildValid(
      data: list[index],
      validChild: OrderCard(list[index]),
      invalidChild: Container(),
    );
  }
}
