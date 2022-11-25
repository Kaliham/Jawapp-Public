import 'dart:io';

import 'package:app/view/screens/home_point_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/services/util.dart';
import 'package:app/view/auth_wrapper.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(locators.userService.userData.nationalID);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Const.grey),
        elevation: 0,
        centerTitle: true,
        title: Text("إعدادات",
            style: Const.helveticaTitle.merge(TextStyle(fontSize: 34))),
        actions: [
          _LogoutButton(),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            _EmailCard(),
            _Divider(),
            _PasswordCard(),
            _Divider(),
            _NationalIDCard(),
            _Divider(),
            _LanguageCard(),
            _Divider(),
            _HomepointCard(),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Widget rightChild, field;
  _SettingsCard({
    this.title,
    this.icon,
    this.value,
    this.rightChild,
    this.field,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Icon(icon),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Const.defaultTextStyle
                      .merge(TextStyle(fontWeight: FontWeight.w500)),
                ),
                (field != null)
                    ? field
                    : Text(
                        value,
                        style: Const.defaultTextStyle.merge(TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Const.lightGrey,
                        )),
                      ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: rightChild,
          )
        ],
      ),
    );
  }
}

class _EmailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      icon: Icons.email,
      title: "البريد الإلكتروني:",
      value: FirebaseAuth.instance.currentUser.email,
      rightChild: Builder(
        builder: (context) {
          if (!locators.userService.isVerified)
            return InkWell(
              child: Text(
                "ثبت",
                style: Const.defaultTextStyle.apply(color: Const.accent),
              ),
              onTap: onTap,
            );
          return Container();
        },
      ),
    );
  }

  void onTap() {
    locators.authService.verifyEmail();
    Util.showToast("تم إرسال رابط التحقق إلى بريدك الإلكتروني!");
  }
}

class _HomepointCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      icon: Icons.map,
      title: "موقع المنزل: ",
      field: InkWell(
        child: Text(
          "تغيير موقع المنزل > ",
          textAlign: TextAlign.center,
        ),
        onTap: () => onTap(context),
      ),
      rightChild: Container(),
    );
  }

  void onTap(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePointScreen()));
  }
}

class _PasswordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      icon: Icons.lock,
      title: "كلمه السر:",
      value: "************",
      rightChild: InkWell(
        child: Text(
          "إعادة تعيين كلمة المرور",
          style: Const.defaultTextStyle.apply(color: Const.accent),
        ),
        onTap: onTap,
      ),
    );
  }

  void onTap() {
    locators.authService.resetPassword(FirebaseAuth.instance.currentUser.email);
    Util.showToast(
        "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني!");
  }
}

class _NationalIDCard extends StatelessWidget {
  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      icon: Icons.perm_identity,
      title: "الرقم الوطني:",
      rightChild: InkWell(
        child: Text(
          "تغيير ID",
          style: Const.defaultTextStyle.apply(color: Const.accent),
        ),
        onTap: onTap,
      ),
      field: Builder(builder: (context) {
        if (locators.userService.nationalId != null) {
          textController.value =
              TextEditingValue(text: locators.userService.nationalId);
        }
        return TextField(
          controller: textController,
          style: Const.defaultTextStyle,
          cursorColor: Const.grey,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: Const.defaultTextStyle.apply(color: Const.lightGrey),
          ),
        );
      }),
    );
  }

  void onTap() {
    String newValue = textController.value.text;
    locators.databaseService.updateNationalId(newValue);
    Util.showToast("تم تغيير الهوية بنجاح!");
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 2,
      color: Const.lightGrey,
    );
  }
}

class _LanguageCard extends StatefulWidget {
  @override
  __LanguageCardState createState() => __LanguageCardState();
}

class __LanguageCardState extends State<_LanguageCard> {
  Locale locale = locators.userService.lang;
  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      icon: Icons.language,
      title: "اللغة:",
      rightChild: Container(),
      field: DropdownButton(
        items: [
          DropdownMenuItem(
            child: Text("العربية "),
            value: Locale('ar'),
            onTap: () {},
          ),
          DropdownMenuItem(
            child: Text("English"),
            value: Locale('en'),
            onTap: () {},
          ),
        ],
        onChanged: (Locale value) async {
          updateValue(value);
          setState(() {
            locale = value;
          });
        },
        value: (locale ?? Locale('ar')),
      ),
    );
  }

  void updateValue(Locale value) {
    locators.databaseService.updateLang(value.languageCode);
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text(
          "تسجيل خروج",
          style: Const.defaultTextStyle
              .merge(TextStyle(color: Const.red, fontWeight: FontWeight.w600)),
        ),
        onPressed: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => _LogoutAlert(),
          );
        },
      ),
    );
  }
}

class _LogoutAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: new Text("تسجيل خروج"),
        content: new Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("إلغاء"),
            onPressed: () => _cancel(context),
          ),
          CupertinoDialogAction(
            child: Text(
              "تسجيل خروج",
              style: TextStyle(color: Const.red),
            ),
            onPressed: () => _logout(context),
          )
        ],
      );
    }
    return AlertDialog(
      title: new Text("تسجيل خروج"),
      content: new Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
      actions: <Widget>[
        FlatButton(
          child: Text("إلغاء"),
          onPressed: () => _cancel(context),
        ),
        FlatButton(
          child: Text(
            "تسجيل خروج",
            style: TextStyle(color: Const.red),
          ),
          onPressed: () => _logout(context),
        )
      ],
    );
  }

  void _cancel(context) {
    Navigator.of(context).pop();
  }

  void _logout(context) {
    int count = 0;
    Navigator.of(context).pop();
    locators.authService.signOut();
    // locators.authService.signOutGoogle();
  }
}
