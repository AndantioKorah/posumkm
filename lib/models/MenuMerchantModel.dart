import 'HttpResponseModel.dart';

class MenuMerchantModel extends HttpResponseModel {
  late String nama_menu_merchant = "", 
  deskripsi = "", 
  id = "", 
  id_m_merchant = "", 
  id_m_jenis_menu = "", 
  id_m_kategori_menu = "", 
  harga = "",
  nama_jenis_menu = "",
  nama_kategori_menu = "";
  int selectedCount = 0;

  MenuMerchantModel({
    required this.id,
    required this.id_m_merchant,
    required this.id_m_jenis_menu,
    required this.id_m_kategori_menu,
    required this.harga,
    required this.nama_menu_merchant,
    required this.deskripsi,
    required this.nama_jenis_menu,
    required this.nama_kategori_menu,
    required this.selectedCount
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['id_m_merchant'] = id_m_merchant;
    result['id_m_jenis_menu'] = id_m_jenis_menu;
    result['id_m_kategori_menu'] = id_m_kategori_menu;
    result['harga'] = harga;
    result['nama_menu_merchant'] = nama_menu_merchant;
    result['nama_jenis_menu'] = nama_jenis_menu;
    result['nama_kategori_menu'] = nama_kategori_menu;
    result['deskripsi'] = deskripsi;
    result['selectedCount'] = selectedCount;

    return result;
  }

  MenuMerchantModel.fromJson(Map<String, dynamic> json) {
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
    if (json['nama_jenis_menu'] != null) {
      nama_jenis_menu = json['nama_jenis_menu'];
    }
    if (json['nama_kategori_menu'] != null) {
      nama_kategori_menu = json['nama_kategori_menu'];
    }
    if (json['deskripsi'] != null) {
      deskripsi = json['deskripsi'];
    }
    if (json.containsKey('selectedCount')) {
      selectedCount = json['selectedCount'];
    }
  }
}

List<MenuMerchantModel> convertToListMenuMerchant(List<dynamic> res) {
  List<MenuMerchantModel> menuMerchantModel = [];
  MenuMerchantModel? temp;

  for (var i = 0; i < res.length; i++) {
    temp = MenuMerchantModel.fromJson(res[i]);
    menuMerchantModel.add(temp);
  }

  return menuMerchantModel;
}
