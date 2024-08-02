import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final double? fontSize;
  final String text;
  final VoidCallback? onClick;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double radius;

  const AddButton({
    Key? key,
    this.fontSize,
    required this.text,
    this.onClick,
    this.icon,
    this.backgroundColor = const Color(0xFF6200EE),
    this.foregroundColor = Colors.white,
    this.radius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: [backgroundColor, backgroundColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(3, 3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: Offset(-3, -3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, size: fontSize, color: foregroundColor),
              if (icon != null) SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
