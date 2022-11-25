import 'dart:math';

import 'package:app/model/limited_resouce.dart';
import 'package:app/model/order.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/components/popup/order_popup.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/view/components/generics/generic_popup.dart';
import 'package:app/view/components/widgets/directions_button.dart';
import 'package:app/view/components/widgets/quantity_input.dart';
import 'package:provider/provider.dart';

class LimitedResourcesPopup extends StatefulWidget {
  LimitedResourceModel limitedResourceModel;
  LimitedResourcesPopup(this.limitedResourceModel);
  @override
  _LimitedResourcesPopupState createState() => _LimitedResourcesPopupState();
}

class _LimitedResourcesPopupState extends State<LimitedResourcesPopup> {
  double get width => 0.9 * screenWidth;
  double get height => 0.9 * screenHeight;
  double screenWidth, screenHeight;
  Color get buttonColor => Const.accent;
  LimitedResourceModel get model => widget.limitedResourceModel;
  List<Tab> tabs = [];
  List<Widget> tabViews = [];
  Map<String, TextEditingController> quantityControllers = {};
  List<Resource> resources = [];
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    initValues(context);

    return Container(
      child: PopUpGeneric(
        topChild: buildTop(context),
        midChild: (_loading)
            ? Center(child: CircularProgressIndicator())
            : buildMid(context),
        botChild: (_loading) ? Container() : buildBot(context),
        topFlex: 4,
        midFlex: 6,
        botFlex: 1,
        widthRatio: 1,
        heightRatio: 0.85,
      ),
    );
  }

  Widget buildTop(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: Image.network(
            model.imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Color(0x3f000000), blurRadius: 12)
            ]),
            width: 50,
            child: IconButton(
              // shape: CircleBorder(),
              color: Colors.white,
              icon: Icon(
                Icons.close,
                color: Colors.grey[900],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMid(BuildContext context) {
    return StreamProvider<List<Resource>>.value(
      value: model.resources,
      builder: (context, snapshot) {
        if (context.watch<List<Resource>>() != null &&
            context.watch<List<Resource>>().isNotEmpty) {
          tabViews = [];
          tabs = [];
          resources = context.watch<List<Resource>>();
          //mapping
          resources.forEach((resource) {
            tabs.add(resource.tab);

            quantityControllers
                .addAll({resource.id: new TextEditingController(text: "0")});
            tabViews.add(content(context, resource));
          });
          return DefaultTabController(
            length: context.watch<List<Resource>>().length,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 30,
                  child: Text(
                    model.title,
                    style: Const.defaultTextStyle.merge(TextStyle(
                      fontSize: 23,
                    )),
                  ),
                ),
                Container(
                  height: 40,
                  child: TabBar(
                    tabs: tabs,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: tabViews,
                  ),
                ),
              ],
            ),
          );
        }
        //if null or no data
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget content(BuildContext context, Resource resource) {
    return FutureBuilder(
        future: locators.databaseService.limitAmount(resource.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          int userLimit = snapshot.data;
          int limit = min(resource.availableAmount, userLimit);
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  child: DirectionsButton(model.position),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  alignment: Alignment.center,
                  child: QuantityInput(
                    limit: limit,
                    textEditingController: quantityControllers[resource.id],
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Container(
                  child: Text(
                    "${resource.type} باق: ${resource.availableAmount} ",
                    style:
                        Const.defaultTextStyle.merge(TextStyle(fontSize: 19)),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Container(
                  child: Text(
                    "الكمية المصرح بها: $userLimit",
                    style:
                        Const.defaultTextStyle.merge(TextStyle(fontSize: 19)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget buildBot(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: FlatButton(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                child: Text(
                  "طلب",
                  style: Const.defaultTextStyle.merge(TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ),
              onPressed: order,
              color: buttonColor,
            ),
          ),
          Container(
            width: 3,
            height: double.infinity,
            color: Colors.white,
          ),
          Flexible(
            flex: 1,
            child: FlatButton(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                child: Text(
                  "طلب",
                  style: Const.defaultTextStyle.merge(TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ),
              onPressed: order,
              color: buttonColor,
            ),
          ),
        ],
      ),
    );
  }

  void order() async {
    setState(() {
      _loading = true;
    });
    List<Map<String, dynamic>> items = [];
    resources.forEach((element) {
      int amount = int.parse(quantityControllers[element.id].text.toString());
      if (amount > 0) items.add({"id": element.id, "amount": amount});
      print(items);
    });
    OrderModel orderModel = null;
    if (items != []) {
      orderModel =
          await locators.orderService.order(merchantId: model.id, items: items);
    }
    print(orderModel.status);
    setState(() {
      _loading = false;
    });
    if (orderModel != null) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => OrderPopup(orderModel),
      );
    }
  }

  void initValues(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
