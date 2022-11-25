import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/article.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/components/lists/articles_list.dart';
import 'package:app/view/components/inputFields/search_bar.dart';
import 'package:provider/provider.dart';

class ArticleSearch extends StatefulWidget {
  TextEditingController textController;
  String type;
  String title;
  bool isArchive;
  ArticleSearch(
      {TextEditingController textController,
      this.type = "",
      this.isArchive = false,
      this.title = "مقالات"}) {
    this.textController =
        (textController != null) ? textController : new TextEditingController();
  }
  @override
  _ArticleSearchState createState() => _ArticleSearchState();
}

class _ArticleSearchState extends State<ArticleSearch> {
  @override
  Widget build(BuildContext context) {
    String searchValue = widget.textController.text;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: Const.helveticaTitle.merge(TextStyle(fontSize: 24)),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            SearchBar(
              searchFunction: () {
                setState(() {
                  searchValue = widget.textController.text.trim();
                });
              },
              textController: widget.textController,
            ),
            SizedBox(height: 10),
            StreamProvider<List<SearchArticle>>.value(
                value: locators.databaseService.searchArticlesStream(
                  widget.type,
                  searchValue,
                  isArchive: widget.isArchive,
                ),
                catchError: (context, error) {},
                builder: (context, child) => Expanded(
                    child: ArticlesList(
                        Provider.of<List<SearchArticle>>(context))))
          ],
        ),
      ),
    );
  }
}
