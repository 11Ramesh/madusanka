import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/screen/login/login.dart';
import 'package:device_preview/device_preview.dart';
import 'package:signup_07_19/screen/payment/checkpay.dart';
import 'package:signup_07_19/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FirebaseBloc(),
        )
      ],
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
