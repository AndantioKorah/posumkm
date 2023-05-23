// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      ),
    );
  }
}