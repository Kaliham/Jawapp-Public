import 'package:flutter/material.dart';

class PopUpGeneric extends StatefulWidget {
  final Widget topChild;
  final Widget midChild;
  final Widget botChild;
  final int topFlex, midFlex, botFlex;
  final double widthRatio, heightRatio;

  PopUpGeneric({
    this.botChild,
    this.topChild,
    this.midChild,
    this.topFlex = 1,
    this.midFlex = 6,
    this.botFlex = 2,
    this.widthRatio = 0.9,
    this.heightRatio = 0.4,
  });
  @override
  _PopUpGenericState createState() => _PopUpGenericState();
}

class _PopUpGenericState extends State<PopUpGeneric> {
  Widget get topChild => widget.topChild;
  Widget get midChild => widget.midChild;
  Widget get botChild => widget.botChild;
  int get topFlex => widget.topFlex;
  int get midFlex => widget.midFlex;
  int get botFlex => widget.botFlex;
  double get width => widget.widthRatio * screenWidth;
  double get height => widget.heightRatio * screenHeight;
  double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    init(context);

    return Dialog(
      elevation: 28,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: topFlex,
                  child: topChild,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: midFlex,
                  child: midChild,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: botFlex,
                  child: botChild,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
