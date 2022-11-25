import 'package:app/constants.dart';
import 'package:app/model/area_control.dart';
import 'package:app/model/limited_resouce.dart';
import 'package:app/view/components/popup/area_control_popup.dart';
import 'package:app/view/components/popup/limited_resources_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AreaControlMarker {
  AreaControlModel model;
  Circle circle;
  BuildContext context;
  AreaControlMarker(this.model, {this.context, Function onTap}) {
    circle = new Circle(
      circleId: CircleId(model.id),
      center: model.position,
      radius: model.radius,
      fillColor: model.color,
      onTap: () => onTapImpl(),
      strokeWidth: 2,
      strokeColor: model.color,
      consumeTapEvents: true,
    );
  }
  void onTapImpl() {
    showDialog(
      context: context,
      builder: (context) {
        return AreaControlPopup(
          buttonColor: model.color,
          buttonFontColor: Colors.white,
          buttonText: model.title,
          text: model.description,
        );
      },
    );
  }
}

class AreaControlPolygon {
  AreaControlPolyModel model;
  Polygon polygon;
  BuildContext context;
  AreaControlPolygon(this.model, {this.context, Function onTap}) {
    polygon = new Polygon(
      polygonId: PolygonId(model.id),
      points: model.positions,
      fillColor: model.color,
      onTap: () => onTapImpl(),
      strokeWidth: 2,
      strokeColor: model.color,
      consumeTapEvents: true,
    );
  }
  void onTapImpl() {
    showDialog(
      context: context,
      builder: (context) {
        return AreaControlPopup(
          buttonColor: model.color,
          buttonFontColor: Colors.white,
          buttonText: model.title,
          text: model.description,
        );
      },
    );
  }
}

class LimitedResourceMarker {
  LimitedResourceModel model;
  Marker marker;
  BuildContext context;
  LimitedResourceMarker(this.model, this.context, {Function onTap}) {
    marker = new Marker(
      markerId: MarkerId(model.id),
      position: model.position,
      infoWindow: InfoWindow(
        title: model.title,
        onTap: onTap ?? onTapImpl,
      ),
    );
  }
  void onTapImpl() {
    showDialog(
      context: context,
      builder: (context) {
        return LimitedResourcesPopup(model);
      },
    );
  }
}
