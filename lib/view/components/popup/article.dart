import 'dart:async';

import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePopupView extends StatelessWidget {
  String url = "https://jawapp-jo.web.app/test.html";
  String title;
  ArticlePopupView(this.url, {this.title = "مقالة"});
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        title: Text(title,
            style: Const.helveticaTitle.merge(TextStyle(fontSize: 24))),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
