import 'HttpResponseModel.dart';

class JenisMenuModel extends HttpResponseModel {
  late int id, id_m_merchant;
  late String nama_jenis_menu, deskripsi;

  JenisMenuModel({
    required this.id,
    required this.id_m_merchant,
    required this.nama_jenis_menu,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_m_merchant'] = id_m_merchant;
    result['nama_jenis_menu'] = nama_jenis_menu;
    result['deskripsi'] = deskripsi;

    return result;
  }

  JenisMenuModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'];
    }
    if (json['nama_jenis_menu'] != null) {
      nama_jenis_menu = json['nama_jenis_menu'];
    }
    if (json['deskripsi'] != null) {
      deskripsi = json['deskripsi'];
    }
  }
}
