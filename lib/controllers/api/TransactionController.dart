import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import '../../models/HttpResponseModel.dart';
import '../../models/UserModel.dart';

class TransactionController {
  static Future<HttpResponseModel> createTransaksi(
      String data, String tanggal_transaksi, String nama) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "nama": nama,
      "data": data,
      "tanggal_transaksi": tanggal_transaksi,
      "password": users.password,
      "username": users.username,
      "device_id": deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}transaction/create"),
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

  static Future<HttpResponseModel> getPembayaranDetail(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id": id,
      "password": users.password,
      "username": users.username,
      "device_id": deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}payment/detail/get"),
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
