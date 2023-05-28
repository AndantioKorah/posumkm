import 'package:flutter/material.dart';
import 'package:posumkm/providers/UserProvider.dart';
import 'package:posumkm/views/SplashScreenPage.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'NiKita POS UMKM',
        theme: ThemeData(
          // fontFamily: 'PT-Sans',
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(34, 46, 60, 1)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class BaseTextStyle {
  final Color color = Colors.grey;

  static const gridTextDivider = TextStyle(
      fontSize: 10,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "PT-Sans");

  static const gridItemText = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "PT-Sans");

  static const gridTextButton = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "PT-Sans");

  static const buttonTransaksiHome = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "PT-Sans");

  static const labelTransaksiHome = TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "PT-Sans");

  static const ltJpTunai = TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "PT-Sans");

  static const ltTanggal = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "PT-Sans");

  static const ltRpLunas = TextStyle(
      fontSize: 12,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Color.fromARGB(255, 67, 255, 58),
      fontWeight: FontWeight.w900,
      fontFamily: "PT-Sans");

  static const ltRpBelumLunas = TextStyle(
      fontSize: 12,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Color.fromARGB(255, 227, 252, 0),
      fontWeight: FontWeight.bold,
      fontFamily: "PT-Sans");

  static const ltListMenu = TextStyle(
      fontSize: 11,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      fontFamily: "PT-Sans");

  static const ltItemCounts = TextStyle(
      fontSize: 11,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "PT-Sans");
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
