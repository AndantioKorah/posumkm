// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:posumkm/views/SplashScreenPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: TextButton(
            child: Text("LOGOUT"),
            onPressed: () async {
              final preference = await SharedPreferences.getInstance();
              preference.clear();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            }),
      ),
    );
  }
}
