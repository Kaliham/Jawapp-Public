import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePointScreen extends StatefulWidget {
  @override
  _HomePointScreenState createState() => _HomePointScreenState();
}

class _HomePointScreenState extends State<HomePointScreen> {
  GoogleMapController _controller;
  LatLng position;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LatLng>.value(
        value: locators.mapService.homepoint,
        initialData: locators.userService.homepoint ?? Const.amman,
        builder: (context, widget) {
          position = context.watch<LatLng>();
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target:
                          context.watch<LatLng>() ?? position ?? Const.amman,
                      zoom: 14.0,
                    ),
                    onMapCreated: (controller) {
                      _controller = controller;
                      Util.changeMapMode(_controller);
                    },
                    markers: {
                      Marker(
                          draggable: true,
                          markerId: MarkerId('Marker'),
                          icon: Const.homepointIcon,
                          position: context.watch<LatLng>() ??
                              position ??
                              Const.amman,
                          onDragEnd: ((newPosition) {
                            position = newPosition;
                          })),
                    }),
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    width: 40,
                    height: 50,
                    alignment: Alignment.topLeft,
                    child: MaterialButton(
                      onPressed: exit,
                      child: Center(child: Icon(Icons.arrow_back_ios)),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 80,
                        alignment: Alignment.center,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          minWidth: 200,
                          height: 40,
                          color: Const.accent,
                          child: Text(
                            "حفظ!",
                            style: Const.defaultTextStyle.merge(
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          onPressed: save,
                        ),
                      ),
                      // SizedBox(
                      //   height: 80,
                      // )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void save() async {
    if (position == locators.userService.homepoint) {
      return;
    }
    bool save = false;
    await showDialog(context: context, builder: (context) => _SaveAlert())
        .then((value) {
      print(value);
      save = value;
    });
    if (save) {
      // Navigator.pop(context);
      locators.databaseService.updateHomePoint(position);
    }
  }

  void exit() {
    if (position == locators.userService.homepoint) {
      Navigator.pop(context);
      return;
    }

    showDialog(context: context, builder: (context) => _ExitAlert())
        .then((value) {
      print(value);
      if (value) {
        Navigator.pop(context);
      }
    });
  }

  void updateData() async {}
}

class _ExitAlert extends StatelessWidget {
  String get title => "خروج";
  String get content => "هل أنت متأكد أنك تريد الخروج دون حفظ!";
  String get accept => "نعم";
  String get cancel => "إلغاء";

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(cancel),
            onPressed: () => _cancel(context),
          ),
          CupertinoDialogAction(
            child: Text(
              accept,
              style: TextStyle(color: Const.red),
            ),
            onPressed: () => _accept(context),
          )
        ],
      );
    }
    return AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(cancel),
          onPressed: () => _cancel(context),
        ),
        FlatButton(
          child: Text(
            accept,
            style: TextStyle(color: Const.red),
          ),
          onPressed: () => _accept(context),
        )
      ],
    );
  }

  bool _cancel(context) {
    Navigator.of(context).pop(false);
    return false;
  }

  bool _accept(context) {
    Navigator.of(context).pop(true);
    return true;
    // locators.authService.signOutGoogle();
  }
}

class _SaveAlert extends StatelessWidget {
  String get title => "حفظ";
  String get content => "هل تريد حفظ الموقع الجديد؟";
  String get accept => "نعم";
  String get cancel => "إلغاء";
  Widget get acceptWidget => Text(
        accept,
        style: TextStyle(color: Const.accent, fontWeight: FontWeight.w600),
      );
  Widget get cancelWidget => Text(
        cancel,
        style: TextStyle(color: Const.grey),
      );

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: acceptWidget,
            onPressed: () => _accept(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: cancelWidget,
            onPressed: () => _cancel(context),
          ),
        ],
      );
    }
    return AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        FlatButton(
          child: acceptWidget,
          onPressed: () => _accept(context),
        ),
        FlatButton(
          child: cancelWidget,
          onPressed: () => _cancel(context),
        ),
      ],
    );
  }

  bool _cancel(context) {
    Navigator.of(context).pop(false);
    return false;
  }

  bool _accept(context) {
    Navigator.of(context).pop(true);
    return true;
    // locators.authService.signOutGoogle();
  }
}
