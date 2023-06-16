import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:posumkm/providers/UserProvider.dart';
import 'package:posumkm/views/SplashScreenPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/UserModel.dart';

UserModel? userLoggedInApps;
var databaseFactory;

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // if(Platform.isWindows || Platform.isLinux){
  //   sqfliteFfiInit();
  // }

  // databaseFactory = databaseFactoryFfi;
  // await _loadUserLoggedIn();
  runApp(const MyApp());
}

Future<void> _loadUserLoggedIn() async {
  final preference = await SharedPreferences.getInstance();
  if (preference.containsKey("userLoggedIn")) {
    userLoggedInApps = UserModel.fromJson(
        json.decode(preference.getString("userLoggedIn").toString()));
  }
  // UserPreferences.getUserLoggedIn().then((value) => userLoggedInApps = value);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'NiKita POS UMKM',
        theme: ThemeData(
          fontFamily: 'Varela-Round',
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(34, 46, 60, 1)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class BaseTextStyle {
  final Color color = Colors.grey;

  static const appBarTitle = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Varela-Round");

  static const gridTextDivider = TextStyle(
      fontSize: 10,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "Poppins");

  static const gridItemText = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const gridTextButton = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const buttonTransaksiHome = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const labelTransaksiHome = TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "Poppins");

  static const ltJpTunai = TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "Poppins");

  static const ltTanggal = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const ltRpLunas = TextStyle(
      fontSize: 12,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Color.fromARGB(255, 67, 255, 58),
      fontWeight: FontWeight.w900,
      fontFamily: "Poppins");

  static const ltRpBelumLunas = TextStyle(
      fontSize: 12,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Color.fromARGB(255, 227, 252, 0),
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const ltListMenu = TextStyle(
      fontSize: 11,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      fontFamily: "Poppins");

  static const ltItemCounts = TextStyle(
      fontSize: 11,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");
}

class LineDividerWidget extends StatelessWidget {
  final Color color;
  final double height;
  // final double padding;

  const LineDividerWidget({
    super.key,
    this.color = Colors.black,
    this.height = 1,
    // this.padding = EdgeInsets.all(10)
  });
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Container(
        width: double.infinity,
        color: color,
      ),
    );
  }
}
