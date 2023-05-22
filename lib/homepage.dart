// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 3))
    //     .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 227, 227, 227),
        backgroundColor: Colors.grey[500],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          buttonBackgroundColor: theme.colorScheme.onPrimaryContainer,
          color: theme.colorScheme.onPrimaryContainer,
          animationCurve: Curves.linear,
          animationDuration: Duration(milliseconds: 300),
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
          onTap: (index) {
            //Handle button tap
          },
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
          child: Column(children: [
            TopWidget(),
            BodyWidget(),
          ]),
        ));
  }
}

class BottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: sizeScreen.height * 0.1,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 3,
            blurRadius: 10,
            // offset: Offset(5, 5)
          )
        ],
        color: Color.fromRGBO(37, 48, 97, 1),
        // gradient: LinearGradient(
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   colors: [
        //     theme.colorScheme.onPrimaryContainer,
        //     Color.fromRGBO(68, 80, 131, 1),
        //     // theme.colorScheme.onPrimaryContainer,
        //     // Color.fromRGBO(47, 56, 92, 1)
        //   ],
        // ),
      ),
      child: Container(),
    );
  }
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      ),
    );
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
                  fontSize: 30,
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
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontFamily: 'PT-Sans',
              ),
              child: Text("NiKita Project"),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 15,
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
