import 'package:flutter/material.dart';
import 'package:signup_07_19/const/screenSize.dart';

class TotalShowBox extends StatelessWidget {
  TotalShowBox({
    required this.text,
    super.key,
  });

  String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.centerLeft,
        width: ScreenUtil.screenWidth,
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(126, 158, 158, 158),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(5, 5),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: Offset(-5, -5),
              blurRadius: 15,
            ),
          ],
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Colors.blue.withOpacity(0.8),
          //     Colors.blue.withOpacity(0.6),
          //     Colors.blue.withOpacity(0.4),
          //   ],
          //   stops: [0.1, 0.5, 0.9],
          // ),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 25),
          child: Text(text,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
