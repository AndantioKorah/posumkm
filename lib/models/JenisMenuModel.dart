import 'HttpResponseModel.dart';

class JenisMenuModel extends HttpResponseModel {
  String nama_jenis_menu = "", deskripsi = "", id = "", id_m_merchant = "";

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
