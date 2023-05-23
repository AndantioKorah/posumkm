// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:posumkm/loginpage.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    
    // Navigator.push(context, PageTransition(child: LoginPage(), type: PageTransitionType.fade));
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    // var theme = Theme.of(context);

    return Stack(
      children: [
        SplashBackground(),
        BottomText(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: sizeScreen.width,
            height: sizeScreen.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Image(
                  // image: AssetImage("assets/images/logo-pos-white-navy.png"),
                  image: AssetImage("assets/images/logo-pos-navy-white.png"),
                  width: sizeScreen.width * 0.4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BottomText extends StatelessWidget{
  const BottomText({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // var sizeScreen = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.primaryContainer,
            fontWeight: FontWeight.bold
          ),
          child: Text("Make It Simple."),
        ),
        SizedBox( height: 15, ),
        SpinKitFadingFour(
          color: theme.colorScheme.primaryContainer,
          size: 25,
        ),
        SizedBox(height: 50,)
      ],
    );
  }

}

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(47, 56, 92, 1),
              theme.colorScheme.onPrimaryContainer,
              Color.fromRGBO(47, 56, 92, 1)
            ],
          )
        ),
      );
  }
}
