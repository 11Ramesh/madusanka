import 'package:flutter/material.dart';

class TextsButton extends StatelessWidget {
  TextsButton({
    this.fontSize,
    required this.text,
    required this.onclick,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  double? fontSize;
  String text;
  VoidCallback onclick;
  IconData? icon;
  Color? backgroundColor = Colors.white;
  Color? foregroundColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onclick,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: foregroundColor),
      ),
    );
  }
}
