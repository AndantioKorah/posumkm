import 'package:flutter/material.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';

class MenuMerchantProvider with ChangeNotifier{
  List<MenuMerchantModel> _selectedMenu = [];

  List<MenuMerchantModel> get getListMenu{
    return [..._selectedMenu];
  }

  void setListMenu(List<MenuMerchantModel> items){
    _selectedMenu = items;
    notifyListeners();
  }

  void addMenu(MenuMerchantModel item){
    if(item.selectedCount == 0){
      _selectedMenu[int.tryParse(item.id)!] = item;
    } else {
      _selectedMenu[int.tryParse(item.id)!].selectedCount = _selectedMenu[int.tryParse(item.id)!].selectedCount! + 1;
    }
  }
  
  void minusMenu(MenuMerchantModel item){
    _selectedMenu[int.tryParse(item.id)!].selectedCount = _selectedMenu[int.tryParse(item.id)!].selectedCount! - 1;
    if(_selectedMenu[int.tryParse(item.id)!].selectedCount == 0){
      _selectedMenu.remove(int.tryParse(item.id));
    }
  }
}