import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/colors.dart';
import 'package:signup_07_19/const/constant.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/screen/home/home.dart';
import 'package:signup_07_19/screen/login/signup.dart';
import 'package:signup_07_19/screen/login/veryfyEamil.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/indicator.dart';
import 'package:signup_07_19/widgets/message.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fogetEmailController = TextEditingController();

  final TextEditingController _passWordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  late SharedPreferences sharedPreferences;
  String ownerId = '';
  late FirebaseBloc firebaseBloc;
  bool ismessageSend = false;
  bool isMoveHome = false;
  bool isUserHasAccount = false;

  @override
  void initState() {
    initializedSharedReference();
    super.initState();
  }

  initializedSharedReference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
    isUserHasAccount = sharedPreferences.getBool('isUserHasAccount') ?? false;
    if (isUserHasAccount) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
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

  checkUsernameAndPassword() async {
    try {
      QuerySnapshot querySnapshot = await firestore.get();
      for (var userId in querySnapshot.docs) {
        if (userId['email'] == _emailController.text &&
            userId['password'] == _passWordController.text &&
            userId['verified'] == true) {
          //owner id store in shared preference
          sharedPreferences.setString('ownerId', userId.id);
          //isUserHasAccount store in shared preference
          sharedPreferences.setBool('isUserHasAccount', true);
          //show message when login to account
          const bottomMessage = BottomMessage(
            fontSize: 18.0,
            text: 'Successfully loggin in',
            backgroundColor: MessageColors.messageBlue,
          );
          bottomMessage.showSnackBar(context);
          //Navigated to login page

          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      }
      homeMovement(false);

      //if enter password and user name is wrong. when display noetification
      const bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'Invalid Email or Password',
        backgroundColor: MessageColors.messageRed,
      );
      bottomMessage.showSnackBar(context);

      ///this part use when back end has any error show message but it not properly work
    } on FirebaseAuthException catch (e) {
      const bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'Unable to connect to the backend. Please try again later.',
        backgroundColor: MessageColors.messageRed,
      );
      bottomMessage.showSnackBar(context);
    }
  }
  //before the home page
  //check if the email is register or not

  isRegisterEmail() async {
    QuerySnapshot querySnapshot = await firestore.get();
    bool emailFound = false;
    Navigator.of(context).pop();

    //move homepage function
    homeMovement(true);

    try {
      for (var userId in querySnapshot.docs) {
        if (userId['email'] == _fogetEmailController.text) {
          emailFound = true;
          break;
        }
      }

      if (emailFound) {
        sendEmailUser(_fogetEmailController.text, 'password');
      } else {
        //move homepage function
        homeMovement(false);
        const bottomMessage = BottomMessage(
          fontSize: 18.0,
          text: 'Your Enter Email is not Registered',
          backgroundColor: MessageColors.messageRed,
        );
        bottomMessage.showSnackBar(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  // this use for send email to user type email. this is for forget password

  Future<String> sendEmailUser(String email, String password) async {
    try {
      //create user for registration
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // send email to user
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        setState(() {
          ismessageSend = true;
        });

        await user.sendEmailVerification();

        const bottomMessage = BottomMessage(
          fontSize: 18.0,
          text: 'verification email sent',
          backgroundColor: MessageColors.messageBlue,
        );
        bottomMessage.showSnackBar(context);
        // send data to bloc
        firebaseBloc.add(EmailPassSendEvent(
            _fogetEmailController.text, _passWordController.text, false));
        // navigation verification page
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VerifyEmail()));

        setState(() {
          ismessageSend = false;
        });
        //move homepage function
        homeMovement(false);

        return 'Verification email sent';
      }
      // when any error occur
    } on FirebaseAuthException catch (e) {
      const bottomMessage = BottomMessage(
        fontSize: 18.0,
        text: 'No internet connection',
        backgroundColor: MessageColors.messageRed,
      );
      bottomMessage.showSnackBar(context);
    }
    return ' ';
  }

  homeMovement(bool move) {
    setState(() {
      isMoveHome = move;
    });
  }

// this is use for type email for get forget password
  void showAlertDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextShow(text: 'Please Enter your Email'),
          content: Form(
            key: _formKey1,
            child: TextInPutField(
                text: 'Enter your Email',
                controller: _fogetEmailController,
                validator: _validateEmail,
                radius: 10),
          ),
          actions: [
            Button(
              text: 'cancel',
              radius: 10,
              onclick: () {
                Navigator.of(context).pop();
              },
            ),
            Button(
              text: 'Ok',
              radius: 10,
              onclick: () {
                if (_formKey1.currentState!.validate()) {
                  _formKey1.currentState!.save();
                  isRegisterEmail();
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMoveHome
        ? Indicator()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextShow(text: 'Login'),
                    TextInPutField(
                      text: 'Email',
                      controller: _emailController,
                      radius: 10,
                      validator: _validateEmail,
                    ),
                    TextInPutField(
                        text: 'Password',
                        controller: _passWordController,
                        radius: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: 'Login',
                          radius: 10,
                          onclick: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // for  circular indicator
                              homeMovement(true);

                              checkUsernameAndPassword();
                            }
                          },
                        ),
                        Button(
                          text: 'Sign Up',
                          radius: 10,
                          onclick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                        ),
                        Button(
                          text: 'Forget Password',
                          radius: 10,
                          onclick: () {
                            showAlertDialogBox(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
