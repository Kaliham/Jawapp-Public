import 'package:app/constants.dart';
import 'package:app/view/components/lists/order_list.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.secondBackground,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        title: Text("سجل الطلبات",
            style: Const.helveticaTitle.merge(TextStyle(fontSize: 21))),
      ),
      body: OrderList(),
    );
  }
}
