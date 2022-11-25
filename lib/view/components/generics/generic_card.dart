import 'package:flutter/material.dart';

import 'package:app/constants.dart';

// ignore: must_be_immutable
class GenericCardItem extends StatefulWidget {
  final Widget leftChild, rightChild;
  final int leftFlex, rightFlex;
  final double width, height, borderRadius;
  final Color color;
  final bool hasShadow, noMargin;
  Function function;

  GenericCardItem({
    Key key,
    this.leftChild,
    this.rightChild,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.height = Const.cardHeight,
    this.width = -1,
    this.borderRadius = 20,
    this.color = Const.secondBackground,
    this.function,
    this.hasShadow = true,
    this.noMargin = false,
  }) : super(key: key);

  @override
  _GenericCardItemState createState() => _GenericCardItemState();
}

class _GenericCardItemState extends State<GenericCardItem> {
  double deviceWidth;
  double width, height;

  EdgeInsets get parentMargin =>
      (widget.noMargin) ? EdgeInsets.zero : EdgeInsets.fromLTRB(20, 15, 20, 10);

  @override
  Widget build(BuildContext context) {
    //init functions
    initValues(context);

    // build container/body
    return Container(
      margin: parentMargin,
      decoration: decorateParentContainer(),
      child: ClipRRect(
        // cards border widget
        borderRadius: BorderRadius.circular(widget.borderRadius),
        //parent container (contains everything)
        child: Container(
          /*
          parent container styling 
          */
          // this padding needs to be zero for the image to look right
          padding: Const.zeroEdgeInsets,
          //width and height of the container using variables
          width: width,
          height: height,
          // color using constant class
          color: Const.secondBackground,
          //child : builds the content (image , infoContent)
          child: buildContent(context),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      color: widget.color,
      width: double.infinity,
      child: FlatButton(
        highlightColor: Const.lighterGrey,
        focusColor: Const.lightGrey,
        padding: EdgeInsets.all(0),
        onPressed: widget.function,
        child: Row(
          children: [
            Flexible(
              //Image style
              flex: widget.leftFlex,
              fit: FlexFit.tight,
              // image child
              child: Container(
                height: height,
                child: widget.leftChild,
              ),
            ),
            Flexible(
              // this is for the INFO CONTENT
              flex: widget.rightFlex,
              // flexfit is tight; should fit the given space no other behaviour
              fit: FlexFit.tight,
              // image child
              child: Container(
                height: height,
                child: widget.rightChild,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration decorateParentContainer() {
    return BoxDecoration(
      boxShadow: [
        if (widget.hasShadow)
          BoxShadow(
            color: Const.shadowColor,
            blurRadius: 14,
          ),
      ],
    );
  }

  void initValues(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    //check if width and height are set or not and handle the logic (setting it to default)
    width =
        (widget.width > 0) ? widget.width : deviceWidth * Const.widthAspect1;
    height = widget.height;
  }
}
