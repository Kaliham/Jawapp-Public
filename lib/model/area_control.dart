import 'package:app/services/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AreaControlModel {
  String id;
  String title;
  String description;
  double radius;
  LatLng position;
  Color color;
  AreaControlModel({
    this.id,
    this.title,
    this.color,
    this.description,
    this.position,
    this.radius,
  });

  factory AreaControlModel.fromDoc(QueryDocumentSnapshot doc) {
    return AreaControlModel(
      id: doc.id,
      title: Util.getMap(doc.data()['title'], 'ar', ""),
      description: Util.getMap(doc.data()['description'], 'ar', ""),
      position: Util.convertLoc(doc.data()['position']),
      radius: doc.data()['radius'] ?? 10.0,
      color: Util.hexToColor(doc.data()['color'], alphaChannel: '9f'),
    );
  }
}

class AreaControlPolyModel {
  String id;
  String title;
  String description;

  List<LatLng> positions;
  Color color;
  AreaControlPolyModel({
    this.id,
    this.title,
    this.color,
    this.description,
    this.positions,
  });

  factory AreaControlPolyModel.fromDoc(QueryDocumentSnapshot doc) {
    List<LatLng> positions = [];
    for (GeoPoint geoPoint in (doc.data()['points'] ?? []) as List<dynamic>) {
      positions.add(Util.convertLoc(geoPoint));
    }
    return AreaControlPolyModel(
      id: doc.id,
      title: Util.getMap(doc.data()['title'], 'ar', ""),
      description: Util.getMap(doc.data()['description'], 'ar', ""),
      positions: positions,
      color: Util.hexToColor(doc.data()['color'], alphaChannel: '9f'),
    );
  }
}
