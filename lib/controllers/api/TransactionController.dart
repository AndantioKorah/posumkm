import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import '../../models/HttpResponseModel.dart';
import '../../models/UserModel.dart';

class TransactionController {
  static Future<HttpResponseModel> createTransaksi(
      String data, String tanggal_transaksi, String nama, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id": id,
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

  static Future<HttpResponseModel> getAllTransaksiByDate(
      String tanggal_transaksi) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "tanggal": tanggal_transaksi,
      "password": users.password,
      "username": users.username,
      "device_id": deviceData['deviceId']
    };
    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}transaction/get"),
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

  static Future<HttpResponseModel> getDataDashboard() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "password": users.password,
      "username": users.username,
      "device_id": deviceData['deviceId']
    };
    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}transaction/dashboard/get"),
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

  static Future<HttpResponseModel> getTransactionDetail(String id) async {
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
        Uri.parse("${AppConstants.apiBaseUrl}transaction/detail"),
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

  static Future<HttpResponseModel> createPembayaran(
      String id_t_transaksi,
      String tanggal_pembayaran,
      String id_m_jenis_pembayaran,
      String nama_pembayar,
      String total_pembayaran,
      String kembalian) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel users = UserModel.fromJson(
        jsonDecode(pref.getString("userLoggedIn").toString()));
    Map<String, String> body = {
      "id_t_transaksi": id_t_transaksi,
      "id_m_merchant": users.id_m_merchant,
      "tanggal_pembayaran": tanggal_pembayaran,
      "id_m_jenis_pembayaran": id_m_jenis_pembayaran,
      "nama_pembayar": nama_pembayar,
      "total_pembayaran": total_pembayaran,
      "kembalian": kembalian,
      "password": users.password,
      "username": users.username,
      "device_id": deviceData['deviceId']
    };

    var req = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}payment/create"),
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

  static Future<HttpResponseModel> deletePembayaran(String id) async {
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
        Uri.parse("${AppConstants.apiBaseUrl}payment/delete"),
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
