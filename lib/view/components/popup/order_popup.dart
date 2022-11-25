import 'package:app/constants.dart';
import 'package:app/model/order.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/components/generics/generic_popup.dart';
import 'package:app/view/components/lists/item_list.dart';
import 'package:app/view/components/lists/order_list.dart';
import 'package:flutter/material.dart';

class OrderPopup extends StatefulWidget {
  OrderModel model;
  OrderPopup(this.model);
  @override
  _OrderPopupState createState() => _OrderPopupState();
}

class _OrderPopupState extends State<OrderPopup> {
  OrderModel get model => widget.model;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(model.status);
    return Container(
      child: PopUpGeneric(
        widthRatio: 0.9,
        heightRatio: 0.8,
        botFlex: (_loading) ? 0 : 1,
        topChild: (_loading)
            ? Container()
            : Container(
                child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          (model.status == "ordered")
                              ? Icons.check_circle_outline
                              : Icons.remove_circle_outline,
                          color: (model.status == "ordered")
                              ? Colors.greenAccent[200]
                              : Colors.redAccent,
                        ),
                        Text(
                          "تمت العملية بنجاح",
                          style: Const.defaultTextStyle
                              .merge(TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                        });
                        locators.orderService.cancel(model.id);
                        model.status = 'canceled';
                        setState(() {
                          _loading = false;
                        });
                      },
                      child: Text(
                        "إلغاء",
                        style: Const.defaultTextStyle.merge(
                            TextStyle(fontSize: 20, color: Colors.red[400])),
                      ),
                    ),
                  ),
                ],
              )),
        midChild: Container(
          child: ItemList(model.items),
        ),
        botChild: _buildBot(context),
      ),
    );
  }

  Widget _buildBot(BuildContext context) {
    return FlatButton(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          "أغلق",
          style: Const.defaultTextStyle.merge(TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          )),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      color: Const.accent,
    );
  }
}
