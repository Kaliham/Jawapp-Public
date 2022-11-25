import 'package:app/services/setup_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/tags.dart';
import 'package:app/services/util.dart';

class Volunteer {
  final String _title,
      _description,
      _article,
      _date,
      _phoneNo,
      _imgUrl,
      _limit,
      _id;
  final List<TagInfo> tags;
  final List<Color> tagsColor;
  final int limit;
  bool has;
  final List<String> volunteers;

  Volunteer(
    this._id,
    this._title,
    this._description,
    this._article,
    this._date,
    this._phoneNo,
    this._imgUrl,
    this._limit,
    this.tags,
    this.limit,
    this.tagsColor,
    this.has,
    this.volunteers,
  );
  factory Volunteer.fromDoc(QueryDocumentSnapshot doc) {
    int limit = doc.data()['limit'] ?? 0;
    bool has = false;

    List<String> volunteers = [];
    if (doc.data()['volunteers'] != null &&
        doc.data()['volunteers'].isNotEmpty) {
      print(doc.data()['volunteers'] as List<dynamic>);
      print("volunteers $volunteers");
      print("volunteers here");
      // volunteers = (doc.data()['volunteers'] as List<String>);
      (doc.data()['volunteers'] as List<dynamic>).forEach((element) {
        print(element.toString() + "wow");
        volunteers.add(element.toString());
      });
      print("volunteers here");
      if (volunteers.contains(locators.userService.id)) {
        has = true;
      }
    }
    print("volunteers $volunteers");
    List<TagInfo> tags = [];
    List<Color> tagsColor = [];
    if (doc.data()['tags'] != null)
      for (Map<String, dynamic> tag in doc.data()['tags']) {
        Color color = Util.hexToColor(tag['color']);
        tags.add(TagInfo(color: color, title: tag['ar']));
        tagsColor.add(color);
      }
    if (tagsColor.isEmpty) tagsColor.add(Colors.transparent);
    print("volunteers $volunteers");
    return Volunteer(
      doc.id,
      Util.getMap(doc.data()['title'], 'ar', "No Title"),
      Util.getMap(doc.data()['description'], 'ar'),
      Util.getMap(doc.data()['article'], 'ar'),
      doc.data()['date'] ?? '',
      doc.data()['phoneNo'] ?? '',
      doc.data()['imgUrl'] ?? Const.imgBroken,
      limit.toString(),
      tags,
      limit,
      tagsColor,
      has,
      volunteers,
    );
  }
  String get title => _title;
  String get description => _description;
  String get article => _article;
  String get date => _date;
  String get phoneNo => _phoneNo;
  String get imgUrl => _imgUrl;
  String get limitStr => _limit;
  String get id => _id;
}

class SearchVolunteer extends Volunteer {
  SearchVolunteer(_id, _title, _description, _article, _date, _phoneNo, _imgUrl,
      _limit, tags, limit, tagsColor, has, volunteers)
      : super(_id, _title, _description, _article, _date, _phoneNo, _imgUrl,
            _limit, tags, limit, tagsColor, has, volunteers);
  factory SearchVolunteer.fromDoc(QueryDocumentSnapshot doc) {
    int limit = doc.data()['limit'] ?? 0;
    bool has = false;
    List<String> volunteers = [];
    if (doc.data()['volunteers'] != null) {
      volunteers = doc.data()['volunteers'] as List<String>;
      if ((doc.data()['volunteers'] as List<dynamic>)
          .contains(locators.userService.id)) {
        has = true;
      }
    }

    List<TagInfo> tags = [];
    List<Color> tagsColor = [];
    for (Map<String, dynamic> tag in doc.data()['tags']) {
      Color color = Util.hexToColor(tag['color']);
      tags.add(TagInfo(color: color, title: tag['ar']));
      tagsColor.add(color);
    }
    if (tagsColor.isEmpty) tagsColor.add(Colors.transparent);
    return SearchVolunteer(
      doc.id,
      Util.getMap(doc.data()['title'], 'ar', "No Title"),
      Util.getMap(doc.data()['description'], 'ar'),
      Util.getMap(doc.data()['article'], 'ar'),
      doc.data()['date'] ?? '',
      doc.data()['phoneNo'] ?? '',
      doc.data()['imgUrl'] ?? Const.imgBroken,
      limit.toString(),
      tags,
      limit,
      tagsColor,
      has,
      volunteers,
    );
  }
}
