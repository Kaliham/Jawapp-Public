import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/view/components/inputFields/text_input.dart';
import 'package:app/view/components/widgets/anchor_link.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email = "";
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
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      buildEmailEntry(context, deviceWidth),
                      SizedBox(
                        height: 20,
                      ),
                      buildResetButton(context, deviceWidth),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "هل لديك حساب؟  ",
          style: Const.defaultTextStyle,
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

  Widget buildResetButton(BuildContext context, double deviceWidth) {
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
            "أرسل رابط إعادة التعيين",
            style: Const.defaultTextStyle.merge(TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
          ),
          onPressed: () async {
            await context.read<AuthService>().resetPassword(_email);
            Navigator.pop(context);
          },
        ),
      ),
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
            "أدخل البريد الإلكتروني:",
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
          "هل نسيت كلمة المرور؟",
          style: Const.helveticaTitle.merge(TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w500,
          )),
        ),
      ],
    );
  }
}
