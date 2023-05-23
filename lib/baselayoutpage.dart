// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/homepage.dart';
import 'package:posumkm/transactionpage.dart';
import 'package:posumkm/useraccaountpage.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

class BaseLayoutPage extends StatefulWidget {
  const BaseLayoutPage({Key? key}) : super(key: key);

  @override
  State<BaseLayoutPage> createState() => _BaseLayoutPageState();
}

class _BaseLayoutPageState extends State<BaseLayoutPage> {
  var selectedPage = 0;
  List<Widget> listWidget = [];

  _changeStatePage(int selectedIndex) {
    setState(() {
      selectedPage = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    switch (selectedPage) {
      case 0:
        listWidget = [TopWidget(), HomePage()];
        break;
      case 1:
        listWidget = [TransactionPage()];
        break;
      case 2:
        listWidget = [UserAccountPage()];
        break;
      default:
        throw UnimplementedError();
    }

    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 227, 227, 227),
        // backgroundColor: Colors.grey[500],
        bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          buttonBackgroundColor: theme.colorScheme.onPrimaryContainer,
          color: theme.colorScheme.onPrimaryContainer,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          index: selectedPage,
          onTap: _changeStatePage,
          items: const <Widget>[
            Icon(
              Icons.home,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.cashRegister,
              size: 20,
              color: Colors.white,
            ),
            Icon(
              FontAwesomeIcons.user,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                theme.colorScheme.onPrimaryContainer,
                Color.fromRGBO(68, 80, 131, 1),
                // theme.colorScheme.onPrimaryContainer,
                // Color.fromRGBO(47, 56, 92, 1)
              ],
            ),
          ),
          child: Column(children: listWidget),
        ));
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        // margin: EdgeInsets.symmetric(vertical: 20),
        // decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[300],
                fontWeight: FontWeight.w400,
                // fontFamily: 'Rubik-Black'
              ),
              child: Text("Welcome,"),
            ),
            DefaultTextStyle(
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PT-Sans'),
              child: Text("Andantio Korah"),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: CardContentWidget(),
            )
          ],
        ));
  }
}

class CardContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: AssetImage("assets/images/default-merchant.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontFamily: 'PT-Sans',
              ),
              child: Text("NiKita Project"),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                // fontFamily: 'PT-Sans',
              ),
              child: Text("Jalan Melati No. 26"),
            ),
          ],
        )
      ],
    );
  }
}
