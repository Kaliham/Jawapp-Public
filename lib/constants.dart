import 'dart:typed_data';
import 'dart:ui';

import 'package:app/services/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Const {
  static BitmapDescriptor homepointIcon;
  static void loadAsync() async {
    homepointIcon = await _myIcon;
  }

  static const String imgBroken =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Blank-document-broken.svg/1024px-Blank-document-broken.svg.png";
//Colors
  static const Color grey = Color(0xff707070);
  static const Color lighterGrey = Color(0xffF3F3F3);
  static const Color lightGrey = Color(0xffA3A3A3);
  static const Color accent = Color(0xff6695F0);
  static const Color secondartAccent = Color(0xff97A2B7);
  static const Color darkBlue = Color(0xff4F89F7);
  static const Color secondBackground = Color(0xFFF1F1F1);
  static const Color backgroundColor = Colors.white;
  static const Color lightShadowColor = Color(0x0f000000);
  static const Color shadowColor = Color(0x2f000000);
  static const Color darkShadowColor = Color(0x3f000000);
  static const Color red = Color(0xfff05959);
  static const Color yellow = Color(0xfffce76f);
  static const LatLng amman = LatLng(31.953815, 35.910483);
  static const BoxShadow basicBoxShadow = BoxShadow(
    color: Color(0x3A000000),
    offset: Offset(0.7, 2.0), //(x,y)
    blurRadius: 6.0,
  );
  static Future<BitmapDescriptor> get _myIcon async {
    final Uint8List markerIcon =
        await Util.getBytesFromAsset('assets/images/homepoint.ico', 100);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

// numbers
  static const double widthAspect1 = 0.85;
  static const double widthAspect2 = 0.65;
  static const double cardHeight = 115;
  static const double smallCardHeight = 65;
  static const double articleCardHeight = 150;

//padding margin
  static const EdgeInsets zeroEdgeInsets = EdgeInsets.all(0);
// font styles
  static TextStyle get defaultTextStyle => helvetica;

  static TextStyle get nunitoTextStyle => GoogleFonts.nunito();
  static TextStyle get nunito16 => GoogleFonts.nunito(fontSize: 16);
  static Function get nunito => GoogleFonts.nunito;
  static TextStyle get helvetica => TextStyle(
        color: grey,
        fontSize: 16,
        fontFamily: "Helvetica Neue",
        fontWeight: FontWeight.w300,
      );
  static TextStyle get helveticaTitle => helvetica.apply(
        fontSizeDelta: 6,
        fontSizeFactor: 1,
      );
  static NeumorphicStyle get neustyle => NeumorphicStyle(
        shape: NeumorphicShape.convex,
        color: Colors.white,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
        intensity: 0.66,
        surfaceIntensity: 0.01,
      );
}

class StatusCode {
  static final success = "نجاح!";
  static final failure = "فشل!";

  static final String WrongLogin = "اسم المستخدم خاطئ / كلمة المرور!";
  static final String NetworkIssue = "مشكلة في الشبكة!";
  static final String UnknownError = "خطأ غير معروف!";
}
