import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/screen/home/sell/sell.dart';
import 'package:signup_07_19/screen/home/allview/allview.dart';
import 'package:signup_07_19/screen/home/spent/spent.dart';
import 'package:signup_07_19/screen/payment/checkpay.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/homePageAppBar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  late SharedPreferences sharedPreferences;
  late FirebaseBloc firebaseBloc;
  String ownerId = ' ';

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool connection = false;
  String formattedDate = DateTime.now().toString().split(' ')[0];
  late String todayDate;
  bool payPayment = false;

  @override
  void initState() {
    initializedSharedReference();
    super.initState();
  }

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  initializedSharedReference() async {
    firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
    sharedPreferences = await SharedPreferences.getInstance();
    ownerId = sharedPreferences.getString('ownerId').toString();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    firebaseBloc.add(HomePageEvent(ownerId, formattedDate));
    checkExpDate();
  }

  Future<void> checkExpDate() async {
    try {
      final response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/Europe/London'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Get only the date part (YYYY-MM-DD) from the 'datetime'
          todayDate = data['datetime'].toString().split('T')[0];
        });

        DocumentSnapshot documentSnapshot = await firestore.doc(ownerId).get();
        Map<String, dynamic> dataMap =
            documentSnapshot.data() as Map<String, dynamic>;

        String expDate = dataMap['expdate'];

        DateTime convertExpDate = DateTime.parse(expDate);
        DateTime convertTodayDate = DateTime.parse(todayDate);

        if (convertExpDate.isAfter(convertTodayDate) ||
            convertExpDate.isAtSameMomentAs(convertTodayDate)) {
          setState(() {
            payPayment = false;
          });
        } else {
          setState(() {
            payPayment = true;
          });
        }
      } else {}
    } catch (e) {
      setState(() {
        todayDate = 'Error: $e';
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
    for (var element in _connectionStatus) {
      if (element != ConnectivityResult.none) {
        connection = true;
      } else {
        connection = false;
      }
    }
  }

  final List<Widget> screens = [Sale(), SalesAdd(), Spent()];

  @override
  Widget build(BuildContext context) {
    return !connection
        ? WillPopScope(
            onWillPop: () async {
              // Close the application
              SystemNavigator.pop();
              return false; // Return false to prevent default behavior
            },
            child: Scaffold(
              body: Center(
                child: Lottie.asset('assets/loties/noInternet.json'),
              ),
            ),
          )
        : payPayment
            ? WillPopScope(
                onWillPop: () async {
                  // Close the application
                  SystemNavigator.pop();
                  return false; // Return false to prevent default behavior
                },
                child: CheckPayment())
            : WillPopScope(
                onWillPop: () async {
                  // Close the application
                  SystemNavigator.pop();
                  return false; // Return false to prevent default behavior
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: HomeAppBar(),
                  body: screens[currentTab],
                  bottomNavigationBar: BottomNavigationBar(
                    onTap: (index) {
                      setState(() {
                        currentTab = index;
                        if (currentTab == 1) {
                          firebaseBloc
                              .add(ProductAddEvent(ownerId, formattedDate));
                        } else if (currentTab == 2) {
                          firebaseBloc
                              .add(SpentAddEvent(ownerId, formattedDate));
                        } else if (currentTab == 0) {
                          firebaseBloc
                              .add(HomePageEvent(ownerId, formattedDate));
                        }
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add),
                        label: 'Add',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.remove),
                        label: 'Spent',
                      ),
                    ],
                    type: BottomNavigationBarType.fixed,
                    currentIndex: currentTab,
                  ),
                ),
              );
  }
}
