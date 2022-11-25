import 'package:app/services/util.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsButton extends StatefulWidget {
  LatLng position;
  DirectionsButton(this.position);
  @override
  _DirectionsButtonState createState() => _DirectionsButtonState();
}

class _DirectionsButtonState extends State<DirectionsButton> {
  LatLng get position => widget.position;
  void locationOnPressed() async {
    await Util.openMap(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0x2f000000),
          blurRadius: 10,
        ),
      ]),
      child: Container(
        width: 200,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
          child: FlatButton(
            color: Color(0xFF6695F0),
            child: Row(
              children: [
                Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                Flexible(
                  child: Center(
                    child: Text(
                      "الاتجاهات",
                      style: Const.defaultTextStyle.merge(
                        TextStyle(color: Colors.white, fontSize: 21),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: locationOnPressed,
          ),
        ),
      ),
    );
  }
}
