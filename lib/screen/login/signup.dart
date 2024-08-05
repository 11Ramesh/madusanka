import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/colors.dart';
import 'package:signup_07_19/const/constant.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/screen/login/veryfyEamil.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/message.dart';
import 'package:signup_07_19/widgets/processBar.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _comPassWordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FirebaseBloc firebaseBloc;
  late SharedPreferences sharedPreferences;
  bool isMove = false;

  @override
  void initState() {
    //bloc initialized
    firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
    initializedSharedReference();
    super.initState();
  }

  initializedSharedReference() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // email validated
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  // psssword validated
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an PassWord';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final regExp = RegExp(patternPassword);
    if (!regExp.hasMatch(value)) {
      return 'Password must be include a number, a letter, and a special character';
    }
  }

  //Conformpasssword validated
  String? _validateComformPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Conform PassWord';
    }

    if (value != _passWordController.text) {
      _comPassWordController.clear();
      return 'Those passwords didn’t match. Try again.';
    }
  }

  // check before register or not
  isRegisterEmail(String email) async {
    QuerySnapshot querySnapshot = await firestore.get();
    bool emailFound = false;

    try {
      for (var userId in querySnapshot.docs) {
        if (userId['email'] == email) {
          emailFound = true;
          break;
        }
      }
      if (emailFound) {
        homeMovement(false);
        const bottomMessage = BottomMessage(
          fontSize: 18.0,
          text: 'Already use this email before',
          backgroundColor: MessageColors.messageRed,
        );
        return bottomMessage.showSnackBar(context);
      } else {
        return sendEmailUser(_emailController.text, _passWordController.text);
      }
    } catch (e) {
      const bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'No Internet Connection',
        backgroundColor: MessageColors.messageRed,
      );
      return bottomMessage.showSnackBar(context);
    }
  }

  // send message to user
  Future<String> sendEmailUser(String email, String password) async {
    try {
      User? currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }
      //create user for registration
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // send email to user
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        const bottomMessage = BottomMessage(
          fontSize: 18.0,
          text: 'verification email sent',
          backgroundColor: MessageColors.messageBlue,
        );
        bottomMessage.showSnackBar(context);
        // send data to bloc
        firebaseBloc.add(EmailPassSendEvent(
            _emailController.text, _passWordController.text, true));

        homeMovement(false);

        // navigation verification page
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VerifyEmail()));

        return 'Verification email sent';
      }
      homeMovement(false);
    } on FirebaseAuthException catch (e) {
      homeMovement(false);
      final bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'Registation is Failed: ${e.message}',
        backgroundColor: MessageColors.messageRed,
      );
      bottomMessage.showSnackBar(context);
    }
    return 'Registation is Successfully';
  }

  homeMovement(bool move) {
    setState(() {
      isMove = move;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isMove
        ? ProcessBars()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.screenWidth * 0.1,
                  right: ScreenUtil.screenWidth * 0.1),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextShow(
                        text: 'Sign Up',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      //size box for 10% of screen height
                      Heights(height: 0.05),

                      TextInPutField(
                        text: 'Email',
                        controller: _emailController,
                        validator: _validateEmail,
                        radius: 10,
                        prefixIcon: Icons.person,
                      ),
                      //size box for 10% of screen height
                      Heights(height: 0.02),
                      TextInPutField(
                        text: 'Password',
                        controller: _passWordController,
                        validator: _validatePassword,
                        radius: 10,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      //size box for 10% of screen height
                      Heights(height: 0.02),
                      TextInPutField(
                        text: 'ComForm Password',
                        controller: _comPassWordController,
                        validator: _validateComformPassword,
                        radius: 10,
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      //size box for 10% of screen height
                      Heights(height: 0.05),
                      Button(
                        width: ScreenUtil.screenWidth,
                        height: ScreenUtil.screenWidth * 0.12,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        fontSize: 20,
                        text: 'Register',
                        radius: 30,
                        onclick: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            isRegisterEmail(_emailController.text);
                            homeMovement(true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
