import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';
import 'package:posumkm/models/TransactionDetailModel.dart';
import 'package:posumkm/views/baselayoutpage.dart';

class MenuMerchantProvider with ChangeNotifier{
  bool synced = false;
  List<MenuMerchantModel> _selectedMenu = [];
  // ignore: prefer_final_fields
  var _mapMenu = <String, MenuMerchantModel>{};
  int _totalTransaksi = 0;

  List<MenuMerchantModel> get selectedMenu => _selectedMenu;
  int get totalTransaksi => _totalTransaksi;

  Map<String, MenuMerchantModel> get getListSelected{
    return _mapMenu;
  }

  int getTotalTransaksi() {
    return _totalTransaksi;
  }

  void setListDataFromWs(List<TransactionDetailModel> items){
    if(!synced){
      for (var item in items) {
        MenuMerchantModel temp = MenuMerchantModel(
          id: item.id_m_menu_merchant,
          id_m_merchant: item.id_m_merchant,
          id_m_jenis_menu: item.id_m_jenis_menu,
          id_m_kategori_menu: item.id_m_kategori_menu,
          harga: item.harga,
          nama_menu_merchant: item.nama_menu_merchant,
          deskripsi: "",
          nama_jenis_menu: item.nama_jenis_menu, 
          nama_kategori_menu: item.nama_kategori_menu, 
          selectedCount: int.parse(item.qty));
          _selectedMenu.add(temp);
          _mapMenu[item.id_m_menu_merchant] = temp;
          _totalTransaksi += int.parse(item.qty) * int.parse(item.harga);
      }
      synced = true; 
    }
  }

  void setListMenu(List<MenuMerchantModel> items){
    _selectedMenu = items;
    notifyListeners();
  }

  // void generateMapMenu(){
  //   for(var i = 0; i < _selectedMenu.length; i++){
  //     _mapMenu[_selectedMenu[i].id] = _selectedMenu[i];
  //   }
  // }

  void addMenu(MenuMerchantModel item){
    if(item.selectedCount == 0){
      _selectedMenu.add(item);
      item.selectedCount = 1;
      _mapMenu[item.id] = item;
    } else {
      _mapMenu[item.id]?.selectedCount += 1;
    }
    _totalTransaksi += int.parse(item.harga);
    notifyListeners();
  }
  
  void removeMenu(MenuMerchantModel item){
    if(_mapMenu.containsKey(item.id)){
      _mapMenu[item.id]?.selectedCount -= 1;
      if(_mapMenu[item.id]?.selectedCount == 0){
        _mapMenu.remove(item.id);
      }
      _totalTransaksi -= int.parse(item.harga);
    }
    notifyListeners();
  }

  void removeSelectedMenu(MenuMerchantModel item){
    if(_mapMenu.containsKey(item.id)){
      _totalTransaksi -= (int.parse(_mapMenu[item.id]!.harga) * _mapMenu[item.id]!.selectedCount);
      _mapMenu[item.id]?.selectedCount = 0;
      _mapMenu.remove(item.id);
      notifyListeners();
    }
  }
}