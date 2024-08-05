import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:signup_07_19/const/screenSize.dart';

class LoginProcessBar extends StatelessWidget {
  LoginProcessBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.bottomCenter,
          child: const SpinKitPulse(
            color: Colors.blue,
            size: 150.0,
          )),
    );
  }
}
