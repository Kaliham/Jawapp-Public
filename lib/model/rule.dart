import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/services/util.dart';

class Rule {
  final Color _color;
  final String _id;
  final String _content;
  final String _related;
  final String _description;
  Rule({id, color, content, related, description = ""})
      : _color = color,
        _content = content,
        _related = related,
        _description = description,
        _id = id;

  factory Rule.fromDoc(QueryDocumentSnapshot doc) {
    return Rule(
        id: doc.id,
        color:
            Util.hexToColor(doc.data()["color"] ?? "#7b428c") ?? Colors.amber,
        content: Util.getMap(doc.data()['title'], 'ar', "-فارغة-"),
        related: Util.getMap(doc.data()['related'], 'ar', ""),
        description: Util.getMap(doc.data()['description'], 'ar', '-فارغة-'));
  }
  Color get color => _color;
  String get content => _content;
  String get related => _related;
  String get description => _description;
  String get id => _id;
}

class ArchiveRule extends Rule {
  ArchiveRule({id, color, content, related, description = ""})
      : super(
            id: id,
            color: color,
            content: content,
            related: related,
            description: description);
  factory ArchiveRule.fromDoc(QueryDocumentSnapshot doc) {
    return ArchiveRule(
      id: doc.id,
      color: Util.hexToColor(doc.data()["color"] ?? "#7b428c") ?? Colors.amber,
      content: Util.getMap(doc.data()['title'], 'ar', "-فارغة-"),
      related: Util.getMap(doc.data()['related'], 'ar', ""),
      description: Util.getMap(doc.data()['description'], 'ar', '-فارغة-'),
    );
  }
}
