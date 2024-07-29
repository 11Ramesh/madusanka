import 'package:flutter/material.dart';

class TextShow extends StatelessWidget {
  TextShow({
    this.fontSize,
    required this.text,
    this.color,
    this.fontWeight,
    this.family,
    this.alignment,
    super.key,
  });

  double? fontSize;
  String text;
  Color? color;
  FontWeight? fontWeight;
  final TextAlign? alignment;

  String? family = 'Montserrat';

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: family,
      ),
      textAlign: alignment,
    );
  }
}
