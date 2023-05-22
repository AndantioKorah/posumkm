// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:flutter/material.dart';
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
    // var theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      backgroundColor: Colors.grey[100],
      body: Column(children: const [
        // AppBar(),
        TopWidget(),
        BodyWidget(),
        BottomWidget()
      ]),
    );
  }
}

class BodyWidget extends StatelessWidget{
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: sizeScreen.height * 0.53,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            ),
          ),
        )
      ],
    );
  }
}

class BottomWidget extends StatelessWidget{
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: sizeScreen.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.white,
            // image: DecorationImage(
            //   image: AssetImage("assets/images/bg-header-home.png"),
            //   fit: BoxFit.cover,
            // ),
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20),
            //   topRight: Radius.circular(20)
            // ),
          ),
        )
      ],
    );
  }
}

class TopWidget extends StatelessWidget{
  const TopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sizeScreen = MediaQuery.of(context).size;

    return Container(
      height: sizeScreen.height * .40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-header-home.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        // fontFamily: 'PT-Sans'
                      ),
                      child: Text("Welcome,"),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 25,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'PT-Sans',
                      ),
                      child: Text("Andantio Korah"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 190,
            width: sizeScreen.width * 0.9,
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
              // image: DecorationImage(
              //   image: AssetImage("assets/images/bg-header-home.png"),
              //   fit: BoxFit.cover,
              // ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 3,
                  blurRadius: 10,
                  // offset: Offset(5, 5)
                )
              ]
            ),
            padding: EdgeInsets.all(10),
            child: Column(  
              children: [
                SizedBox(width: sizeScreen.width, ),
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
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
                            borderRadius: BorderRadius.all( Radius.circular(90.0)),
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
                                fontFamily: 'PT-Sans',
                              ),
                              child: Text("NiKita Project"),
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'PT-Sans',
                              ),
                              child: Text("Jalan Melati No. 26"),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            width: sizeScreen.width * 0.4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: const [
                                  Color.fromARGB(255, 205, 205, 205),
                                  Color.fromARGB(255, 226, 209, 255),
                                  // theme.colorScheme.onPrimaryContainer,
                                  // Color.fromRGBO(47, 56, 92, 1)
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(3),
                                bottomRight: Radius.circular(3),
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(3)
                              ),
                            ),
                            child: Column(children: [
                              DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PT-Sans',
                                ),
                                child: Text("Hari Ini"),
                              ),
                              DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'PT-Sans',
                                ),
                                child: Text("Rp 158.853.993"),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(width: 20,), 
                        Expanded(
                          child: Container(
                            height: 40,
                            width: sizeScreen.width * 0.4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: const [
                                  Color.fromARGB(255, 205, 205, 205),
                                  Color.fromARGB(255, 226, 209, 255),
                                  // theme.colorScheme.onPrimaryContainer,
                                  // Color.fromRGBO(47, 56, 92, 1)
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(3),
                                bottomRight: Radius.circular(3),
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(3)
                              ),
                            ),
                            child: Column(children: [
                              DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PT-Sans',
                                ),
                                child: Text("Exp. Date"),
                              ),
                              DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  // fontFamily: 'PT-Sans',
                                ),
                                child: Text("31 November 20222"),
                              ),
                            ]),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}