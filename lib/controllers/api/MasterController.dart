import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:posumkm/models/KategoriMenuModel.dart';
import 'package:posumkm/models/MasterMenuModel.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';
import 'package:posumkm/models/UserModel.dart';
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
        "device_id" : deviceData['deviceId']
      });
      var res = json.decode(req.body);
      if (res['code'] == 200 && res['data'] != null) {
        // masterMenuModel = MasterMenuModel.fromJson(json.decode(res['data'].toString()));
        if (res['data']['jenis_menu'] != null) {
          listJenisMenuModel =
              convertToListJenisMenu(res['data']['jenis_menu']);
        }
        if (res['data']['kategori_menu'] != null) {
          listKategoriModel =
              convertToListKategoriMenu(res['data']['kategori_menu']);
        }
        if (res['data']['menu_merchant'] != null) {
          listMenuMerchantModel =
              convertToListMenuMerchant(res['data']['menu_merchant']);
        }

        masterMenuModel = MasterMenuModel(
            listJenisMenu: listJenisMenuModel,
            listKategoriMenu: listKategoriModel,
            listMenuMerchant: listMenuMerchantModel);
        res['message'] = "Data Sudah Terupdate";
      }
      return HttpResponseModel(
          code: res['code'], message: res['message'], data: res['code'] == 200 ? masterMenuModel : null);
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
      var req = await http.post(
          Uri.parse("${AppConstants.apiBaseUrl}master/menu/jenis"),
          body: {
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

  static Future<HttpResponseModel> tambahMasterJenis(
      String nama_jenis_menu) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "nama_jenis_menu": nama_jenis_menu,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']

    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/menu/jenis/create"),
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

  static Future<HttpResponseModel> editMasterJenis(
    String nama_jenis_menu,
    String id,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "nama_jenis_menu": nama_jenis_menu,
      "id": id,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']

    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/menu/jenis/edit"),
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

  static Future<HttpResponseModel> deleteMasterJenis(
    String id,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id": id,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/menu/jenis/delete"),
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

  static Future<HttpResponseModel> tambahMasterKategori(
      String nama_kategori_menu, String id_m_jenis_menu) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "nama_kategori_menu": nama_kategori_menu,
      "id_m_jenis_menu": id_m_jenis_menu,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/menu/kategori/create"),
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

  static Future<HttpResponseModel> editMasterKategori(
      String nama_kategori_menu, String id, String id_m_jenis_menu) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "nama_kategori_menu": nama_kategori_menu,
      "id": id,
      "id_m_jenis_menu": id_m_jenis_menu,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/menu/kategori/edit"),
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

  static Future<HttpResponseModel> deleteMasterKategori(
    String id,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id": id,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/menu/kategori/delete"),
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

  static Future<HttpResponseModel> tambahMenuMerchant(
      String nama_menu_merchant, String id_m_kategori_menu, String harga) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "nama_menu_merchant": nama_menu_merchant,
      "id_m_kategori_menu": id_m_kategori_menu,
      "harga": harga,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/merchant/menu/create"),
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

  static Future<HttpResponseModel> editMenuMerchant(
      String id, String nama_menu_merchant, String id_m_kategori_menu, String harga) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id": id,
      "nama_menu_merchant": nama_menu_merchant,
      "id_m_kategori_menu": id_m_kategori_menu,
      "harga": harga,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/merchant/menu/edit"),
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

  static Future<HttpResponseModel> deleteMenuMerchant(
    String id,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id": id,
      "id_m_merchant": users.id_m_merchant,
      "password": users.password,
      "username": users.username,
      "device_id" : deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}master/merchant/menu/delete"),
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
