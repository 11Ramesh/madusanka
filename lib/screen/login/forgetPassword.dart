import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/colors.dart';
import 'package:signup_07_19/const/constant.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/screen/home/home.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/indicator.dart';
import 'package:signup_07_19/widgets/loginProcessBar.dart';
import 'package:signup_07_19/widgets/message.dart';
import 'package:signup_07_19/widgets/processBar.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _passworld = TextEditingController();
  TextEditingController _conformPassworld = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String id = '';
  bool isMoveHome = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    initializedSharedReference();
    super.initState();
  }

  initializedSharedReference() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

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

  //
  String? _validateComformPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Conform PassWord';
    }

    if (value != _passworld.text) {
      _conformPassworld.clear();
      return 'Those passwords didn’t match. Try again.';
    }
  }

  changePassword() async {
    try {
      QuerySnapshot querySnapshot = await firestore.get();

      for (var userId in querySnapshot.docs) {
        if (userId['email'] == email) {
          id = userId.id;
          break;
        }
      }

      await firestore.doc(id).update({'password': _passworld.text});
      //owner id store in shared preference
      await sharedPreferences.setString('ownerId', id);
      //isUserHasAccount store in shared preference
      await sharedPreferences.setBool('isUserHasAccount', true);

      const bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'Change Password Successfully',
        backgroundColor: MessageColors.messageBlue,
      );
      bottomMessage.showSnackBar(context);

      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseBloc, FirebaseState>(
      builder: (context, state) {
        if (state is EmailPassSendState) {
          email = state.email;
        }
        return isMoveHome
            ? LoginProcessBar()
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
                            text: 'Change Password',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          //size box for 10% of screen height
                          Heights(height: 0.05),
                          TextInPutField(
                            text: 'Password',
                            controller: _passworld,
                            radius: 10,
                            validator: _validatePassword,
                            prefixIcon: Icons.lock,
                          ),
                          //size box for 10% of screen height
                          Heights(height: 0.02),
                          TextInPutField(
                            text: 'Conform Passworld',
                            controller: _conformPassworld,
                            radius: 10,
                            validator: _validateComformPassword,
                            prefixIcon: Icons.lock,
                          ),
                          //size box for 10% of screen height
                          Heights(height: 0.05),
                          Button(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              text: 'Change Password',
                              radius: 10,
                              onclick: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    isMoveHome = true;
                                  });
                                  changePassword();
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
