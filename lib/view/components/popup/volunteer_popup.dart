import 'dart:io';

import 'package:app/model/volunteer.dart';
import 'package:app/services/setup_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/view/components/generics/generic_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerPopup extends StatefulWidget {
  final Volunteer volunteer;
  VolunteerPopup({
    this.volunteer,
  });
  @override
  _VolunteerPopupState createState() => _VolunteerPopupState();
}

class _VolunteerPopupState extends State<VolunteerPopup> {
  String get imgUrl => widget.volunteer.imgUrl;
  String get title => widget.volunteer.title;
  String get content => widget.volunteer.description;
  String get website => widget.volunteer.article;
  String get phone => widget.volunteer.phoneNo;
  String get id => widget.volunteer.id;
  Volunteer get model => widget.volunteer;
  String get buttonText => (model.has) ? "إزالة" : "تطوع";

  void _launchURL() async {
    if (await canLaunch(website)) {
      await launch(website);
    } else {
      throw 'Could not launch $website';
    }
  }

  void callnow() async {
    String tel = 'tel:$phone';
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'call not possible';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: PopUpGeneric(
        widthRatio: 0.9,
        heightRatio: 0.8,
        topFlex: 7,
        midFlex: 11,
        botFlex: 2,
        topChild: buildTopChild(context),
        midChild: buildMidChild(context),
        botChild: buildBotChild(context),
      ),
    );
  }

  Widget buildTopChild(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Hero(
                  tag: id,
                  child: Image.network(
                    imgUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (website != null && website != "")
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        color: Const.accent,
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.link,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: _launchURL,
                        shape: CircleBorder(),
                      ),
                    ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      color: Const.accent,
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: callnow,
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.close,
                color: Colors.grey[900],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildMidChild(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: Const.helveticaTitle.apply(color: Const.accent),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            content,
            style: Const.defaultTextStyle.apply(color: Const.secondartAccent),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildBotChild(BuildContext context) {
    return FlatButton(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          buttonText,
          style: Const.defaultTextStyle.merge(TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          )),
        ),
      ),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) => _Alert(model),
        );
        setState(() {
          model.has = model.has;
        });
      },
      color: (model.has) ? Const.red : Const.accent,
    );
  }
}

class _Alert extends StatelessWidget {
  Volunteer model;
  _Alert(this.model);
  String get title => !model.has ? "تطوع" : "إزالة مهمة";
  String get description => "هل أنت متأكد أنك تريد إزالته؟";
  String get cancel => "إلغاء";
  String get accept => (model.has) ? "إزالة" : "تطوع";
  Color get color => (model.has) ? Const.red : Const.accent;
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(description),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              cancel,
              style: TextStyle(color: Const.grey),
            ),
            onPressed: () => _cancel(context),
          ),
          CupertinoDialogAction(
            child: Text(
              accept,
              style: TextStyle(color: color),
            ),
            onPressed: () => _accept(context),
          )
        ],
      );
    }
    return AlertDialog(
      title: new Text(title),
      content: new Text(description),
      actions: <Widget>[
        FlatButton(
          child: Text(
            cancel,
            style: TextStyle(color: Const.grey),
          ),
          onPressed: () => _cancel(context),
        ),
        FlatButton(
          child: Text(
            accept,
            style: TextStyle(color: color),
          ),
          onPressed: () => _accept(context),
        )
      ],
    );
  }

  void _cancel(context) {
    Navigator.pop(context);
  }

  void _accept(context) {
    if (model.has) {
      locators.databaseService.removeVolunteering(model.id, model.volunteers);
    } else {
      locators.databaseService.addVolunteering(model.id, model.volunteers);
    }
    model.has = !model.has;
    Navigator.pop(context);
  }
}
