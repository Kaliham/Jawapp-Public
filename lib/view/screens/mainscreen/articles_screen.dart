import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/article.dart';
import 'package:app/view/components/cards/article_card.dart';
import 'package:app/view/components/cards/cards.dart';
import 'package:app/view/components/cards/rule_card.dart';
import 'package:app/view/components/lists/articles_list.dart';
import 'package:app/view/components/lists/small_list.dart';
import 'package:app/view/components/lists/volunteer_list.dart';
import 'package:app/view/components/parts/header.dart';
import 'package:app/view/screens/searchscreen/article_search_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ArticlesScreen extends StatefulWidget {
  Color color;
  ArticlesScreen(this.color);
  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen>
    with
        AutomaticKeepAliveClientMixin,
        cardListItemTester,
        articleCardTester,
        ruleCardTester {
  TextEditingController textEditingController = new TextEditingController();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      children: [
        _buildHeader(context),
        SizedBox(
          height: 20,
        ),
        _buildProceduralList(context),
        _buildRecommendationList(context),
        _buildArchiveList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Header(
      title: "مقالات",
      searchFunction: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleSearch(
              textController: textEditingController,
            ),
          ),
        );
      },
      textController: textEditingController,
    );
  }

  Widget _buildProceduralList(BuildContext context) {
    return SmallList(
      title: "مقالات ارشادية",
      child: LimitedArticlesList(
        Provider.of<List<ProceduralArticle>>(context),
        10,
        "مقالات ارشادية",
        title: "مقالات ارشادية",
      ),
    );
  }

  Widget _buildRecommendationList(BuildContext context) {
    return SmallList(
      title: "مقالات معلوماتية",
      child: LimitedArticlesList(
        Provider.of<List<RecommendationArticle>>(context),
        10,
        "مقالات معلوماتية",
        title: "مقالات معلوماتية",
      ),
    );
  }

  Widget _buildArchiveList(BuildContext context) {
    return SmallList(
      title: "أرشيف",
      child: LimitedArticlesList(
        Provider.of<List<ArchivedArticle>>(context),
        10,
        "",
        isArchive: true,
      ),
    );
  }
}
