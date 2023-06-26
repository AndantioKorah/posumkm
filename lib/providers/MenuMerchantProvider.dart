import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';

class MenuMerchantProvider with ChangeNotifier{
  List<MenuMerchantModel> _selectedMenu = [];
  // ignore: prefer_final_fields
  var _mapMenu = <String, MenuMerchantModel>{};
  int totalTransaksi = 0;

  Map<String, MenuMerchantModel> get getListSelected{
    return _mapMenu;
  }

  int getTotalTransaksi() {
    return totalTransaksi;
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
    totalTransaksi += int.parse(item.harga);
    notifyListeners();
  }
  
  void removeMenu(MenuMerchantModel item){
    if(_mapMenu.containsKey(item.id)){
      _mapMenu[item.id]?.selectedCount -= 1;
      if(_mapMenu[item.id]?.selectedCount == 0){
        _mapMenu.remove(item.id);
      }
      totalTransaksi -= int.parse(item.harga);
    }
    notifyListeners();
  }

  void removeSelectedMenu(MenuMerchantModel item){
    if(_mapMenu.containsKey(item.id)){
      totalTransaksi -= (int.parse(_mapMenu[item.id]!.harga) * _mapMenu[item.id]!.selectedCount);
      _mapMenu[item.id]?.selectedCount = 0;
      _mapMenu.remove(item.id);
      notifyListeners();
    }
  }
}