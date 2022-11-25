import 'package:app/constants.dart';
import 'package:app/model/order.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/generics/generic_card.dart';
import 'package:app/view/components/popup/order_popup.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCard extends StatefulWidget {
  OrderModel model;
  OrderCard(this.model);
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  OrderModel get model => widget.model;
  String get storeName => widget.model.store.ar;
  @override
  Widget build(BuildContext context) {
    return GenericCardItem(
      leftFlex: 3,
      rightFlex: 1,
      rightChild: _buildRightChild(context),
      leftChild: _buildLeftChild(context),
      function: onTap,
    );
  }

  onTap() {
    showDialog(context: context, builder: (contxt) => OrderPopup(model));
  }

  void locationOnPressed() async {
    await Util.openMap(model.position.latitude, model.position.longitude);
  }

  Widget _buildRightChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      width: double.infinity,
      height: double.infinity,
      child: FlatButton(
        child: Icon(
          Icons.directions,
        ),
        onPressed: locationOnPressed,
      ),
    );
  }

  Widget _buildLeftChild(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.zero,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  storeName,
                  style: Const.defaultTextStyle.merge(
                    TextStyle(fontSize: 20),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Text(
                model.itemDetails(),
                style: Const.defaultTextStyle.apply(color: Const.lightGrey),
                maxLines: 3,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  model.getPrice(),
                  style: Const.defaultTextStyle.merge(
                    TextStyle(
                      color: Const.accent,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
