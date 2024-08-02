import 'package:flutter/material.dart';

class NoDataLoad extends StatelessWidget {
  NoDataLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/noDataLoad.png',
            height: 200,
            width: 200,
          ),
          Text(
            'No Data Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
