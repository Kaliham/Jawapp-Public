import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/constants.dart';
import 'package:app/model/tags.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    if (hexString?.isEmpty ?? "") return Colors.transparent;
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  static String getMap(Map<String, dynamic> s, String check,
      [String def = "-فارغة-"]) {
    return (s ?? const {})[check] ?? def;
  }

  static Widget buildValid({
    dynamic data,
    Widget validChild,
    Widget invalidChild,
  }) {
    if (data != null) {
      return validChild;
    } else {
      return invalidChild;
    }
  }

  static String check(String data, String alt) {
    return (data != null && data != "") ? data : alt;
  }

  static List<TagInfo> createTags(
    dynamic tagsMap,
    String lang,
  ) {
    List<TagInfo> tags = [];
    for (Map<String, dynamic> tag in tagsMap) {
      tags.add(
        TagInfo(
          color: Util.hexToColor(
              Util.check(tag['color'].toString().trim(), "#eee")),
          title: tag[lang],
          lang: lang,
        ),
      );
    }
    return tags;
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Const.accent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void changeMapMode(controller) {
    _getJsonTheme().then((json) => _setMapStyle(json, controller));
  }

  static Future<String> _getJsonTheme() async {
    return await rootBundle.loadString("assets/configs/map.json");
  }

  static void _setMapStyle(String mapstyle, _controller) {
    _controller.setMapStyle(mapstyle);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static LatLng convertLoc(GeoPoint point) {
    return new LatLng(
      point?.latitude,
      point?.longitude,
    );
  }

  static LatLng getLocFromMap(map) {
    return new LatLng(
        double.parse(map['latitude']), double.parse(map['longitude']));
  }

  static DateTime parseTime(strTime) {
    return DateTime.parse(strTime);
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static bool getStatusCode(String code) {
    switch (code) {
      case "success":
        return true;
      default:
        return false;
    }
  }
}
