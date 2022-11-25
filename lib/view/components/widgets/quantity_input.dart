import 'package:flutter/material.dart';

import '../../../constants.dart';

class QuantityInput extends StatefulWidget {
  TextEditingController textEditingController;
  int limit;
  QuantityInput({this.textEditingController, this.limit});
  @override
  _QuantityInputState createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Const.lightShadowColor,
          blurRadius: 10,
        ),
      ]),
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(30, 10, 5, 10),
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: widget.textEditingController,
                      onChanged: (value) {
                        if (int.parse(value) > widget.limit) {
                          widget.textEditingController.text =
                              widget.limit.toString();
                        }
                        if (int.parse(value) < 0) {
                          widget.textEditingController.text = "0";
                        }
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          child: FlatButton(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.arrow_drop_up,
                                size: 24,
                              ),
                            ),
                            onPressed: () {
                              int num =
                                  int.parse(widget.textEditingController.text);
                              if (num < widget.limit) {
                                num++;
                                widget.textEditingController.text =
                                    num.toString();
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          child: FlatButton(
                            child: Container(
                              child: Icon(Icons.arrow_drop_down),
                            ),
                            onPressed: () {
                              int num =
                                  int.parse(widget.textEditingController.text);
                              if (num > 0) {
                                num--;
                                widget.textEditingController.text =
                                    num.toString();
                              }
                            },
                          ),
                        ),
                      )
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
}
