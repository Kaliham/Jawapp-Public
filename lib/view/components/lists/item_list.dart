import 'package:app/constants.dart';
import 'package:app/model/order.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemList extends StatelessWidget {
  ItemList(this.items);
  List<ItemModel> items = [];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: itemBuilder,
    );
  }

  Widget itemBuilder(context, index) {
    return Column(
      children: [
        Util.buildValid(
          data: items[index],
          validChild: itemCard(items[index]),
          invalidChild: Container(),
        ),
        Divider()
      ],
    );
  }

  Widget itemCard(ItemModel model) {
    bool status = (Util.getStatusCode(model.status));
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Icon(
                status
                    ? Icons.check_circle_outline
                    : Icons.remove_circle_outline,
                color: status ? Colors.green[300] : Colors.red[400]),
          ),
          Expanded(
              flex: 4,
              child: Text(
                model.ar,
                maxLines: 1,
                style: Const.defaultTextStyle,
              )),
          Expanded(
              child: Text(
            "X${model.amount}",
            maxLines: 1,
            style: Const.defaultTextStyle,
          )),
          Expanded(
              child: Text(
            "${model.price}د.أ",
            maxLines: 1,
            style: Const.defaultTextStyle,
          )),
        ],
      ),
    );
  }
}
