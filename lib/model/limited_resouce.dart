import 'package:app/constants.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LimitedResourceModel {
  String id;
  String title;
  String description;
  String imgUrl;
  LatLng position;
  Stream<List<Resource>> _resources;

  LimitedResourceModel({
    this.id,
    this.title,
    this.description,
    this.imgUrl,
    this.position,
    Stream<List<Resource>> resources,
  }) : _resources = resources.asBroadcastStream();
  Stream<List<Resource>> get resources =>
      locators.databaseService.resourcesStreamById(id);

  factory LimitedResourceModel.fromDoc(
    QueryDocumentSnapshot doc,
    Stream<List<Resource>> resources,
  ) {
    return LimitedResourceModel(
      id: doc.id,
      title: Util.getMap(doc.data()['title'], 'ar', ""),
      description: Util.getMap(doc.data()['description'], 'ar', ""),
      position: Util.convertLoc(doc.data()['position']),
      imgUrl: doc.data()['imgUrl'],
      resources: resources,
    );
  }
}

class Resource {
  String id;
  String type;
  String imgUrl;
  int availableAmount, actualAmount;
  Tab tab;
  Resource(
      {this.type,
      this.imgUrl,
      this.availableAmount,
      this.actualAmount,
      this.id}) {
    tab = new Tab(
      child: Text(
        type,
        style: Const.defaultTextStyle,
      ),
    );
  }
  factory Resource.fromDoc(QueryDocumentSnapshot doc) {
    return Resource(
      type: Util.getMap(doc.data()['type'], 'ar', "-empty text-"),
      imgUrl: doc.data()['imgUrl'],
      availableAmount: doc.data()['available'],
      actualAmount: doc.data()['actual'],
      id: doc.id,
    );
  }
}
