import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/services/util.dart';

class TagInfo {
  final String title;
  final String lang;
  final Color color;
  Function onTap;

  TagInfo({
    this.title,
    this.color = Colors.transparent,
    this.lang = 'ar',
    this.onTap,
  });

  factory TagInfo.fromDoc(QueryDocumentSnapshot doc, String lang) {
    return TagInfo(
      title: Util.getMap(doc.data()['title'], lang),
      color: Util.hexToColor(doc.data()['color']),
      lang: lang,
      onTap: () {},
    );
  }
}
