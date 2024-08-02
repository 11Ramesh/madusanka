import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/screen/home/sell/sell.dart';
import 'package:signup_07_19/screen/home/allview/allview.dart';
import 'package:signup_07_19/screen/home/spent/spent.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/homePageAppBar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

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
        ? const Scaffold(
            body: Center(
                child: Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20),
            )),
          )
        : Scaffold(
            appBar: HomeAppBar(),
            body: screens[currentTab],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                setState(() {
                  currentTab = index;
                  if (currentTab == 1) {
                    firebaseBloc.add(ProductAddEvent(ownerId, formattedDate));
                  } else if (currentTab == 2) {
                    firebaseBloc.add(SpentAddEvent(ownerId, formattedDate));
                  } else if (currentTab == 0) {
                    firebaseBloc.add(HomePageEvent(ownerId, formattedDate));
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
          );
  }
}
