import 'package:app/constants.dart';
import 'package:app/model/limited_resouce.dart';
import 'package:app/model/util/map_marker.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/map/limited_resources_views.dart';
import 'package:app/view/components/map/markers.dart';
import 'package:flutter/material.dart';
import 'package:app/model/tags.dart';
import 'package:app/view/components/cards/article_card.dart';
import 'package:app/view/components/cards/cards.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:app/view/components/parts/header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LimitedResourcesScreen extends StatefulWidget {
  LimitedResourcesScreen();
  @override
  LimitedResourcesScreenState createState() => LimitedResourcesScreenState();
}

class LimitedResourcesScreenState extends State<LimitedResourcesScreen>
    with
        AutomaticKeepAliveClientMixin,
        cardListItemTester,
        articleCardTester,
        ruleCardTester {
  GoogleMapController _controller;
  LatLng homepoint = Const.amman;
  PageController _pageController;
  List<String> filters = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
        providers: [
          StreamProvider<List<LimitedResourceModel>>.value(
            value: locators.databaseService.limitedResourcesModels,
          ),
          StreamProvider<List<Resource>>.value(
            value: locators.databaseService.resourcesStream,
            catchError: (context, error) {},
          ),
          StreamProvider<Marker>.value(
            value: locators.mapService.homepointMarkerStream,
            catchError: (context, error) {},
            initialData: new Marker(
              markerId: MarkerId(""),
            ),
          ),
        ],
        builder: (context, snapshot) {
          Set<Marker> markers = {};
          Set<Marker> markersInit = {};
          List<LimitedResourceMarker> markersModel = [];
          (context.watch<List<LimitedResourceModel>>() ?? []).forEach((model) {
            markersModel.add(new LimitedResourceMarker(model, context));
          });
          markersInit.add(context.watch<Marker>());
          markersModel.forEach((element) {
            markersInit.add(element.marker);
          });

          int i = 0;
          (markersInit ?? {}).forEach((element) {
            int j = i;
            markers.add(
              new Marker(
                markerId: element.markerId,
                position: element.position,
                infoWindow: element.infoWindow,
                icon: element.icon,
                onTap: () {
                  if (j > 0)
                    _pageController.animateToPage(
                      j - 1,
                      duration: Duration(milliseconds: 350),
                      curve: Curves.easeIn,
                    );
                },
              ),
            );
            i++;
          });
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GoogleMap(
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
                      markers: markers,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      height: 120,
                      child: StoresStrip(
                        mapController: _controller,
                        models: context.watch<List<LimitedResourceModel>>(),
                        pageController: _pageController,
                      )),
                  Container(
                    height: 95,
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        Header(
          title: "موارد محدودة",
          showSearchBar: false,
        ),
        Container(
          height: 90,
          child: ResourceTagStrip(
            resources: context.watch<List<Resource>>(),
            state: this,
          ),
        ),
      ],
    );
  }
}
