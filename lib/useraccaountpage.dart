// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:flutter/material.dart';

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
      ),
    );
  }
}