import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/services/util.dart';
import 'package:app/view/components/cards/article_card.dart';
import 'package:app/view/components/generics/generic_card.dart';
import 'package:app/view/screens/searchscreen/article_search_screen.dart';

class ArticlesList extends StatelessWidget {
  final List<dynamic> stream;
  ArticlesList(this.stream);
  var list;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Const.secondBackground,
      width: double.infinity,
      child: buildList(context),
    );
  }

  Widget buildList(BuildContext context) {
    list = stream ?? [];
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: buildListItem,
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    return Util.buildValid(
      data: list[index],
      validChild: ArticleCard(list[index]),
      invalidChild: Container(),
    );
  }
}

// ignore: must_be_immutable
class LimitedArticlesList extends ArticlesList {
  final int limit;
  final String type;
  final bool isArchive;
  final String title;
  LimitedArticlesList(stream, this.limit, this.type,
      {this.isArchive = false, this.title = "مقالات"})
      : super(stream);

  int get itemCount => (list.length < limit) ? list.length + 1 : limit;

  @override
  Widget buildList(BuildContext context) {
    list = stream ?? [];
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: buildItem,
    );
  }

  Widget buildItem(context, index) {
    if ((list.length < 6) ? index == list.length : index == 5) {
      return _MoreCard(
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleSearch(
                isArchive: isArchive,
                textController: new TextEditingController(),
                type: type,
                title: title,
              ),
            ),
          );
        },
      );
    }
    return buildListItem(context, index);
  }
}

class _MoreCard extends StatelessWidget {
  Function cardFunction;
  _MoreCard(this.cardFunction);
  @override
  Widget build(BuildContext context) {
    return GenericCardItem(
      height: 80,
      color: Colors.white,
      leftFlex: 0,
      rightFlex: 1,
      rightChild: Center(
          child: Text(
        "أكثر...",
        style: Const.defaultTextStyle.merge(TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Const.lightGrey,
        )),
      )),
      function: cardFunction,
    );
  }
}
