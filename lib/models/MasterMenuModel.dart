import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:posumkm/models/KategoriMenuModel.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';

import 'HttpResponseModel.dart';

class MasterMenuModel extends HttpResponseModel {
  List<JenisMenuModel> listJenisMenu = [];
  List<KategoriMenuModel> listKategoriMenu = [];
  List<MenuMerchantModel> listMenuMerchant = [];

  MasterMenuModel({
    required this.listJenisMenu,
    required this.listKategoriMenu,
    required this.listMenuMerchant
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = <String, dynamic>{};
    result['listJenisMenu'] = listJenisMenu;
    result['listKategoriMenu'] = listKategoriMenu;
    result['listMenuMerchant'] = listMenuMerchant;

    return result;
  }

  MasterMenuModel.fromJson(Map<String, dynamic> json) {
    if (json['jenis_menu'] != null) {
      listJenisMenu = json['jenis_menu'];
    }
    if (json['kategori_menu'] != null) {
      listKategoriMenu = json['kategori_menu'];
    }
    if (json['menu_merchant'] != null) {
      listMenuMerchant = json['menu_merchant'];
    }
  }
}

List<MasterMenuModel> convertToListMasterMenu(List<dynamic> res) {
  List<MasterMenuModel> masterMenuModel = [];
  MasterMenuModel? temp;

  for (var i = 0; i < res.length; i++) {
    temp = MasterMenuModel.fromJson(res[i]);
    masterMenuModel.add(temp);
  }

  return masterMenuModel;
}
