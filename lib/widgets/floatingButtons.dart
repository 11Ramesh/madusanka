import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String tooltip;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  FloatingButton({
    Key? key,
    required this.onPressed,
    this.icon,
    required this.tooltip,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.size = 56.0, // Default size for FloatingActionButton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Text(tooltip),
      backgroundColor: backgroundColor,
      tooltip: tooltip,
    );
  }
}
