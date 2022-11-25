import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/volunteer.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/components/lists/volunteer_list.dart';
import 'package:app/view/components/inputFields/search_bar.dart';
import 'package:provider/provider.dart';

class VolunteerSearchScreen extends StatefulWidget {
  TextEditingController textController;
  String title;
  VolunteerSearchScreen(
      {TextEditingController textController, this.title = "عمل تطوعي"}) {
    this.textController =
        (textController != null) ? textController : new TextEditingController();
  }
  @override
  _VolunteerSearchScreenState createState() => _VolunteerSearchScreenState();
}

class _VolunteerSearchScreenState extends State<VolunteerSearchScreen> {
  @override
  Widget build(BuildContext context) {
    String searchValue = widget.textController.text;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title,
            style: Const.helveticaTitle.merge(TextStyle(fontSize: 24))),
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
            StreamProvider<List<SearchVolunteer>>.value(
              value: locators.databaseService.searchVolunteerStream(
                searchValue,
              ),
              catchError: (context, error) {},
              builder: (context, child) => Expanded(
                child: SearchVolunteerList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
