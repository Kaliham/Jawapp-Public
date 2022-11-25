import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/screens/mainscreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "حول التطبيق",
          style: Const.helveticaTitle.merge(TextStyle(fontSize: 24)),
        ),
      ),
      body: FutureBuilder<List<String>>(
          future: locators.databaseService.aboutPages,
          builder: (context, snapshot) {
            print(snapshot.data);
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            List<Widget> pages = [];
            snapshot.data.forEach((element) {
              pages.add(Fullweb(element));
              pages.add(Fullweb("https://www.instagram.com"));
            });
            return Container(
              child: Fullweb(snapshot.data[0]),
            );
          }),
    );
  }
}

class Fullweb extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String url;
  Fullweb(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
