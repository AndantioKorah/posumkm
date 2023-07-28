import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/UserModel.dart';
import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static UserModel? userModel;
  static Future<HttpResponseModel> loginFunction(
      String username, String password) async {
    var req = await http
        .post(Uri.parse("${AppConstants.apiBaseUrl}user/login"), body: {
      "username": username,
      "password": password,
      "device_id": deviceData['deviceId']
    });
    
    try {
      var res = json.decode(req.body);
      if (res['code'] == 200 && res['data'] != null) {
        userModel = UserModel.fromJson(res['data']);
      }
      return HttpResponseModel(
          code: res['code'], message: res['message'], data: userModel);
    } catch (e) {
      return HttpResponseModel(
          code: 500, message: "Terjadi Kesalahan \n $e", data: null);
    }
  }

  static Future<HttpResponseModel> logoutWs(
      String username, String password) async {
    var req = await http
        .post(Uri.parse("${AppConstants.apiBaseUrl}user/logout"), body: {
      "username": username,
      "password": password,
    });

    try {
      var res = json.decode(req.body);
      if (res['code'] == 200 && res['data'] != null) {
        userModel = UserModel.fromJson(res['data']);
      }
      return HttpResponseModel(
          code: res['code'], message: res['message'], data: userModel);
    } catch (e) {
      return HttpResponseModel(
          code: 500, message: "Terjadi Kesalahan \n $e", data: null);
    }
  }

  static Future<HttpResponseModel> changePasswordFunction(String old_password,
      String new_password, String confirm_new_password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "old_password": old_password,
      "new_password": new_password,
      "confirm_new_password": confirm_new_password,
      "password": users.password,
      "username": users.username,
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}user/changePassword"),
        body: body);
    try {
      var res = json.decode(req.body);
      if (res['code'] == 200 && res['data'] != null) {
        users.password = res['data'];
        userModel = users;

        UserPreferences.setUserLoggedIn(users);
      }

      return HttpResponseModel(
          code: res['code'], message: res['message'], data: userModel);
    } catch (e) {
      return HttpResponseModel(
          code: 500, message: "Terjadi Kesalahan \n $e", data: null);
    }
  }

  static Future<HttpResponseModel> getAllMerchantUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id": deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}merchant/users"),
        body: body);
    try {
      var res = json.decode(req.body);
      return HttpResponseModel(
          code: res['code'], message: res['message'], data: res['data']);
    } catch (e) {
      return HttpResponseModel(
          code: 500, message: "Terjadi Kesalahan \n $e", data: null);
    }
  }
}
