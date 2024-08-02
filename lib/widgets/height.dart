import 'package:flutter/material.dart';
import 'package:signup_07_19/const/screenSize.dart';

class Heights extends StatelessWidget {
  Heights({
    required this.height,
    super.key,
  });

  double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.screenHeight * height,
    );
  }
}
