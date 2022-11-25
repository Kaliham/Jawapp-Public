import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  final double size;
  final Color color;
  const CircleContainer({this.size = 16, this.color = Colors.transparent});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: decorateContainer(),
    );
  }

  BoxDecoration decorateContainer() {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    );
  }
}
