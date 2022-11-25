import 'package:flutter/material.dart';
import 'package:app/model/volunteer.dart';
import 'package:app/view/components/cards/cards.dart';
import 'package:app/view/components/popup/volunteer_popup.dart';

class VolunteerCard extends StatelessWidget {
  final Volunteer _volunteer;
  VolunteerCard(this._volunteer);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CardListItem(
        id: _volunteer.id,
        date: _volunteer.date,
        imageUrl: _volunteer.imgUrl,
        tagsColor: _volunteer.tagsColor,
        title: _volunteer.title,
        description: _volunteer.description,
        function: () {
          Navigator.of(context).push(
            new PageRouteBuilder(
              opaque: false,
              barrierDismissible: true,
              pageBuilder: (BuildContext context, _, __) => VolunteerPopup(
                volunteer: _volunteer,
              ),
            ),
          );
        },
      ),
    );
  }
}
