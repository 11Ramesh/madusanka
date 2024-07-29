import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  Indicator({
    this.fontSize,
    super.key,
  });

  double? fontSize;

  String? family = 'Montserrat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
