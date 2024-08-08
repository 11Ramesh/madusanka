import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:signup_07_19/const/screenSize.dart';

import 'package:signup_07_19/screen/payment/paymentDetails.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/floatingButtons.dart';

class CheckPayment extends StatefulWidget {
  const CheckPayment({super.key});

  @override
  State<CheckPayment> createState() => _CheckPaymentState();
}

class _CheckPaymentState extends State<CheckPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              width: ScreenUtil.screenWidth * 0.8,
              child: Lottie.asset('assets/loties/payment.json'))),
      floatingActionButton: FloatingButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>const PaymentDetails()));
        },
        tooltip: 'Pay',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
