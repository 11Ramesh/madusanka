import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/const/screenSize.dart';

import 'package:signup_07_19/screen/payment/paymentDetails.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/floatingButtons.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class CheckPayment extends StatefulWidget {
  const CheckPayment({super.key});

  @override
  State<CheckPayment> createState() => _CheckPaymentState();
}

class _CheckPaymentState extends State<CheckPayment> {
  late SharedPreferences sharedPreferences;
  String ownerId = ' ';
  String expDate = '';

  @override
  void initState() {
    initializedSharedReference();
    super.initState();
  }

  initializedSharedReference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    ownerId = sharedPreferences.getString('ownerId').toString();

    DocumentSnapshot documentSnapshot = await firestore.doc(ownerId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    setState(() {
      expDate = data['expdate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextShow(
          text: 'Payment Expired',
          fontSize: 30,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        //fit: StackFit.expand,
        children: [
          Heights(height: 0.02),
          Padding(
            padding: EdgeInsets.all(ScreenUtil.screenWidth * 0.03),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextShow(
                text:
                    'Please note that the payment expired on $expDate. Kindly make the payment at your earliest convenience.',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Heights(height: 0.1),
          Align(
              alignment: Alignment.center,
              child: Lottie.asset('assets/loties/payment.json')),
        ],
      ),
      floatingActionButton: FloatingButton(
        size: ScreenUtil.screenWidth * 0.5,
        fontSize: 20,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PaymentDetails()));
        },
        tooltip: 'Pay',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
