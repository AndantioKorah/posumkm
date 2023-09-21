import 'HttpResponseModel.dart';

class UserModel extends HttpResponseModel {
  late String username,
      password,
      nama_user,
      id_m_user,
      id_m_role,
      id_m_merchant = '',
      nama_role,
      kode_nama_role,
      nama_merchant = '',
      alamat = '',
      logo = '',
      expire_date = '';

  UserModel({
    required this.username,
    required this.password,
    required this.nama_user,
    required this.id_m_user,
    required this.id_m_role,
    required this.id_m_merchant,
    required this.nama_role,
    required this.kode_nama_role,
    required this.nama_merchant,
    required this.alamat,
    required this.logo,
    required this.expire_date,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['username'] = username;
    result['password'] = password;
    result['nama_user'] = nama_user;
    result['id_m_user'] = id_m_user;
    result['id_m_role'] = id_m_role;
    result['id_m_merchant'] = id_m_merchant;
    result['nama_role'] = nama_role;
    result['kode_nama_role'] = kode_nama_role;
    result['nama_merchant'] = nama_merchant;
    result['alamat'] = alamat;
    result['logo'] = logo;
    result['expire_date'] = expire_date;

    return result;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json['username'] != null) {
      username = json['username'];
    }
    if (json['password'] != null) {
      password = json['password'];
    }
    if (json['nama_user'] != null) {
      nama_user = json['nama_user'];
    }
    if (json['id_m_user'] != null) {
      id_m_user = json['id_m_user'];
    }
    if (json['id_m_role'] != null) {
      id_m_role = json['id_m_role'];
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'];
    }
    if (json['nama_role'] != null) {
      nama_role = json['nama_role'];
    }
    if (json['kode_nama_role'] != null) {
      kode_nama_role = json['kode_nama_role'];
    }
    if (json['nama_merchant'] != null) {
      nama_merchant = json['nama_merchant'];
    } else {
      nama_merchant = 'PROGRAMMER';
    }
    if (json['alamat'] != null) {
      alamat = json['alamat'];
    } else {
      alamat = 'PROGRAMMER';
    }
    if (json['expire_date'] != null) {
      expire_date = json['expire_date'];
    } else {
      expire_date = '31 Desember 3000';
    }
    if (json['logo'] != null) {
      logo = json['logo'];
    }
    if (json['kode_nama_role'] == 'programmer') {
      logo = '';
    }
  }
}

List<UserModel> convertToList(List<dynamic> res) {
  List<UserModel> userModel = [];
  UserModel? temp;

  for (var i = 0; i < res.length; i++) {
    temp = UserModel.fromJson(res[i]);
    userModel.add(temp);
  }

  return userModel;
}
