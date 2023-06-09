import 'HttpResponseModel.dart';

class KategoriMenuModel extends HttpResponseModel {
  String nama_kategori_menu = "", 
  deskripsi = "", 
  id = "", 
  id_m_merchant = "", 
  id_m_jenis_menu = "";

  KategoriMenuModel({
    required this.id,
    required this.id_m_merchant,
    required this.id_m_jenis_menu,
    required this.nama_kategori_menu,
    required this.deskripsi,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_m_merchant'] = id_m_merchant;
    result['id_m_jenis_menu'] = id_m_jenis_menu;
    result['nama_kategori_menu'] = nama_kategori_menu;
    result['deskripsi'] = deskripsi;

    return result;
  }

  KategoriMenuModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    }
    if (json['id_m_jenis_menu'] != null) {
      id_m_jenis_menu = json['id_m_jenis_menu'];
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'];
    }
    if (json['nama_kategori_menu'] != null) {
      nama_kategori_menu = json['nama_kategori_menu'];
    }
    if (json['deskripsi'] != null) {
      deskripsi = json['deskripsi'];
    }
  }
}

List<KategoriMenuModel> convertToListKategoriMenu(List<dynamic> res) {
  List<KategoriMenuModel> kategoriMenuModel = [];
  KategoriMenuModel? temp;
  for (var i = 0; i < res.length; i++) {
    temp = KategoriMenuModel.fromJson(res[i]);
    kategoriMenuModel.add(temp);
  }

  return kategoriMenuModel;
}
