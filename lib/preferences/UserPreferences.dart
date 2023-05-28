import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/UserModel.dart';

class UserPreferences {
  static Future<void> setUserLoggedIn(UserModel user) async {
    final preference = await SharedPreferences.getInstance();

    if (preference.containsKey("userLoggedIn")) {
      preference.clear();
    }

    preference.setString("userLoggedIn", jsonEncode(user));
  }

  static Future<dynamic> getUserLoggedIn() async {
    final preference = await SharedPreferences.getInstance();
    final user = UserModel.fromJson(
        json.decode((preference.getString("userLoggedIn")).toString())
            as Map<String, dynamic>);
    return user.toJson();
    // return UserModel(
    //     username: userLoggedIn['username'],
    //     password: userLoggedIn['password'],
    //     nama_user: userLoggedIn['nama_user'],
    //     id_m_user: userLoggedIn['id_m_user'],
    //     id_m_role: userLoggedIn['id_m_role'],
    //     id_m_merchant: userLoggedIn['id_m_merchant'],
    //     nama_role: userLoggedIn['nama_role'],
    //     kode_nama_role: userLoggedIn['kode_nama_role'],
    //     nama_merchant: userLoggedIn['nama_merchant'],
    //     alamat: userLoggedIn['alamat'],
    //     logo: userLoggedIn['logo']);
  }

  static Future<void> logOutUser() async {
    final preference = await SharedPreferences.getInstance();
    if (preference.containsKey("userLoggedIn")) {
      preference.clear();
    }
  }
}
