import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posumkm/views/widget/ToastDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/api/UserController.dart';
import '../BaseLayoutPage.dart';
import '../SplashScreenPage.dart';

void redirectLogout(BuildContext context, String message) async {
  await UserController.logoutWs(userLoggedIn!.username, userLoggedIn!.password);
  final preference = await SharedPreferences.getInstance();
  preference.clear();

  if(message != ""){
    // ignore: use_build_context_synchronously
    ToastDialog(
      context: context,
      message: message,
      icon: Icons.cancel_rounded,
      color: Colors.red,
      gravity: ToastGravity.BOTTOM
    ).showDialog();
  }

  // ignore: use_build_context_synchronously
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const SplashScreen()));
}