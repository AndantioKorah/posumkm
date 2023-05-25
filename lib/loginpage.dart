// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:posumkm/baselayoutpage.dart';

import 'functions/api/user.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:posumkm/splashscreen.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 3))
    //     .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Stack(
      children: [
        LoginBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'NiKita POS',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600]!.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(40)),
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              border: InputBorder.none,
                              hintText: 'Username',
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(
                                  FontAwesomeIcons.solidUser,
                                  color: Colors.grey[300],
                                  size: 15,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w400)),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600]!.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(40)),
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              border: InputBorder.none,
                              hintText: 'Password',
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(
                                  FontAwesomeIcons.lock,
                                  color: Colors.grey[300],
                                  size: 15,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w400)),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: sizeScreen.width,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white),
                          // onPressed: () {
                          //     // Navigator.push(context, 
                          //     //   PageTransition(
                          //     //     child: HomePage(), 
                          //     //     type: PageTransitionType.fade
                          //     //     )
                          //     // );

                          //     Navigator.pushReplacement(
                          //       context, MaterialPageRoute(builder: 
                          //       (context) => BaseLayoutPage())
                          //     );
                          // },
                          onPressed: () => loginFunction(),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onPrimaryContainer),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomWidget()
      ],
    );
  }
}

class BottomWidget extends StatelessWidget{
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: Colors.transparent),
            child: Text(
              "Lupa Password?",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400]),
          )),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
              colors: const [Colors.black, Colors.black12],
              begin: Alignment.bottomCenter,
              end: Alignment.center)
          .createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg-login.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken)),
        ),
        child: null /* add child content here */,
      ),
    );
  }
}
