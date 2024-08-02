import 'package:flutter/material.dart';
import 'package:signup_07_19/const/screenSize.dart';

class Widths extends StatelessWidget {
  Widths({
    required this.width,
    super.key,
  });

  double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil.screenHeight * width,
    );
  }
}
