import 'package:app/services/util.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/view/components/inputFields/text_input.dart';
import 'package:app/view/components/widgets/anchor_link.dart';
import 'package:app/view/screens/accountscreen/forgot_password_screen.dart';
import 'package:app/view/screens/accountscreen/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;
  String _password, _email;
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
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
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      buildEmailEntry(context, deviceWidth),
                      SizedBox(
                        height: 20,
                      ),
                      buildPasswordEntry(context, deviceWidth, "كلمه السر"),
                      SizedBox(
                        height: 40,
                      ),
                      buildLoginButton(context, deviceWidth),
                      SizedBox(
                        height: 20,
                      ),
                      buildGoogleButtom(context, deviceWidth),
                      SizedBox(
                        height: 20,
                      ),
                      buildCreatAccount(context),
                      SizedBox(
                        height: 20,
                      ),
                      AnchorLink(
                        text: "هل نسيت كلمة المرور؟",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
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
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          "ليس لديك حساب؟",
          style: Const.defaultTextStyle,
        ),
        SizedBox(
          width: 20,
        ),
        AnchorLink(
          text: "إنشاء حساب",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen()));
          },
          color: Const.accent,
        ),
      ],
    );
  }

  Widget buildGoogleButtom(BuildContext context, double deviceWidth) {
    return Container(
      height: 50,
      width: deviceWidth * 0.8,
      child: GoogleSignInButton(
        borderRadius: 20,
        onPressed: () {
          context.read<AuthService>().signInGoogle().then(
            (value) {
              Util.showToast(value);
            },
          );
        },
      ),
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
            "تسجيل الدخول",
            style: Const.defaultTextStyle.merge(TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
          ),
          onPressed: () {
            context
                .read<AuthService>()
                .signIn(email: _email, password: _password)
                .then(
              (value) {
                Util.showToast(value);
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildPasswordEntry(
      BuildContext context, double deviceWidth, String text) {
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
            _password = value.trim();
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
      children: [Expanded(child: Image.asset("assets/images/logo.png"))],
    );
  }
}
