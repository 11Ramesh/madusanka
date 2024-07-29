import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/colors.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/screen/home/home.dart';
import 'package:signup_07_19/screen/login/forgetPassword.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/message.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailvarified = false;
  Timer? timer;
  late SharedPreferences sharedPreferences;
  String email = '';
  String password = '';
  bool isreg = false;
  

  void initState() {
    checkEmailVerification();
    super.initState();
  }

  void dispose() {
    deleteAuthentication();
    super.dispose();
  }

  // delete user authentication from the firebase authentication when user move to another page
  deleteAuthentication() async {
    timer?.cancel();

    User? user = firebaseAuth.currentUser;

    if (user != null) {
      await user.delete();
    }
  }

  //3 second after 3 second check if user verified thi email
  Future<void> checkEmailVerification() async {
    isEmailvarified = firebaseAuth.currentUser!.emailVerified;

    if (!isEmailvarified) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        movetoHome();
      });
    }
  }

  Future movetoHome() async {
    await firebaseAuth.currentUser!.reload();
    setState(() {
      isEmailvarified = firebaseAuth.currentUser!.emailVerified;
    });
    if (isEmailvarified && isreg == true) {
      timer?.cancel();

      await firestore
          .doc()
          .set({'verified': true, 'email': email, 'password': password});

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else if (isEmailvarified && isreg == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ForgetPassword()));
    }
  }

  // resend  email to user again
  Future<String> reSendEmailUser(String email, String password) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();

        const bottomMessage = BottomMessage(
          fontSize: 18.0,
          text: 'Succesfuly to resend email',
          backgroundColor: MessageColors.messageBlue,
        );
        bottomMessage.showSnackBar(context);
      }
    } catch (e) {
      const bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'Failed to resend email try again after few seconds',
        backgroundColor: MessageColors.messageBlue,
      );
      bottomMessage.showSnackBar(context);

      print('${e.toString()}');
    }
    return 'Verification email resent';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseBloc, FirebaseState>(
      builder: (context, state) {
        if (state is EmailPassSendState) {
          email = state.email;
          password = state.password;
          isreg = state.isreg;

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                children: [
                  const Text('Verification using email'),
                  Button(
                      text: 'resend',
                      radius: 10,
                      onclick: () {
                        reSendEmailUser(email, password);
                      }),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
