import 'package:flutter/material.dart';
import 'package:signup_07_19/screen/home/home.dart';
import 'package:signup_07_19/screen/login/login.dart';
import 'package:signup_07_19/widgets/textShow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Animation duration (2 seconds)
    );

    // Define the type of animation
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut, // Smooth transition curve
    );

    // Start the animation
    _controller?.forward();

    // Navigate to home after the animation completes
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(223, 29, 17, 253),
              Colors.blue,
            ], // Background gradient colors
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers the content vertically
            children: [
              FadeTransition(
                opacity: _animation!,
                child: const Text(
                  'DMS',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      20), // Space between text and CircularProgressIndicator
              const SpinKitCircle(
                color: Colors.blue,
                //size: 150.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
