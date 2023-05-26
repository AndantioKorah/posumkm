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
}