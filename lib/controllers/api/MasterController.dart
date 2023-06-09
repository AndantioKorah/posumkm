import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:posumkm/models/KategoriMenuModel.dart';
import 'package:posumkm/models/MasterMenuModel.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';
import 'package:posumkm/models/UserModel.dart';
import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserModel? userLoggedInApps;

class MasterController {
  static UserModel? userModel;
  static List<JenisMenuModel> listJenisModel = [];
  static List<JenisMenuModel> listJenisMenuModel = [];
  static List<KategoriMenuModel> listKategoriModel = [];
  static List<MenuMerchantModel> listMenuMerchantModel = [];
  static late MasterMenuModel masterMenuModel;

  static Future<HttpResponseModel> getAllMasterMenu() async {
    final preference = await SharedPreferences.getInstance();
    if (preference.containsKey("userLoggedIn")) {
      userLoggedInApps = UserModel.fromJson(
          json.decode(preference.getString("userLoggedIn").toString()));
    }
    try {
    var req = await http
        .post(Uri.parse("${AppConstants.apiBaseUrl}master/menu"), body: {
      "username": userLoggedInApps?.username,
      "password": userLoggedInApps?.password,
      "id_m_merchant": userLoggedInApps?.id_m_merchant,
    });

    var res = json.decode(req.body);
    if (res['code'] == 200 && res['data'] != null) {
      // masterMenuModel = MasterMenuModel.fromJson(json.decode(res['data'].toString()));
      if(res['data']['jenis_menu'] != null){
        listJenisMenuModel = convertToListJenisMenu(res['data']['jenis_menu']);
      }
      if(res['data']['kategori_menu'] != null){
        listKategoriModel = convertToListKategoriMenu(res['data']['kategori_menu']);
      }
      if(res['data']['menu_merchant'] != null){
        // print(res['data']['menu_merchant']);
        listMenuMerchantModel = convertToListMenuMerchant(res['data']['menu_merchant']);
      }

      masterMenuModel = MasterMenuModel(
        listJenisMenu: listJenisMenuModel,
        listKategoriMenu: listKategoriModel,
        listMenuMerchant: listMenuMerchantModel);
      res['message'] = "Data Sudah Terupdate";
    }
    return HttpResponseModel(
        code: res['code'], message: res['message'], data: masterMenuModel);
    } catch (e) {
      return HttpResponseModel(
          code: 500, message: "Terjadi Kesalahan \n $e", data: null);
    }
  }

  static Future<HttpResponseModel> getAllJenisMenu() async {
    final preference = await SharedPreferences.getInstance();
    if (preference.containsKey("userLoggedIn")) {
      userLoggedInApps = UserModel.fromJson(
          json.decode(preference.getString("userLoggedIn").toString()));
    }
    try {
    var req = await http
        .post(Uri.parse("${AppConstants.apiBaseUrl}master/menu/jenis"), body: {
      "username": userLoggedInApps?.username,
      "password": userLoggedInApps?.password,
      "id_m_merchant": userLoggedInApps?.id_m_merchant,
    });

    var res = json.decode(req.body);
    if (res['code'] == 200 && res['data'] != null) {
      listJenisModel = convertToListJenisMenu(res['data']);
      res['message'] = "Data Sudah Terupdate";
      // await DBHelper.insertListJenisMenu(listJenisModel);

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
