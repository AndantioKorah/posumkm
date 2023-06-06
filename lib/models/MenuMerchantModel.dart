import 'HttpResponseModel.dart';

class JenisMenuModel extends HttpResponseModel {
  late int id, id_m_merchant, id_m_jenis_menu, id_m_kategori_menu, harga;
  late String nama_menu_merchant, deskripsi;

  JenisMenuModel({
    required this.id,
    required this.id_m_merchant,
    required this.id_m_jenis_menu,
    required this.id_m_kategori_menu,
    required this.harga,
    required this.nama_menu_merchant,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_m_merchant'] = id_m_merchant;
    result['id_m_jenis_menu'] = id_m_jenis_menu;
    result['id_m_kategori_menu'] = id_m_kategori_menu;
    result['harga'] = harga;
    result['nama_menu_merchant'] = nama_menu_merchant;
    result['deskripsi'] = deskripsi;

    return result;
  }

  JenisMenuModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['id_m_jenis_menu'] != null) {
      id_m_jenis_menu = json['id_m_jenis_menu'];
    }
    if (json['id_m_kategori_menu'] != null) {
      id_m_kategori_menu = json['id_m_kategori_menu'];
    }
    if (json['harga'] != null) {
      harga = json['harga'];
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'];
    }
    if (json['nama_menu_merchant'] != null) {
      nama_menu_merchant = json['nama_menu_merchant'];
    }
    if (json['deskripsi'] != null) {
      deskripsi = json['deskripsi'];
    }
  }
}
