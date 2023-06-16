import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:posumkm/models/MasterMenuModel.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/home_pages/EditMasterMenu.dart';
import 'package:posumkm/views/widget/EmptyDataImageWidget.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../controllers/api/MasterController.dart';
import '../../main.dart';
import '../../models/KategoriMenuModel.dart';
import '../../models/MenuMerchantModel.dart';
import '../widget/HttpToastDialog.dart';

bool _showLoader = true;
bool _jenisMenuEmpty = true;
bool _kategoriMenuEmpty = true;
bool _menuMerchantEmpty = true;
var sprf;
List<JenisMenuModel> _listJenisMenu = [];
List<KategoriMenuModel> _listKategoriMenu = [];
List<MenuMerchantModel> _listMenuMerchant = [];
MasterMenuModel? _masterMenuModel;
TextEditingController searchMenu = TextEditingController();
TextEditingController searchJenis = TextEditingController();
TextEditingController searchKategori = TextEditingController();
int tabIndex = 0;

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  void _callbackJenisMenu(newList) {
    setState(() {
      _showLoader = false;
      if (newList.length > 0) {
        _listJenisMenu = newList;
      } else {
        _listJenisMenu = [];
      }
    });
  }

  void _callbackKategoriMenu(newList) {
    setState(() {
      _showLoader = false;
      if (newList.length > 0) {
        _listKategoriMenu = newList;
      } else {
        _listKategoriMenu = [];
      }
    });
  }

  void _callbackMenuMerchant(newList) {
    setState(() {
      _showLoader = false;
      if (newList.length > 0) {
        _listMenuMerchant = newList;
      } else {
        _listMenuMerchant = [];
      }
    });
  }

  void _callbackRefreshMasterMenu(randomString) {
    _refreshMasterMenu(false);
  }

  Future<HttpResponseModel> _refreshMasterMenu(bool showLoader) async {
    _showLoader = showLoader;
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
      }
    }

    _showLoader = false;
    setState(() {});
    return rs;
  }

  void _changeTabIndex(int val) {
    tabIndex = val;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshMasterMenu(true);
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
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              _changeTabIndex(tabController.index);
            }
          });
          return Scaffold(
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
                      onTap: () => _refreshMasterMenu(true).then((value) => {
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
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  tabs: [
                    Tab(text: "Jenis"),
                    Tab(text: "Kategori"),
                    Tab(text: "Menu"),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                mini: true,
                backgroundColor: theme.colorScheme.onPrimaryContainer,
                clipBehavior: Clip.antiAlias,
                onPressed: () {
                  if (tabIndex == 0) {
                    EditMasterMenu().editDataJenis(
                        null, context, _callbackRefreshMasterMenu);
                  } else if (tabIndex == 1) {
                    EditMasterMenu().editDataKategori(null, _listJenisMenu,
                        context, _callbackRefreshMasterMenu);
                  }
                },
                child: const Icon(
                  FontAwesomeIcons.squarePlus,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              body: TabBarView(
                children: [
                  ListView(
                    children: [
                      SearchField(
                        list: _listJenisMenu,
                        master: "jenis",
                        searchController: searchJenis,
                        callback: _callbackJenisMenu,
                      ),
                      const Divider(
                          height: 20, thickness: 1, color: Colors.white),
                      Row(
                        children: [
                          _showLoader
                              ? loadingDataWidget(context)
                              : _listJenisMenu.isNotEmpty
                                  ? ShowJenisMenuItem(
                                      data: _listJenisMenu,
                                      callbackFunction:
                                          _callbackRefreshMasterMenu,
                                    )
                                  : emptyDataWidget(context),
                          // FloatingActionButton(
                          //   onPressed: () => print("haii")
                          // )
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
                        callback: _callbackKategoriMenu,
                      ),
                      const Divider(
                          height: 20, thickness: 1, color: Colors.white),
                      Row(
                        children: [
                          _showLoader
                              ? loadingDataWidget(context)
                              : showKategoriMenu(_listKategoriMenu, context,
                                  _callbackRefreshMasterMenu)
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
                        callback: _callbackMenuMerchant,
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
              ));
        }),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchField extends StatefulWidget {
  TextEditingController searchController;
  List<dynamic> list;
  String master;
  final Function callback;

  SearchField(
      {required this.list,
      required this.master,
      required this.searchController,
      required this.callback,
      super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
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
                // ignore: unrelated_type_equality_checks
                if (widget.master == "jenis") {
                  List<JenisMenuModel> tempJenisMenu = [];
                  if (searchValue.isNotEmpty) {
                    _masterMenuModel!.listJenisMenu.forEach((rs) {
                      if (rs.nama_jenis_menu
                          .toLowerCase()
                          .contains(searchValue.toLowerCase().toString())) {
                        tempJenisMenu.add(rs);
                        widget.list = tempJenisMenu;
                      }

                      if (tempJenisMenu.isEmpty) {
                        widget.list = [];
                      }
                    });
                  } else {
                    widget.list = _masterMenuModel!.listJenisMenu;
                  }
                  widget.callback(widget.list);
                } else if (widget.master == "kategori") {
                  List<KategoriMenuModel> tempKategoriMenu = [];
                  if (searchValue.isNotEmpty) {
                    _masterMenuModel!.listKategoriMenu.forEach((rs) {
                      if (rs.nama_jenis_menu
                              .toLowerCase()
                              .contains(searchValue.toLowerCase().toString()) ||
                          rs.nama_kategori_menu
                              .toLowerCase()
                              .contains(searchValue.toLowerCase().toString())) {
                        tempKategoriMenu.add(rs);
                        widget.list = tempKategoriMenu;
                      }

                      if (tempKategoriMenu.isEmpty) {
                        widget.list = [];
                      }
                    });
                  } else {
                    widget.list = _masterMenuModel!.listKategoriMenu;
                  }
                  widget.callback(widget.list);
                } else if (widget.master == "menu") {
                  List<MenuMerchantModel> tempMenuMerchant = [];
                  if (searchValue.isNotEmpty) {
                    _masterMenuModel!.listMenuMerchant.forEach((rs) {
                      if (rs.nama_jenis_menu
                              .toLowerCase()
                              .contains(searchValue.toLowerCase().toString()) ||
                          rs.nama_kategori_menu
                              .toLowerCase()
                              .contains(searchValue.toLowerCase().toString()) ||
                          rs.nama_menu_merchant
                              .toLowerCase()
                              .contains(searchValue.toLowerCase().toString()) ||
                          rs.harga
                              .toLowerCase()
                              .contains(searchValue.toLowerCase().toString())) {
                        tempMenuMerchant.add(rs);
                        widget.list = tempMenuMerchant;
                      }

                      if (tempMenuMerchant.isEmpty) {
                        widget.list = [];
                      }
                    });
                  } else {
                    widget.list = _masterMenuModel!.listMenuMerchant;
                  }
                  widget.callback(widget.list);
                }
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
                            size: 20,
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
                            size: 20,
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

Widget showKategoriMenu(
    List<KategoriMenuModel> data, BuildContext ctx, Function callbackFunction) {
  RoundedLoadingButtonController _btnDeleteController =
      RoundedLoadingButtonController();
  if (data.isNotEmpty) {
    return Expanded(
        child: kategoriMenuItem(data, callbackFunction, _btnDeleteController));
  } else {
    return emptyDataWidget(ctx);
  }
}

Widget kategoriMenuItem(List<KategoriMenuModel> data, Function callbackFunction,
        RoundedLoadingButtonController _btnDeleteController) =>
    ListView.builder(
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
                          onTap: () {
                            EditMasterMenu().editDataKategori(data[index],
                                _listJenisMenu, context, callbackFunction);
                          },
                          child: Icon(
                            Icons.edit_rounded,
                            size: 20,
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
                          onTap: () => {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              animType: AnimType.TOPSLIDE,
                              title: "Hapus Data",
                              desc:
                                  "Apakah Anda yakin ingin menghapus data ini?",
                              showCloseIcon: true,
                              btnOk: RoundedLoadingButton(
                                  height: 40,
                                  color: Colors.red[900],
                                  controller: _btnDeleteController,
                                  onPressed: () {
                                    MasterController.deleteMasterKategori(
                                            data[index].id)
                                        .then((value) {
                                      httpToastDialog(
                                          value,
                                          context,
                                          ToastGravity.BOTTOM,
                                          const Duration(seconds: 3),
                                          const Duration(seconds: 3));
                                      if (value.code == 200) {
                                        Navigator.pop(context);
                                        callbackFunction("");
                                      }
                                      _btnDeleteController.reset();
                                    });
                                  },
                                  child: const Text("Hapus",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                              // btnOkText: "Tutup",
                              // btnOkColor: Colors.red,
                            ).show()
                          },
                          child: Icon(
                            Icons.delete_rounded,
                            size: 20,
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

// ignore: must_be_immutable
class ShowJenisMenuItem extends StatefulWidget {
  List<JenisMenuModel> data;
  Function callbackFunction;

  ShowJenisMenuItem(
      {super.key, required this.data, required this.callbackFunction});

  @override
  State<ShowJenisMenuItem> createState() => _ShowJenisMenuItemState();
}

class _ShowJenisMenuItemState extends State<ShowJenisMenuItem> {
  final RoundedLoadingButtonController _btnDeleteController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return emptyDataWidget(context);
    } else {
      return Expanded(
          child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.data.length,
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
                          offset: const Offset(1, 4),
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
                          widget.data[index].nama_jenis_menu,
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
                            onTap: () {
                              EditMasterMenu().editDataJenis(widget.data[index],
                                  context, widget.callbackFunction);
                            },
                            // onTap: (){
                            //   widget.callbackFunction("haii");
                            // },
                            child: Icon(
                              Icons.edit_rounded,
                              size: 20,
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
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.QUESTION,
                                animType: AnimType.TOPSLIDE,
                                title: "Hapus Data",
                                desc:
                                    "Apakah Anda yakin ingin menghapus data ini?",
                                showCloseIcon: true,
                                btnOk: RoundedLoadingButton(
                                    height: 40,
                                    color: Colors.red[900],
                                    controller: _btnDeleteController,
                                    onPressed: () {
                                      MasterController.deleteMasterJenis(
                                              widget.data[index].id)
                                          .then((value) {
                                        httpToastDialog(
                                            value,
                                            context,
                                            ToastGravity.BOTTOM,
                                            const Duration(seconds: 3),
                                            const Duration(seconds: 3));
                                        if (value.code == 200) {
                                          Navigator.pop(context);
                                          widget.callbackFunction("");
                                        }
                                        _btnDeleteController.reset();
                                      });
                                    },
                                    child: const Text("Hapus",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                // btnOkText: "Tutup",
                                // btnOkColor: Colors.red,
                              ).show();
                            },
                            child: Icon(
                              Icons.delete_rounded,
                              size: 20,
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
      ));
    }
  }
}

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
