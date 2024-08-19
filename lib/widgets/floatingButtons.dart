import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String tooltip;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;
  final double? fontSize;

  FloatingButton({
    Key? key,
    required this.onPressed,
    this.icon,
    required this.tooltip,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.size = 56.0, // Default size for FloatingActionButton
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Text(
          tooltip,
          style: TextStyle(fontSize: fontSize),
        ),
        backgroundColor: backgroundColor,
        tooltip: tooltip,
      ),
    );
  }
}
