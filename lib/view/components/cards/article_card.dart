import 'package:app/view/components/popup/article.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/article.dart';
import 'package:app/view/components/generics/generic_card.dart';
import 'package:app/view/components/popup/volunteer_popup.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  static const Article defaultArticle = Article(
    title: "no title",
    date: "no date",
    imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Blank-document-broken.svg/1024px-Blank-document-broken.svg.png",
    article: "",
  );

  ArticleCard([this.article = defaultArticle]);
  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  double width, height;
  Article get article => widget.article;
  @override
  Widget build(BuildContext context) {
    init(context);
    return Container(
      child: GenericCardItem(
        width: width,
        height: height,
        leftFlex: 3,
        rightFlex: 5,
        leftChild: buildLeft(context),
        rightChild: buildRight(context),
        color: Const.backgroundColor,
        function: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticlePopupView(article.articleUrl),
              ));
        },
      ),
    );
  }

  Widget buildLeft(BuildContext context) {
    return Container(
      child: Image.network(
        article.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildRight(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              article.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: styleTitle(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 3, 10, 10),
            alignment: Alignment.bottomRight,
            child: Text(
              article.date,
              style: styleDate(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle styleTitle() {
    return Const.helveticaTitle.apply(
      color: Const.lightGrey,
    );
  }

  TextStyle styleDate() {
    return Const.helvetica.apply(
      color: Const.accent,
    );
  }

  void init(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = Const.articleCardHeight;
    width = size.width * Const.widthAspect2;
  }
}

mixin articleCardTester {
  Widget testArticleCard() {
    Article article = new Article(
      title:
          "Going outside in current situation Going outside in current situation Going outside in current situation",
      date: "07/Apr",
      imageUrl:
          "https://images.homedepot-static.com/productImages/7d8b7f2f-58a8-4e74-aea7-579134200e61/svn/blue-machimpex-disposable-respirators-dm587507-64_1000.jpg",
      article:
          "https://www.ucsf.edu/news/2020/06/417906/still-confused-about-masks-heres-science-behind-how-face-masks-prevent",
    );
    return ArticleCard(article);
  }
}
