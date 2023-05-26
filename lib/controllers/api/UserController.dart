import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:posumkm/config/constants.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/UserModel.dart';

class UserController {
  static UserModel? userModel;
  static Future<HttpResponseModel> loginFunction(String username, String password) async {

    var req = await http.post(
      Uri.parse("${AppConstants.apiBaseUrl}user/login"),
      body: {
        "username": username,
        "password": password,
      }
    );

    var res = json.decode(req.body);
    if(res['code'] == 200 && res['data'] != null){
      userModel = UserModel(
        username: res['data']['username'], 
        password: res['data']['password'], 
        nama_user: res['data']['nama_user'], 
        id_m_user: res['data']['id_m_user'],
        id_m_role: res['data']['id_m_role'], 
        id_m_merchant: res['data']['id_m_merchant'], 
        nama_role: res['data']['nama_role'], 
        kode_nama_role: res['data']['kode_nama_role'], 
        nama_merchant: res['data']['nama_merchant'], 
        alamat: res['data']['alamat'], 
        logo: res['data']['logo']
      );
    }

    return HttpResponseModel(
      code: res['code'],
      message: res['message'],
      data: userModel
    );
  }
}