import 'package:flutter/material.dart';
// import 'package:posumkm/loginpage.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:posumkm/splashscreen.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NiKita POS UMKM',
      theme: ThemeData(
        // fontFamily: 'PT-Sans',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(34, 46, 60, 1)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class BaseTextStyle{
  Color color = Colors.grey;

  static const gridTextDivider = TextStyle(
    fontSize: 12,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: "PT-Sans"
  );

  static const gridItemText = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: "PT-Sans"
  );
}