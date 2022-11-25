import 'package:app/services/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/view/components/inputFields/text_input.dart';
import 'package:app/view/components/widgets/anchor_link.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _hidePassword = true;
  String _password = "", _confirm = "", _email = "";
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null && firebaseUser.emailVerified) {
      Navigator.pop(context);
    }
    return Material(
      child: Neumorphic(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 40,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: buildHeader(context),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      buildEmailEntry(context, deviceWidth),
                      SizedBox(
                        height: 20,
                      ),
                      buildPasswordEntry(
                        context,
                        deviceWidth,
                        "كلمة المرور",
                        (value) {
                          _password = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildPasswordEntry(
                        context,
                        deviceWidth,
                        "تأكيد كلمة المرور",
                        (value) {
                          _confirm = value.trim();
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      buildLoginButton(context, deviceWidth),
                      SizedBox(
                        height: 20,
                      ),
                      buildCreatAccount(context),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCreatAccount(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "هل لديك حساب؟  ",
          style: Const.defaultTextStyle,
        ),
        SizedBox(
          width: 20,
        ),
        AnchorLink(
          text: "تسجيل الدخول",
          onTap: () {
            Navigator.pop(context);
          },
          color: Const.accent,
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context, double deviceWidth) {
    return Container(
      margin: EdgeInsets.all(0),
      width: deviceWidth * 0.8,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: RaisedButton(
          color: Const.accent,
          padding: EdgeInsets.all(0),
          child: Text(
            "إنشاء حساب",
            style: Const.defaultTextStyle.merge(TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
          ),
          onPressed: () {
            if (_confirm.trim() == _password.trim()) {
              context
                  .read<AuthService>()
                  .register(email: _email.trim(), password: _password.trim());
              Util.showToast("تم إنشاء الحساب بنجاح!");
              Navigator.pop(context);
            } else {}
          },
        ),
      ),
    );
  }

  Widget buildPasswordEntry(BuildContext context, double deviceWidth,
      String text, Function onChange) {
    return Column(
      children: [
        Container(
          width: deviceWidth * 0.8,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            bottom: 5,
          ),
          child: Text(
            text,
            style: Const.defaultTextStyle,
          ),
        ),
        TextInput(
          onChange: (value) {
            onChange(value);
          },
          textInputType: TextInputType.visiblePassword,
          hint: text,
          obscureText: _hidePassword,
          leftChild: Container(
            margin: EdgeInsets.only(right: 3),
            child: Icon(Icons.lock, color: Const.accent),
          ),
          rightChild: Container(
            child: IconButton(
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
              icon: passwordIcon(),
            ),
          ),
        )
      ],
    );
  }

  Widget passwordIcon() {
    return (_hidePassword)
        ? Icon(
            Icons.visibility_off,
            color: Const.grey,
          )
        : Icon(
            Icons.visibility,
            color: Const.darkBlue,
          );
  }

  Widget buildEmailEntry(BuildContext context, double deviceWidth) {
    return Column(
      children: [
        Container(
          width: deviceWidth * 0.8,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            bottom: 5,
          ),
          child: Text(
            "البريد الإلكتروني",
            style: Const.defaultTextStyle,
          ),
        ),
        TextInput(
          onChange: (value) {
            _email = value.trim();
          },
          leftChild: Container(
            margin: EdgeInsets.only(right: 3),
            child: Icon(
              Icons.email,
              color: Const.accent,
            ),
          ),
          textInputType: TextInputType.emailAddress,
          hint: "البريد الإلكتروني",
          autocorrect: true,
        )
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          "إنشاء حساب",
          style: Const.helveticaTitle.merge(TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w500,
          )),
        ),
      ],
    );
  }
}
