import 'package:app/services/setup_locator.dart';
import 'package:flutter/material.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/volunteer_card.dart';
import 'package:provider/provider.dart';
import 'package:app/model/volunteer.dart';

class VolunteerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Volunteer> volunteers = context.watch<List<Volunteer>>() ?? [];
    return Container(
      // decoration: BoxDecoration(boxShadow: [Const.basicBoxShadow]),
      color: Colors.white,
      width: double.infinity,
      child: _List(volunteers),
    );
  }
}

class _List extends StatelessWidget {
  final List<Volunteer> volunteers;
  _List(this.volunteers);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: volunteers.length,
      itemBuilder: itemBuilder,
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Util.buildValid(
      data: volunteers[index],
      validChild: VolunteerCard(volunteers[index]),
      invalidChild: Container(),
    );
  }
}

class SearchVolunteerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SearchVolunteer> volunteers =
        context.watch<List<SearchVolunteer>>() ?? [];
    return Container(
      // decoration: BoxDecoration(boxShadow: [Const.basicBoxShadow]),
      color: Colors.white,
      width: double.infinity,
      child: _ListSearch(volunteers),
    );
  }
}

class _ListSearch extends StatelessWidget {
  final List<SearchVolunteer> volunteers;
  _ListSearch(this.volunteers);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: volunteers.length,
      itemBuilder: itemBuilder,
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Util.buildValid(
      data: volunteers[index],
      validChild: VolunteerCard(volunteers[index]),
      invalidChild: Container(),
    );
  }
}

class UsersVolunteerList extends StatelessWidget {
  Color color;
  UsersVolunteerList([this.color = Colors.white]);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Volunteer>>.value(
        value: locators.databaseService.myVolunteering,
        builder: (context, snapshot) {
          return Container(
            // decoration: BoxDecoration(boxShadow: [Const.basicBoxShadow]),
            color: color,
            width: double.infinity,
            child: _List(context.watch<List<Volunteer>>() ?? []),
          );
        });
  }
}
