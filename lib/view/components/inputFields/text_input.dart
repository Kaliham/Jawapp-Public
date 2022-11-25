import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:app/constants.dart';

class TextInput extends StatelessWidget {
  final TextInputType textInputType;
  final String hint;
  final bool obscureText, autocorrect;
  final Widget rightChild, leftChild;
  final Function onChange;
  BorderRadius get borderRadius => BorderRadius.circular(20);
  TextInput({
    this.onChange,
    this.leftChild,
    this.rightChild,
    this.textInputType = TextInputType.text,
    this.hint = "",
    this.obscureText = false,
    this.autocorrect = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorateContainer(),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Neumorphic(
          style: Const.neustyle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                (leftChild != null) ? leftChild : Container(),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 10,
                  child: TextField(
                    onChanged: onChange,
                    obscureText: obscureText,
                    autocorrect: true,
                    keyboardType: textInputType,
                    style: Const.defaultTextStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: Const.defaultTextStyle,
                    ),
                  ),
                ),
                (rightChild != null) ? rightChild : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration decorateContainer() {
    return BoxDecoration(
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: Const.shadowColor,
          blurRadius: 8,
        ),
      ],
    );
  }
}
