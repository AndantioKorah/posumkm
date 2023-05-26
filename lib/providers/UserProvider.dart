import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
// import 'package:posumkm/models/UserModel.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;

  void loginFunction(String username, String password) async {

    var req = await http.post(
      Uri.parse("${AppConstants.apiBaseUrl}user/login"),
      body: {
        "username": username,
        "password": password,
      }
    );

    _data = json.decode(req.body);
    notifyListeners();
  }
}