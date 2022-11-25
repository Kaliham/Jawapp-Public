import 'package:app/constants.dart';
import 'package:app/view/components/lists/volunteer_list.dart';
import 'package:flutter/material.dart';

class UserVolunteeringScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.secondBackground,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        title: Text("تاريخ القواعد",
            style: Const.helveticaTitle.merge(TextStyle(fontSize: 21))),
      ),
      body: Container(
        width: double.infinity,
        color: Const.secondBackground,
        child: UsersVolunteerList(Const.secondBackground),
      ),
    );
  }
}
