import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/model/tags.dart';
import 'package:app/view/components/generics/circle.dart';

class TagsStrip extends StatelessWidget {
  final List<TagInfo> tagModel;
  TagsStrip({this.tagModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      child: ListView.builder(
        itemCount: (tagModel ?? []).length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Tag(
            color: tagModel[index].color,
            tagName: tagModel[index].title,
            onTap: tagModel[index].onTap,
          );
        },
      ),
    );
  }

  Widget temp(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Tag(
            color: Colors.amber,
            tagName: "Name",
          ),
          Tag(
            tagName: "hi",
          ),
          Tag(
            color: Colors.deepOrange,
            tagName: "Apparetment",
          )
        ],
      ),
    );
  }
}

class Tag extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  final String tagName;
  final double size;
  Function onTap;

  Tag({
    this.onTap,
    Key key,
    this.color = Colors.transparent,
    this.tagName = "",
    this.size = 16,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool get isVisible => widget.color != Colors.transparent;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decorateTag(),
      margin: EdgeInsets.fromLTRB(8, 4, 2, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlatButton(
          onPressed: () {
                setState(() {
                  selected = !selected;
                });
                widget.onTap();
              } ??
              () {},
          child: Row(
            children: [
              Visibility(
                visible: isVisible,
                child: Row(
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    CircleContainer(
                      color: widget.color,
                      size: widget.size,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Text(
                  widget.tagName,
                  style: Const.defaultTextStyle.merge(
                    TextStyle(
                        color: (selected) ? Colors.white : Const.accent,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: SizedBox(
                  width: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decorateTag() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: (selected) ? Colors.blue[200] : widget.backgroundColor,
      boxShadow: [
        Const.basicBoxShadow,
      ],
    );
  }
}
