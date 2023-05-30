import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static UserModel? userModel;
  static Future<HttpResponseModel> loginFunction(
      String username, String password) async {
    var req = await http
        .post(Uri.parse("${AppConstants.apiBaseUrl}user/login"), body: {
      "username": username,
      "password": password,
    });

    var res = json.decode(req.body);
    if (res['code'] == 200 && res['data'] != null) {
      userModel = UserModel.fromJson(res['data']);
      //   userModel = UserModel(
      //       username: res['data']['username'],
      //       password: res['data']['password'],
      //       nama_user: res['data']['nama_user'],
      //       id_m_user: res['data']['id_m_user'],
      //       id_m_role: res['data']['id_m_role'],
      //       id_m_merchant: res['data']['id_m_merchant'],
      //       nama_role: res['data']['nama_role'],
      //       kode_nama_role: res['data']['kode_nama_role'],
      //       nama_merchant: res['data']['nama_merchant'],
      //       alamat: res['data']['alamat'],
      //       logo: res['data']['logo']);
    }

    return HttpResponseModel(
        code: res['code'], message: res['message'], data: userModel);
  }

  static Future<HttpResponseModel> changePasswordFunction(
      String old_password,
      String new_password,
      String confirm_new_password
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "old_password": old_password,
      "new_password": new_password,
      "confirm_new_password": confirm_new_password,
      "password": users.password,
      "username": users.username,
    };

    var req = await http
        .post(Uri.parse("${AppConstants.apiBaseUrl}user/changePassword"), body : body);
    print(body);
    print(req.body);   
    var res = json.decode(req.body);
    if (res['code'] == 200 && res['data'] != null) {
      userModel = UserModel.fromJson(res['data']);
      //   userModel = UserModel(
      //       username: res['data']['username'],
      //       password: res['data']['password'],
      //       nama_user: res['data']['nama_user'],
      //       id_m_user: res['data']['id_m_user'],
      //       id_m_role: res['data']['id_m_role'],
      //       id_m_merchant: res['data']['id_m_merchant'],
      //       nama_role: res['data']['nama_role'],
      //       kode_nama_role: res['data']['kode_nama_role'],
      //       nama_merchant: res['data']['nama_merchant'],
      //       alamat: res['data']['alamat'],
      //       logo: res['data']['logo']);
    }

    return HttpResponseModel(
        code: res['code'], message: res['message'], data: userModel);
  }
}
