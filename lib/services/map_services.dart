import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/model/area_control.dart';
import 'package:app/model/limited_resouce.dart';
import 'package:app/model/util/map_marker.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/components/map/markers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  AreaMapMarker areaMapMarker = new AreaMapMarker({});
  LimitedMapMarker limitedMapMarker = new LimitedMapMarker({});
  List<LimitedResourceMarker> markers = [];
  //public Stream controllers
  List<String> areacontrolfilter = [];
  List<String> limitedResourceFilter = [];
  //model stream controllers
  StreamController<LatLng> _hompointStream =
      new StreamController<LatLng>.broadcast();
  StreamController<List<AreaControlMarker>> _areaControlStream =
      new StreamController<List<AreaControlMarker>>.broadcast();
  StreamController<List<AreaControlPolygon>> _areaControlPolyModelStream =
      new StreamController<List<AreaControlPolygon>>.broadcast();
  StreamController<List<LimitedResourceMarker>> _limitedResourcesStream =
      new StreamController<List<LimitedResourceMarker>>.broadcast();
  StreamController<List<String>> filterLimitedResource =
      new StreamController<List<String>>.broadcast();
  //map stream controllers
  StreamController<Set<Circle>> _areaControlCircle =
      new StreamController<Set<Circle>>.broadcast();
  StreamController<Set<Polygon>> _areaControlPoly =
      new StreamController<Set<Polygon>>.broadcast();
  StreamController<Set<Marker>> _limiteMarkerController =
      new StreamController<Set<Marker>>.broadcast();
  StreamController<Marker> _homepointController =
      new StreamController<Marker>.broadcast();
  Stream<LatLng> get homepoint {
    locators.databaseService.userDataStream.listen(
      (userData) {
        _hompointStream.add(userData?.homePoint ?? Const.amman);
      },
    );
    return _hompointStream.stream;
  }

  void changeFilter() {
    filterLimitedResource.add(limitedResourceFilter);
  }

  Stream<List<AreaControlMarker>> areaControlMarkerModelStream(
      BuildContext context) {
    List<AreaControlMarker> markers = [];
    locators.databaseService.areaControlModels.listen((models) {
      for (AreaControlModel model in models) {
        markers.add(
          new AreaControlMarker(model, context: context),
        );
      }
      _areaControlStream.add(markers);
    });

    return _areaControlStream.stream;
  }

  Stream<List<AreaControlPolygon>> areaControlPolygonModelStream(
      BuildContext context) {
    List<AreaControlPolygon> markers = [];
    locators.databaseService.areaControlPolyModels.listen((models) {
      for (AreaControlPolyModel model in models) {
        markers.add(
          new AreaControlPolygon(model, context: context),
        );
      }
      _areaControlPolyModelStream.add(markers);
    });

    return _areaControlPolyModelStream.stream;
  }

  Stream<List<LimitedResourceMarker>> limiterMarkerStream(
      BuildContext context) {
    ;
    locators.databaseService.limitedResourcesModels.listen((models) {
      for (LimitedResourceModel model in models) {
        markers.add(new LimitedResourceMarker(model, context));
      }
      _limitedResourcesStream.add(markers);
    });

    return _limitedResourcesStream.stream;
  }

  Stream<Set<Circle>> areaControlCircleStream(BuildContext context) {
    Set<Circle> circles = new Set<Circle>();
    areaControlMarkerModelStream(context).listen((markers) {
      markers.forEach((element) {
        circles.add(element.circle);
      });
      _areaControlCircle.add(circles);
    });

    return _areaControlCircle.stream;
  }

  Stream<Set<Polygon>> areaControlPolygonStream(BuildContext context) {
    Set<Polygon> polygons = new Set<Polygon>();
    areaControlPolygonModelStream(context).listen((polygonsFromModel) {
      polygonsFromModel.forEach((element) {
        polygons.add(element.polygon);
      });
      _areaControlPoly.add(polygons);
    });

    return _areaControlPoly.stream;
  }

  Stream<Set<Marker>> limitedResourceMarkerStream(
      BuildContext context, List<LimitedResourceModel> list) {
    futureLimited(context, list).asStream().listen((event) {
      _limiteMarkerController.add(event);
    });

    return _limiteMarkerController.stream;
  }

  Future<Set<Marker>> futureLimited(
      BuildContext context, List<LimitedResourceModel> list) async {
    Set<Marker> markersSet = new Set<Marker>();
    list.forEach((model) async {
      markers.add(new LimitedResourceMarker(model, context));
    });
    var homepoint = await homepointMarkerStream.first;
    markersSet.add(homepoint);
    markers.forEach((element) {
      markersSet.add(element.marker);
    });
    return markersSet;
  }

  Stream<Marker> get homepointMarkerStream {
    homepoint.listen((position) {
      _homepointController.add(
        Marker(
          markerId: MarkerId("Home"),
          position: position,
          icon: Const.homepointIcon,
        ),
      );
    });
    return _homepointController.stream;
  }
}
