// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:posumkm/views/transaction/InputTransactionPage.dart';

import '../../main.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Expanded(
      child: Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: InputTransactionPage(),
                    type: PageTransitionType.bottomToTop));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: theme.colorScheme.onPrimaryContainer,
            ),
            child: Icon(
              FontAwesomeIcons.plus,
              color: AppsColor.alternativeWhite,
              size: 20,
            ),
          ),
        ),
        appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.chevron_left_rounded,
          //     size: 30,
          //     color: AppsColor.alternativeWhite,
          //   ),
          //   onPressed: () => Navigator.of(context).pop()),
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          title: const Text("TRANSAKSI", style: BaseTextStyle.appBarTitle),
          // centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: AppsColor.alternativeWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
