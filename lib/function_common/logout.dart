import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/screen/login/login.dart';

void showLogoutConfirmationDialog(BuildContext context) {
  late SharedPreferences sharedPreferences;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Log Out'),
            onPressed: () async {
              sharedPreferences = await SharedPreferences.getInstance();
              //isUserHasAccount false store in shared preference
              sharedPreferences.setBool('isUserHasAccount', false);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      );
    },
  );
}
