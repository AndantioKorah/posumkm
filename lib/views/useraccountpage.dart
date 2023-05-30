// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:posumkm/controllers/api/UserController.dart';
import 'package:posumkm/views/BaseLayoutPage.dart';
import 'package:posumkm/views/SplashScreenPage.dart';
import 'package:posumkm/views/widget/ChangePasswordWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // height: sizeScreen.height * .5,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
        child: SingleChildScrollView(
          child: Column(
            children:  [
              SizedBox(height: 10,),
              InkWell(
                onTap: () => showChangePasswordDialog(context),
                child: ButtonUserPage(
                  text: "Ganti Password", 
                  icon: Icons.lock_outline_rounded,
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){_showLogoutConfirmationDialog(context);},
                child: ButtonUserPage(
                  text: "Logout", 
                  icon: Icons.output_rounded, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_showLogoutConfirmationDialog(BuildContext context){
  AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.TOPSLIDE,
      title: "KONFIRMASI LOGOUT",
      desc: "Apakah Anda yakin ingin Logout dari aplikasi? ",
      showCloseIcon: true,
      // btnOkText: "Tutup",
      // btnOkColor: Colors.red,
      btnOkOnPress: 
        ()async {
          final preference = await SharedPreferences.getInstance();
          preference.clear();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SplashScreen()));
        },
      btnCancelOnPress: () {},
  ).show();
}

class ButtonUserPage extends StatefulWidget {
  final String text;
  final IconData icon;

  const ButtonUserPage({
    super.key,
    required this.text,
    required this.icon,
    // required this.page
  });

  @override
  State<ButtonUserPage> createState() => ButtonUserPageState();
}

_showRightIcon(){
  
}

class ButtonUserPageState extends State<ButtonUserPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          // SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Stack(
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  Positioned(
                    left: 30,
                    child: Text(widget.text, style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PT-Sans")
                    ),
                  ),
                ],
              ))
            ]
          ),
          SizedBox(height: 5,),
          Container(
            height: .5,
            width: double.infinity,
            color: Colors.grey[350],
            margin: EdgeInsets.only(left: 30),
          ),
        ],
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
          // padding: EdgeInsets.all(),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Container(
            width: double.infinity,
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    color: Colors.black.withOpacity(0.7),
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
      builder: (context, _) => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'PT-Sans',
                ),
                child: Text(userLoggedIn?.nama_user ?? 'PROGRAMMER'),
              ),
              DefaultTextStyle(
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'PT-Sans',
                ),
                child: Text(userLoggedIn?.nama_merchant ?? 'PROGRAMMER'),
              ),
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  // fontFamily: 'PT-Sans',
                ),
                child: Text(userLoggedIn?.alamat ?? 'PROGRAMMER'),
              ),
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  // fontFamily: 'PT-Sans',
                ),
                child: Text('Expire Date: 18 Januari 2024'),
              ),
            ]),
      ),
    );
  }
}
