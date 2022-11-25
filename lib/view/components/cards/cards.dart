import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';

import '../generics/generic_card.dart';

class CardListItem extends StatefulWidget {
  final String title, description, date, id;
  final String imageUrl;
  final List<Color> tagsColor;
  final double borderRadius;
  final Function function;
  const CardListItem({
    Key key,
    this.title = "no title",
    this.description = "no description",
    this.date = "no date",
    this.imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Blank-document-broken.svg/1024px-Blank-document-broken.svg.png",
    this.tagsColor = const [Colors.transparent],
    this.borderRadius = 20,
    this.function,
    this.id,
  }) : super(key: key);
  @override
  _CardListItemState createState() => _CardListItemState();
}

class _CardListItemState extends State<CardListItem> {
  double deviceWidth;
  double width;

  double get height => Const.cardHeight;
  String get title => widget.title;
  String get description => widget.description;
  String get date => widget.date;
  String get imageUrl => widget.imageUrl;
  double get borderRadius => widget.borderRadius;
  TextStyle get textStyle => Const.nunitoTextStyle;

  List<Color> get tagsColor => widget.tagsColor;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GenericCardItem(
        color: Colors.white,
        leftFlex: 1,
        rightFlex: 2,
        leftChild: buildImage(context),
        rightChild: buildInfoContent(context),
        function: widget.function,
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return Container(
      height: height,
      child: Hero(
        tag: widget.id,
        child: Image.network(
          imageUrl,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget buildInfoContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 2, 2, 4),
      child: Column(
        children: [
          Flexible(
            child: Center(child: buildTitle(context)),
          ),
          Flexible(
            child: Center(child: buildDescription(context)),
          ),
          Flexible(
            child: Center(child: buildBottomSection(context)),
          )
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        // style: TextStyle(
        //   color: Const.accent,
        //   fontFamily: ,
        //   fontWeight: FontWeight.w900,
        //   fontSize: 16,
        // ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: textStyle.merge(
          TextStyle(
            fontSize: 18,
            color: Const.accent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildDescription(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        description,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: textStyle.merge(
          TextStyle(
            fontSize: 14,
            color: Const.lightGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /* ================ Bottom Section ==================================== */
  Widget buildBottomSection(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: buildTags(context),
          ),
          Flexible(
            child: buildDate(context),
          )
        ],
      ),
    );
  }

  Widget buildTags(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tagsColor.length,
        itemBuilder: (context, index) {
          return _Tag(context: context, color: tagsColor[index]);
        },
      ),
    );
  }

  Widget buildDate(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 2, 4, 2),
      alignment: Alignment.centerRight,
      child: Text(
        date,
        style: textStyle.merge(
          TextStyle(
            fontSize: 12,
            color: Const.accent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /*===================== Logic/init zone ================================= */
  void init(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    width = deviceWidth * Const.widthAspect1;
  }

  /* ========================== Testing Zone ===================================*/

}

class _Tag extends StatelessWidget {
  const _Tag({
    Key key,
    @required this.context,
    @required this.color,
  }) : super(key: key);

  final BuildContext context;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double size = 16;
    return Container(
      margin: EdgeInsets.all(2),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

mixin cardListItemTester {
  Widget testCardListItem() {
    return CardListItem(
      title: "title",
      description:
          "Help with cooking and Serving volunteers food cooking and Serving volunteers food ",
      date: "23/08 - 03/09",
      imageUrl:
          "https://www.unicef.org/jordan/sites/unicef.org.jordan/files/styles/media_banner/public/2019-02/20180902_JOR_572.jpg?itok=joqNE9tF",
      tagsColor: [Colors.blue, Colors.amber, Colors.cyan],
    );
  }
}
