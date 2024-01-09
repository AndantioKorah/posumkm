// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:posumkm/controllers/api/UserController.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'BaseLayoutPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final RoundedLoadingButtonController buttonSumbit =
      RoundedLoadingButtonController();

  // @override
  // void initState() {
  //   super.initState();

  //   // Future.delayed(const Duration(seconds: 3))
  //   //     .then((value) => {FlutterNativeSplash.remove()});
  // }
  @override
  Widget build(BuildContext context) {
    userName.text = "testing";
    password.text = "112233";

    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Stack(
      children: [
        // LoginBackground(),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.onPrimaryContainer,
                Color.fromRGBO(39, 50, 112, 1),
                // theme.colorScheme.onPrimaryContainer,
                // Color.fromRGBO(47, 56, 92, 1)
              ],
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: sizeScreen.height * .3,
              ),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 20,
                  color: AppsColor.alternativeWhite,
                  // fontWeight: FontWeight.bold
                ),
                child: Text("Welcome to,"),
              ),
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: 40,
                    color: AppsColor.alternativeWhite,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
                child: Text("NiKita POS"),
              ),
            ]),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          // backgroundColor: theme.colorScheme.onPrimaryContainer,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: sizeScreen.height * .5,
                    decoration: BoxDecoration(
                      // color: theme.colorScheme.onPrimaryContainer,
                      color: Colors.transparent,
                      // image: DecorationImage(
                      //   image: AssetImage("assets/images/login-image.png")
                      // ),
                    ),
                  ),
                  Container(
                    height: sizeScreen.height * .5,
                    decoration: BoxDecoration(
                        color: AppsColor.alternativeWhite,
                        borderRadius: BorderRadius.only(
                            // topLeft: Radius.circular(10),
                            topRight: Radius.circular(50))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 40),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please Login to continue',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sizeScreen.height * .02,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              loginTextField(
                                  context,
                                  userName,
                                  "Username",
                                  TextInputAction.next,
                                  TextInputType.name,
                                  false,
                                  FontAwesomeIcons.solidUser),
                              SizedBox(
                                height: 10,
                              ),
                              loginTextField(
                                  context,
                                  password,
                                  "Password",
                                  TextInputAction.done,
                                  TextInputType.name,
                                  true,
                                  FontAwesomeIcons.key),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: RoundedLoadingButton(
                                  valueColor: AppsColor.alternativeWhite,
                                  animateOnTap: true,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  controller: buttonSumbit,
                                  // onPressed: () {
                                  //   buttonSumbit.reset();
                                  //   print(deviceData['deviceId']);
                                  // },
                                  onPressed: () => UserController.loginFunction(
                                          userName.text, password.text)
                                      .then((value) {
                                    buttonSumbit.reset();
                                    if (value.code == 200) {
                                      UserPreferences.setUserLoggedIn(value.data);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BaseLayoutPage()));
                                    } else {
                                      AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.ERROR,
                                              animType: AnimType.SCALE,
                                              title: "LOGIN ERROR",
                                              desc: value.message,
                                              showCloseIcon: true,
                                              btnOkText: "Tutup",
                                              btnOkColor: Colors.red[900],
                                              btnOkOnPress: () {})
                                          .show();
                                    }
                                  }),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppsColor.alternativeWhite),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // BottomWidget()
      ],
    );
  }
}

Widget loginTextField(
    BuildContext ctx,
    TextEditingController controller,
    String hinText,
    TextInputAction action,
    TextInputType type,
    bool obscureText,
    IconData icon) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
            bottom:
                BorderSide(color: Theme.of(ctx).colorScheme.onPrimaryContainer))
        // border: Border.all(
        //     color: Theme.of(ctx).colorScheme.onPrimaryContainer.withOpacity(.5)
        //   ),
        // borderRadius: BorderRadius.circular(0)
        ),
    child: TextField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hinText,
          prefixIcon: Icon(
            icon,
            color: Theme.of(ctx).colorScheme.onPrimaryContainer,
            size: 15,
          ),
          hintStyle: TextStyle(
              fontSize: 15,
              color:
                  Theme.of(ctx).colorScheme.onPrimaryContainer.withOpacity(.5),
              fontWeight: FontWeight.w400)),
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Theme.of(ctx).colorScheme.onPrimaryContainer,
      ),
      keyboardType: type,
      textInputAction: action,
      controller: controller,
      obscureText: obscureText,
    ),
  );
}

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              child: Text(
                "Lupa Password?",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          )
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
