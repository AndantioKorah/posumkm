import 'HttpResponseModel.dart';

class UserModel extends HttpResponseModel{
  String? username, password, nama_user, id_m_user, id_m_role, id_m_merchant, nama_role, kode_nama_role, nama_merchant, alamat, logo;
 
  UserModel({
    this.username,
    this.password,
    this.nama_user,
    this.id_m_user,
    this.id_m_role,
    this.id_m_merchant,
    this.nama_role,
    this.kode_nama_role,
    this.nama_merchant,
    this.alamat,
    this.logo,
  });

  Map<String, dynamic> toJson(){
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

    return result; 
  }
}