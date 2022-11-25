import 'package:flutter/material.dart';
import 'package:app/constants.dart';

// ignore: must_be_immutable
class SmallList extends StatelessWidget {
  Widget child;
  String title;
  SmallList({this.child, this.title});
  @override
  Widget build(BuildContext context) {
    return _buildContainer(_ListBody(
      child: child,
      title: title,
    ));
  }

  Widget _buildContainer(Widget child) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      margin: EdgeInsets.only(right: 40, left: 40, bottom: 40),
      height: 450,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [Const.basicBoxShadow],
        color: Const.secondBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

// ==========Components=============
class _ListBody extends StatelessWidget {
  Widget child;
  String title;
  _ListBody({
    this.child,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // cards border widget
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: Const.helveticaTitle,
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
