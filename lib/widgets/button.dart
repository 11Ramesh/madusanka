import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({
    this.fontSize,
    required this.text,
    this.onclick,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    required this.radius,
    this.width,
    this.height,
    super.key,
  });

  double? fontSize;
  String text;
  VoidCallback? onclick;
  IconData? icon;
  Color? backgroundColor = Colors.white;
  Color? foregroundColor = Colors.black;
  double radius = 50;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onclick,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                radius), // Optional: Change the border radius
          ),
        ),
      ),
    );
  }
}
