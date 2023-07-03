import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/controllers/api/MasterController.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../models/KategoriMenuModel.dart';
import '../../models/MenuMerchantModel.dart';
import '../widget/HttpToastDialog.dart';

class EditMasterMenu {
  final TextEditingController _namaJenisController = TextEditingController();
  final TextEditingController _namaKategoriController = TextEditingController();
  final TextEditingController _namaMenuController = TextEditingController();
  final TextEditingController _hargaMenuController = TextEditingController();
  final RoundedLoadingButtonController _buttonSaveController =
      RoundedLoadingButtonController();

  void editDataJenis(
      JenisMenuModel? item, BuildContext context, Function callbackFunction) {
    _namaJenisController.text = item != null ? item.nama_jenis_menu : '';
    String _title = item != null ? "EDIT MASTER JENIS" : "TAMBAH MASTER JENIS";
    late HttpResponseModel res;

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: AppsColor.alternativeWhite,
        context: context,
        builder: (_) {
          return Wrap(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 30),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 100,
                        height: 3,
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    Align(
                      child: Text(
                        _title,
                        style: styleText.labelTitle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autofocus: true,
                      style: styleText.valueEditMaster,
                      controller: _namaJenisController,
                      decoration: InputDecoration(
                        labelText: "Nama Jenis",
                        labelStyle: styleText.labelEditMaster,
                        focusColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // InkWell(
                    //   child: buttonSave(context)
                    // ),
                    RoundedLoadingButton(
                      // resetAfterDuration: true,
                      // resetDuration: const Duration(seconds: 3),
                      borderRadius: 5,
                      height: 45,
                      controller: _buttonSaveController,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () async {
                        if (item != null) {
                          await MasterController.editMasterJenis(
                                  _namaJenisController.text, item.id)
                              .then((value) => {
                                    res = value,
                                  });
                        } else {
                          await MasterController.tambahMasterJenis(
                                  _namaJenisController.text)
                              .then((value) => {
                                    res = value,
                                  });
                        }
                        _buttonSaveController.reset();
                        // ignore: use_build_context_synchronously
                        httpToastDialog(
                          res,
                          context,
                          ToastGravity.BOTTOM,
                          const Duration(seconds: 3),
                          const Duration(seconds: 3),
                        );
                        if (res.code == 200 || res.code == 201) {
                          callbackFunction("");
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_as_rounded,
                              color: AppsColor.alternativeWhite,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Simpan",
                              style: styleText.labelSaveButton,
                            )
                          ]),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void editDataKategori(
      KategoriMenuModel? item,
      List<JenisMenuModel> listJenisMenu,
      BuildContext context,
      Function callbackFunction) {
    _namaKategoriController.text = item != null ? item.nama_kategori_menu : '';
    String _title =
        item != null ? "EDIT MASTER KATEGORI" : "TAMBAH MASTER KATEGORI";
    late HttpResponseModel res;
    JenisMenuModel? selectedJenisMenu;
    String selectedId = "0";
    if (listJenisMenu.isNotEmpty) {
      for (var data in listJenisMenu) {
        if (item != null) {
          if (data.id == item.id_m_jenis_menu) {
            selectedJenisMenu = data;
            selectedId = selectedJenisMenu.id;
          }
        } else {
          selectedJenisMenu = listJenisMenu[0];
          selectedId = selectedJenisMenu.id;
        }
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: AppsColor.alternativeWhite,
        context: context,
        builder: (_) {
          return Wrap(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 30),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 100,
                        height: 3,
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    Align(
                      child: Text(
                        _title,
                        style: styleText.labelTitle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      focusColor: Colors.transparent,
                      isExpanded: true,
                      value:
                          selectedJenisMenu != null ? selectedJenisMenu : null,
                      icon: Icon(
                        FontAwesomeIcons.chevronDown,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 15,
                      ),
                      decoration: InputDecoration(
                        labelText: "Pilih Jenis Menu",
                        labelStyle: styleText.labelEditMaster,
                        focusColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        border: const OutlineInputBorder(),
                      ),
                      items: listJenisMenu.map((var item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.nama_jenis_menu,
                              style: styleText.labelDropDownItem),
                        );
                      }).toList(),
                      onChanged: (JenisMenuModel? selected) {
                        if (selected != null) {
                          selectedJenisMenu = selected;
                          selectedId = selectedJenisMenu!.id;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autofocus: true,
                      style: styleText.valueEditMaster,
                      controller: _namaKategoriController,
                      decoration: InputDecoration(
                        labelText: "Nama Kategori",
                        labelStyle: styleText.labelEditMaster,
                        focusColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // InkWell(
                    //   child: buttonSave(context)
                    // ),
                    RoundedLoadingButton(
                      // resetAfterDuration: true,
                      // resetDuration: const Duration(seconds: 3),
                      borderRadius: 5,
                      height: 45,
                      controller: _buttonSaveController,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () async {
                        if (item != null) {
                          await MasterController.editMasterKategori(
                                  _namaKategoriController.text,
                                  item.id,
                                  selectedId)
                              .then((value) => {
                                    res = value,
                                  });
                        } else {
                          await MasterController.tambahMasterKategori(
                                  _namaKategoriController.text, selectedId)
                              .then((value) => {
                                    res = value,
                                  });
                        }
                        _buttonSaveController.reset();
                        // ignore: use_build_context_synchronously
                        httpToastDialog(
                          res,
                          context,
                          ToastGravity.BOTTOM,
                          const Duration(seconds: 3),
                          const Duration(seconds: 3),
                        );
                        if (res.code == 200 || res.code == 201) {
                          callbackFunction("");
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_as_rounded,
                              color: AppsColor.alternativeWhite,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Simpan",
                              style: styleText.labelSaveButton,
                            )
                          ]),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void editDataMenuMerchant(
      MenuMerchantModel? item,
      List<KategoriMenuModel> listKategoriMenu,
      BuildContext context,
      Function callbackFunction) {
    _namaMenuController.text = item != null ? item.nama_menu_merchant : '';
    _hargaMenuController.text = item != null ? item.harga : '';
    String _title = item != null ? "EDIT MASTER MENU" : "TAMBAH MASTER MENU";
    late HttpResponseModel res;
    KategoriMenuModel? selectedKategoriMenu;
    String selectedKategoriId = "0";

    if (listKategoriMenu.isNotEmpty) {
      for (var data in listKategoriMenu) {
        if (item != null) {
          if (data.id == item.id_m_kategori_menu) {
            selectedKategoriMenu = data;
            selectedKategoriId = selectedKategoriMenu.id;
          }
        } else {
          selectedKategoriMenu = listKategoriMenu[0];
          selectedKategoriId = selectedKategoriMenu.id;
        }
      }
    }
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: AppsColor.alternativeWhite,
        context: context,
        builder: (_) {
          return Wrap(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 30),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 100,
                        height: 3,
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    Align(
                      child: Text(
                        _title,
                        style: styleText.labelTitle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                      focusColor: Colors.transparent,
                      isExpanded: true,
                      value:
                          // selectedKategoriMenu != null ? selectedKategoriMenu : null,
                          selectedKategoriMenu,
                      icon: Icon(
                        FontAwesomeIcons.chevronDown,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 15,
                      ),
                      decoration: InputDecoration(
                        labelText: "Pilih Kategori Menu",
                        labelStyle: styleText.labelEditMaster,
                        focusColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        border: const OutlineInputBorder(),
                      ),
                      items: listKategoriMenu.map((var item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.nama_kategori_menu,
                              style: styleText.labelDropDownItem),
                        );
                      }).toList(),
                      onChanged: (KategoriMenuModel? selected) {
                        if (selected != null) {
                          selectedKategoriMenu = selected;
                          selectedKategoriId = selectedKategoriMenu!.id;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autofocus: true,
                      style: styleText.valueEditMaster,
                      controller: _namaMenuController,
                      decoration: InputDecoration(
                        labelText: "Nama Menu",
                        labelStyle: styleText.labelEditMaster,
                        focusColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autofocus: true,
                      style: styleText.valueEditMaster,
                      controller: _hargaMenuController,
                      decoration: InputDecoration(
                        labelText: "Harga",
                        labelStyle: styleText.labelEditMaster,
                        focusColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // InkWell(
                    //   child: buttonSave(context)
                    // ),
                    RoundedLoadingButton(
                      // resetAfterDuration: true,
                      // resetDuration: const Duration(seconds: 3),
                      borderRadius: 5,
                      height: 45,
                      controller: _buttonSaveController,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      onPressed: () async {
                        if (item != null) {
                          await MasterController.editMenuMerchant(
                                  item.id,
                                  _namaMenuController.text,
                                  selectedKategoriId,
                                  _hargaMenuController.text)
                              .then((value) => {
                                    res = value,
                                  });
                        } else {
                          await MasterController.tambahMenuMerchant(
                                  _namaMenuController.text,
                                  selectedKategoriId,
                                  _hargaMenuController.text)
                              .then((value) => {
                                    res = value,
                                  });
                        }
                        _buttonSaveController.reset();
                        // ignore: use_build_context_synchronously
                        httpToastDialog(
                          res,
                          context,
                          ToastGravity.BOTTOM,
                          const Duration(seconds: 3),
                          const Duration(seconds: 3),
                        );
                        if (res.code == 200 || res.code == 201) {
                          callbackFunction("");
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_as_rounded,
                              color: AppsColor.alternativeWhite,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Simpan",
                              style: styleText.labelSaveButton,
                            )
                          ]),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}

class styleText {
  static final labelEditMaster = TextStyle(
      fontSize: 14,
      color: Colors.grey[900],
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valueEditMaster = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const labelTitle = TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const labelSaveButton = TextStyle(
      fontSize: 14,
      color: AppsColor.alternativeWhite,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const labelDropDownItem = TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");
}

Widget buttonSave(BuildContext ctx) {
  return Wrap(
    children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(5)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_as_rounded,
              color: AppsColor.alternativeWhite,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Simpan",
              style: styleText.labelSaveButton,
            )
          ],
        ),
      )
    ],
  );
}
