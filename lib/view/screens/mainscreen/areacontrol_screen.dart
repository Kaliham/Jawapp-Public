import 'package:app/constants.dart';
import 'package:app/model/limited_resouce.dart';
import 'package:app/model/util/map_marker.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/map/limited_resources_views.dart';
import 'package:app/view/components/map/markers.dart';
import 'package:app/view/components/tags.dart';
import 'package:flutter/material.dart';
import 'package:app/model/tags.dart';
import 'package:app/view/components/cards/article_card.dart';
import 'package:app/view/components/cards/cards.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:app/view/components/parts/header.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AreaControlScreen extends StatefulWidget {
  AreaControlScreen();
  @override
  _AreaControlScreenState createState() => _AreaControlScreenState();
}

class _AreaControlScreenState extends State<AreaControlScreen>
    with
        AutomaticKeepAliveClientMixin,
        cardListItemTester,
        articleCardTester,
        ruleCardTester {
  Set<Marker> allMarkers = {};
  GoogleMapController _controller;
  LatLng homepoint = Const.amman;
  String tagFilter = "";
  final TextEditingController editingController = new TextEditingController();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Const.loadAsync();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print(Localizations.localeOf(context));
    return MultiProvider(
        providers: [
          StreamProvider<Marker>.value(
            value: locators.mapService.homepointMarkerStream,
          ),
          StreamProvider<Set<Circle>>.value(
            value: locators.mapService.areaControlCircleStream(context),
          ),
          StreamProvider<Set<Polygon>>.value(
            value: locators.mapService.areaControlPolygonStream(context),
          ),
          StreamProvider<List<TagInfo>>.value(
            value: locators.databaseService.areaControlTags,
          ),
        ],
        builder: (context, child) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      markers: {context.watch<Marker>()},
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: context.watch<LatLng>(),
                        zoom: 14.0,
                      ),
                      onMapCreated: (controller) {
                        _controller = controller;
                        Util.changeMapMode(_controller);
                      },
                      circles: context.watch<Set<Circle>>(),
                      polygons: context.watch<Set<Polygon>>(),
                    ),
                  ),
                  SizedBox(height: 70),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: buildContent(context),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget buildContent(BuildContext context) {
    final List<TagInfo> tags = [];

    for (TagInfo tagInfo in context.watch<List<TagInfo>>() ?? []) {
      if (tagInfo != null &&
          (tagFilter == "" || tagInfo.title.contains(tagFilter))) {
        tags.add(
          TagInfo(
              title: tagInfo.title,
              lang: tagInfo.lang,
              color: tagInfo.color,
              onTap: () {
                String hex =
                    '#${tagInfo.color.value.toRadixString(16).substring(2).toLowerCase()}';
                setState(() {
                  if (locators.mapService.areacontrolfilter.contains(hex)) {
                    locators.mapService.areacontrolfilter.remove(hex);
                  } else {
                    locators.mapService.areacontrolfilter.add(hex);
                  }
                });
              }),
        );
      }
    }
    return Stack(
      children: [
        Header(
          title: "معلومات المنطقة",
          showSearchBar: true,
          tags: TagsStrip(
            tagModel: tags,
          ),
          searchFunction: () {
            setState(() {
              tagFilter = editingController.value.text;
            });
            editingController.text = tagFilter;
          },
          textController: editingController,
        ),
      ],
    );
  }

  void markersListener() {
    locators.mapService.homepoint.listen((latlng) {
      setState(() {
        homepoint = latlng;
      });
    });
  }
}
