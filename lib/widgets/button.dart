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
    super.key,
  });

  double? fontSize;
  String text;
  VoidCallback? onclick;
  IconData? icon;
  Color? backgroundColor = Colors.white;
  Color? foregroundColor = Colors.black;
  double radius = 50;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onclick,
      child: Text(
        text,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              radius), // Optional: Change the border radius
        ),
      ),
    );
  }
}
