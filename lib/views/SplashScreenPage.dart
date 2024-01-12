// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:posumkm/main.dart';
import 'package:posumkm/views/BaseLayoutPage.dart';
import 'package:posumkm/views/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences preference = await SharedPreferences.getInstance();
    if (preference.containsKey("userLoggedIn")) {
      // if (userLoggedInApps != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BaseLayoutPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      // Navigator.push(context, PageTransition(child: LoginPage(), type: PageTransitionType.fade));
    }
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
                  image: AssetImage("assets/images/splash-screen-image.png"),
                  width: 500,
                  // height: sizeScreen.height,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BottomText extends StatelessWidget {
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
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold),
          child: Text("Make It Simple."),
        ),
        SizedBox(
          height: 15,
        ),
        SpinKitFadingFour(
          color: theme.colorScheme.onBackground,
          size: 25,
        ),
        SizedBox(
          height: 50,
        )
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
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.onSecondary,
          Color.fromARGB(255, 3, 83, 110),
        ],
      )),
    );
  }
}
