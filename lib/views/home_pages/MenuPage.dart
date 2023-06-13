import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:posumkm/models/MasterMenuModel.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/widget/EmptyDataImageWidget.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/api/MasterController.dart';
import '../../main.dart';
import '../../models/KategoriMenuModel.dart';
import '../../models/MenuMerchantModel.dart';
import '../widget/HttpToastDialog.dart';

List<JenisMenuModel> _listJenisMenu = [];
List<KategoriMenuModel> _listKategoriMenu = [];
List<MenuMerchantModel> _listMenuMerchant = [];
MasterMenuModel? _masterMenuModel;
bool _showLoader = true;
bool _jenisMenuEmpty = true;
bool _kategoriMenuEmpty = true;
bool _menuMerchantEmpty = true;
var sprf;

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  TextEditingController searchMenu = TextEditingController();
  TextEditingController searchJenis = TextEditingController();
  TextEditingController searchKategori = TextEditingController();

  List<JenisMenuModel> tempForEach = _listJenisMenu;

  Future<void> _getAllJenisMenu() async {
    final rs = await MasterController.getAllJenisMenu();
    if (rs.code == 200) {
      _listJenisMenu = rs.data;
      _showLoader = false;
    } else {}
    setState(() {});
  }

  Future<HttpResponseModel> _refreshJenisMenu() async {
    _showLoader = true;
    setState(() {});
    HttpResponseModel rs = await MasterController.getAllJenisMenu();
    // ignore: unnecessary_null_comparison
    if (rs != null) {
      if (rs.code == 200) {
        _listJenisMenu = rs.data;
      }
    }
    _showLoader = false;
    setState(() {});
    return rs;
  }

  Future<HttpResponseModel> _refreshMasterMenu() async {
    _showLoader = true;
    setState(() {});
    HttpResponseModel rs = await MasterController.getAllMasterMenu();

    // ignore: unnecessary_null_comparison
    if (rs != null) {
      if (rs.code == 200) {
        _masterMenuModel = rs.data;
        _listJenisMenu = _masterMenuModel!.listJenisMenu;
        if (_listJenisMenu.isNotEmpty) {
          _jenisMenuEmpty = false;
        }

        _listKategoriMenu = _masterMenuModel!.listKategoriMenu;
        if (_listKategoriMenu.isNotEmpty) {
          _kategoriMenuEmpty = false;
        }

        _listMenuMerchant = _masterMenuModel!.listMenuMerchant;
        if (_listMenuMerchant.isNotEmpty) {
          _menuMerchantEmpty = false;
        }
        tempForEach = _listJenisMenu;
      }
    }

    _showLoader = false;
    setState(() {});
    return rs;
  }

  @override
  void initState() {
    super.initState();
    _refreshMasterMenu();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              backgroundColor: theme.colorScheme.onPrimaryContainer,
              title: const Text("MASTER DATA MENU",
                  style: BaseTextStyle.appBarTitle),
              centerTitle: true,
              actions: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () => _refreshMasterMenu().then((value) => {
                          if (value.code != 200)
                            {
                              httpToastDialog(
                                  value,
                                  context,
                                  ToastGravity.BOTTOM,
                                  const Duration(seconds: 2),
                                  const Duration(milliseconds: 100))
                            }
                        }),
                    child: const Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
              bottom: const TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: "Jenis"),
                  Tab(text: "Kategori"),
                  Tab(text: "Menu"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      width: double.infinity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(1, 4),
                                      )
                                    ]),
                                child: TextField(
                                  controller: searchJenis,
                                  onChanged: (searchValue) {
                                    _showLoader = true;
                                    setState(() {});
                                    // ignore: unrelated_type_equality_checks
                                    // if(widget.master == "jenis"){
                                    List<JenisMenuModel> tempJenisMenu = [];
                                    if (searchValue.isNotEmpty) {
                                      tempForEach.forEach((rs) {
                                        if (rs.nama_jenis_menu
                                            .toLowerCase()
                                            .contains(
                                                searchValue.toLowerCase())) {
                                          tempJenisMenu.add(rs);
                                          _listJenisMenu = tempJenisMenu;
                                          _showLoader = false;
                                          setState(() {});
                                        } else {
                                          _listJenisMenu.clear();
                                          _showLoader = false;
                                          setState(() {});
                                        }
                                      });
                                    } else {
                                      _listJenisMenu = tempForEach;
                                      _showLoader = false;
                                      setState(() {});
                                    }
                                    // } else if(widget.master == "kategori") {
                                    // } else if(widget.master == "menu") {
                                    // }
                                  },
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(right: 10, top: 8),
                                      border: InputBorder.none,
                                      hintText: "Cari Data",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Poppins",
                                      ),
                                      prefixIcon: Icon(Icons.search_rounded),
                                      prefixIconColor: Colors.grey),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    const Divider(
                        height: 20, thickness: 1, color: Colors.white),
                    Row(
                      children: [
                        _showLoader
                            ? loadingDataWidget(context)
                            : _listJenisMenu.isNotEmpty
                                ? showJenisMenuItem(_listJenisMenu, context)
                                : emptyDataWidget(context)
                      ],
                    ),
                  ],
                ),
                ListView(
                  children: [
                    SearchField(
                      list: _listKategoriMenu,
                      master: "kategori",
                      searchController: searchKategori,
                    ),
                    const Divider(
                        height: 20, thickness: 1, color: Colors.white),
                    Row(
                      children: [
                        _showLoader
                            ? loadingDataWidget(context)
                            : showKategoriMenu(_listKategoriMenu, context)
                      ],
                    )
                  ],
                ),
                ListView(
                  children: [
                    SearchField(
                      list: _listMenuMerchant,
                      master: "menu",
                      searchController: searchMenu,
                    ),
                    const Divider(
                        height: 20, thickness: 1, color: Colors.white),
                    Row(
                      children: [
                        _showLoader
                            ? loadingDataWidget(context)
                            : showMenuMerchant(_listMenuMerchant, context)
                      ],
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchField extends StatefulWidget {
  TextEditingController searchController;
  List<dynamic> list;
  String master;

  SearchField(
      {required this.list,
      required this.master,
      required this.searchController,
      super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _temp = widget.list;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(1, 4),
                  )
                ]),
            child: TextField(
              controller: widget.searchController,
              onChanged: (searchValue) {
                _showLoader = true;
                // ignore: unrelated_type_equality_checks
                if (widget.master == "jenis") {
                  List<JenisMenuModel> tempForEach =
                      _temp as List<JenisMenuModel>;
                  List<JenisMenuModel> tempJenisMenu = [];
                  if (searchValue.isNotEmpty) {
                    tempForEach.forEach((rs) {
                      if (rs.nama_jenis_menu
                          .toLowerCase()
                          .contains(searchValue.toLowerCase())) {
                        tempJenisMenu.add(rs);
                        setState(() {
                          _listJenisMenu = tempJenisMenu;
                          _showLoader = false;
                        });
                      }
                    });
                  } else {
                    setState(() {
                      _listJenisMenu = widget.list as List<JenisMenuModel>;
                      _showLoader = false;
                    });
                  }
                } else if (widget.master == "kategori") {
                } else if (widget.master == "menu") {}
              },
              style: const TextStyle(
                  color: Colors.black, fontFamily: "Poppins", fontSize: 14),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(right: 10, top: 8),
                  border: InputBorder.none,
                  hintText: "Cari Data",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins",
                  ),
                  prefixIcon: Icon(Icons.search_rounded),
                  prefixIconColor: Colors.grey),
            ),
          ),
        ),
      ]),
    );
  }
}

// searchTroughList(List<dynamic> data, String master, String searchValue){
//   if(master == "jenis"){
//     temp = data; //simpan data yang sebelumnya terlebih dahulu
//   }
// }

Widget showMenuMerchant(List<MenuMerchantModel> data, BuildContext ctx) {
  if (data.isNotEmpty) {
    return Expanded(child: showMenuMerchantList(data));
  } else {
    return emptyDataWidget(ctx);
  }
}

Widget showMenuMerchantList(List<MenuMerchantModel> data) => ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        var jenisMenu = data[index].nama_jenis_menu != ""
            ? data[index].nama_jenis_menu
            : "-";
        var kategoriMenu = data[index].nama_kategori_menu != ""
            ? data[index].nama_kategori_menu
            : "-";
        var harga = data[index].harga != "" ? data[index].harga : "-";
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                height: 88,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 238, 238, 238)),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(1, 4),
                      )
                    ]),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width * .65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].nama_menu_merchant,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins"),
                          ),
                          Text(
                            Utils().formatCurrency(harga, ""),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins"),
                          ),
                          Text(
                            "Jenis: $jenisMenu",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontFamily: "Poppins"),
                          ),
                          Text(
                            "Kategori: $kategoriMenu",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontFamily: "Poppins"),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.edit_rounded,
                            size: 25,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.delete_rounded,
                            size: 25,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

Widget showKategoriMenu(List<KategoriMenuModel> data, BuildContext ctx) {
  if (data.isNotEmpty) {
    return Expanded(child: kategoriMenuItem(data));
  } else {
    return emptyDataWidget(ctx);
  }
}

Widget kategoriMenuItem(List<KategoriMenuModel> data) => ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        var jenisMenu = data[index].nama_jenis_menu != ""
            ? data[index].nama_jenis_menu
            : "-";
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 238, 238, 238)),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(1, 4),
                      )
                    ]),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width * .65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].nama_kategori_menu,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins"),
                          ),
                          Text(
                            "Jenis: $jenisMenu",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                // fontWeight: FontWeight.w700,
                                fontFamily: "Poppins"),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.edit_rounded,
                            size: 25,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.delete_rounded,
                            size: 25,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

Widget showJenisMenuItem(List<JenisMenuModel> data, BuildContext ctx) {
  if (data.isNotEmpty) {
    return Expanded(child: jenisMenuItem(data));
  } else {
    return emptyDataWidget(ctx);
  }
}

Widget jenisMenuItem(List<JenisMenuModel>? data) => ListView.builder(
      shrinkWrap: true,
      itemCount: data!.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 238, 238, 238)),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(1, 4),
                      )
                    ]),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      width: MediaQuery.of(context).size.width * .65,
                      child: Text(
                        data[index].nama_jenis_menu,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.edit_rounded,
                            size: 25,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.delete_rounded,
                            size: 25,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? colorText;
  final IconData icon;

  const CustomButton(
      {super.key,
      required this.text,
      required this.color,
      required this.icon,
      this.colorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: colorText,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
                color: colorText, fontSize: 12, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
