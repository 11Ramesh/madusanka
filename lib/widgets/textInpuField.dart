import 'package:flutter/material.dart';

@immutable
class TextInPutField extends StatelessWidget {
  TextInPutField({
    this.fontSize,
    required this.text,
    required this.controller,
    this.height,
    this.width,
    this.icon,
    this.color,
    required this.radius,
    this.iSprefix,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  double? fontSize;
  String text;
  TextEditingController controller;
  IconData? icon;
  double? width;
  double? height;
  Color? color;
  double radius;
  String? family = 'Montserrat';
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  TextInputType keyboardType;

  bool? iSprefix = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        prefixIcon: Icon(icon),
        iconColor: Colors.black,
        filled: true,
        hintText: text,
        hintStyle: TextStyle(fontFamily: family),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none),
        fillColor: color,
      ),
    );
  }
}
