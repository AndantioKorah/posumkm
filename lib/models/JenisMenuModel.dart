import 'HttpResponseModel.dart';

class JenisMenuModel extends HttpResponseModel {
  String nama_jenis_menu = "",
  deskripsi = "",
  id = "",
  id_m_merchant = "",
  jumlah_kategori = "",
  jumlah_menu = "";
  
  JenisMenuModel({
    required this.id,
    required this.id_m_merchant,
    required this.nama_jenis_menu,
    required this.deskripsi,
    required this.jumlah_kategori,
    required this.jumlah_menu
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_m_merchant'] = id_m_merchant;
    result['nama_jenis_menu'] = nama_jenis_menu;
    result['deskripsi'] = deskripsi;
    result['jumlah_kategori'] = jumlah_kategori;
    result['jumlah_menu'] = jumlah_menu;

    return result;
  }

  JenisMenuModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'].toString();
    }
    if (json['id_m_merchant'] != null) {
      id_m_merchant = json['id_m_merchant'].toString();
    }
    if (json['nama_jenis_menu'] != null) {
      nama_jenis_menu = json['nama_jenis_menu'];
    }
    if (json['deskripsi'] != null) {
      deskripsi = json['deskripsi'];
    }

    if (json['jumlah_kategori'] != null) {
      jumlah_kategori = json['jumlah_kategori'];
    }

    if (json['jumlah_menu'] != null) {
      jumlah_menu = json['jumlah_menu'];
    }
  }
}

List<JenisMenuModel> convertToListJenisMenu(List<dynamic> res) {
  List<JenisMenuModel> jenisMenuModel = [];
  JenisMenuModel? temp;

  for (var i = 0; i < res.length; i++) {
    temp = JenisMenuModel.fromJson(res[i]);
    jenisMenuModel.add(temp);
  }

  return jenisMenuModel;
}
