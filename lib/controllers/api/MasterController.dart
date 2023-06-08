import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
import 'package:posumkm/helper/DatabaseHelper.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/UserModel.dart';
import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/DBHelper.dart';
import '../../models/JenisMenuModel.dart';

class MasterController {
  static UserModel? userModel;
  static List<JenisMenuModel> listJenisModel = [];

  static Future<HttpResponseModel> getAllJenisMenu() async {
    try {
      var req = await http
          .post(Uri.parse("${AppConstants.apiBaseUrl}master/menu/jenis"), body: {
        "username": userLoggedInApps?.username,
        "password": userLoggedInApps?.password,
        "id_m_merchant": userLoggedInApps?.id_m_merchant,
      });

      var res = json.decode(req.body);
      if (res['code'] == 200 && res['data'] != null) {
        listJenisModel = convertToList(res['data']);

        await DBHelper.insertListJenisMenu(listJenisModel);

        // listJenisModel = await DBHelper.getAllJenisMenu();
      }
      return HttpResponseModel(
          code: res['code'], message: res['message'], data: listJenisModel);
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
}
