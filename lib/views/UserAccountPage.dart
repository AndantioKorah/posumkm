// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:posumkm/views/BaseLayoutPage.dart';
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
            color: Colors.white,
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

class TopWidgetUserAccount extends StatefulWidget {
  const TopWidgetUserAccount({super.key});

  @override
  State<TopWidgetUserAccount> createState() => _TopWidgetUserAccountState();
}

class _TopWidgetUserAccountState extends State<TopWidgetUserAccount> {
  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
          width: double.infinity,
          height: sizeScreen.height * .3,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Container(
            width: double.infinity,
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage("assets/images/logo-default-merchant.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.3),
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ContentTopWidget(),
                ),
              ),
            ),
          )),
    );
  }
}

class ContentTopWidget extends StatefulWidget {
  const ContentTopWidget({super.key});

  @override
  State<ContentTopWidget> createState() => _ContentTopWidgetState();
}

class _ContentTopWidgetState extends State<ContentTopWidget> {
  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;

    return FutureBuilder(
      future: loadUserLoggedIn(),
      builder: (context, _) => Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontFamily: 'PT-Sans',
              ),
              child: Text(userLoggedIn?.nama_user ?? 'PROGRAMMER'),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                // fontFamily: 'PT-Sans',
              ),
              child: Text(userLoggedIn?.nama_role ?? 'PROGRAMMER'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: AssetImage("assets/images/logo-default-merchant.jpg"),
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
              height: 10,
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontFamily: 'PT-Sans',
              ),
              child: Text(userLoggedIn?.nama_merchant ?? 'PROGRAMMER'),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                // fontFamily: 'PT-Sans',
              ),
              child: Text(userLoggedIn?.alamat ?? 'PROGRAMMER'),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                // fontFamily: 'PT-Sans',
              ),
              child: Text('Expire Date: 18 Januari 2024'),
            ),
          ]),
    );
  }
}
