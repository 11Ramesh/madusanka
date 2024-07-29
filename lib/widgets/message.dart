import 'package:flutter/material.dart';

@immutable
class BottomMessage extends StatelessWidget {
  const BottomMessage({
    this.fontSize,
    required this.text,
    this.backgroundColor = Colors.black,
    super.key,
  });

  final double? fontSize;
  final String text;
  final Color backgroundColor;
  

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You would call showSnackBar(context) when needed, not directly in build.
    return Container(); // Return an empty container or another appropriate widget
  }
}
