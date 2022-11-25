import 'package:app/constants.dart';
import 'package:app/services/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  String email;
  String nationalID;
  Locale lang;
  LatLng homePoint;

  UserModel({
    this.email,
    this.nationalID,
    String langCode,
    Locale lang,
    this.homePoint,
  }) : this.lang = (lang != null) ? lang : Locale(langCode);

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    GeoPoint geoPoint = doc.data()['homepoint'];

    return UserModel(
      email: FirebaseAuth.instance.currentUser.email,
      nationalID: doc.data()['nationalID'],
      langCode: doc.data()['lang'],
      homePoint: LatLng(
        geoPoint.latitude,
        geoPoint.longitude,
      ),
    );
  }
}
