import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../controllers/api/MasterController.dart';
import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../../models/JenisMenuModel.dart';
import '../../models/KategoriMenuModel.dart';
import '../../models/MasterMenuModel.dart';
import '../../models/MenuMerchantModel.dart';
import '../../providers/MenuMerchantProvider.dart';
import '../widget/HttpToastDialog.dart';
import '../widget/Redicrect.dart';

var menuMerchantProvider;
var selectedMenu;
List<JenisMenuModel> _listJenisMenu = [];
List<KategoriMenuModel> _listKategoriMenu = [];
List<MenuMerchantModel> _listMenuMerchant = [];
late MasterMenuModel _masterMenuModel;

class InputTransactionPage extends StatefulWidget {
  const InputTransactionPage({super.key});

  @override
  State<InputTransactionPage> createState() => _InputTransactionState();
}

class _InputTransactionState extends State<InputTransactionPage> {
  bool _isRedirectLogout = false;
  String _messageRedirect = "";

  void _callbackMenuMerchant(newList) {
    setState(() {
      if (newList.length > 0) {
        _listMenuMerchant = newList;
      } else {
        _listMenuMerchant = [];
      }
    });
  }

  Future<HttpResponseModel> _refreshMasterMenu() async {
    setState(() {});
    HttpResponseModel rs = await MasterController.getAllMasterMenu();

    // ignore: unnecessary_null_comparison
    if (rs != null) {
      if (rs.code == 200) {
        _masterMenuModel = rs.data;
        _listJenisMenu = _masterMenuModel.listJenisMenu;
        _listKategoriMenu = _masterMenuModel.listKategoriMenu;
        _listMenuMerchant = _masterMenuModel.listMenuMerchant;
        _isRedirectLogout = false;
      } else if (rs.code == 302) {
        _isRedirectLogout = true;
        _messageRedirect = rs.message!;
        redirectLogout(context, _messageRedirect);
      }
    }
    setState(() {});
    return rs;
  }

  @override
  void initState() {
    super.initState();
    _refreshMasterMenu();
    // menuMerchantProvider = Provider.of<MenuMerchantProvider>(context);
    // selectedMenu = menuMerchantProvider.getListSelected;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                // onPressed: () => Navigator.of(context).pop()
                onPressed: () {
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          animType: AnimType.TOPSLIDE,
                          title: "Semua perubahan tidak akan tersimpan",
                          desc: "Apakah Anda yakin ingin tetap melanjutkan?",
                          showCloseIcon: true,
                          // btnOkText: "Tutup",
                          // btnOkColor: Colors.red,
                          btnOkOnPress: () => Navigator.of(context).pop(),
                          btnOkText: "Lanjutkan",
                          btnOkColor: Colors.green[900],
                          btnCancelOnPress: () {},
                          btnCancelColor: Colors.red[900])
                      .show();
                }),
            backgroundColor: theme.colorScheme.onPrimaryContainer,
            title:
                const Text("TRANSAKSI BARU", style: BaseTextStyle.appBarTitle),
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
            ]),
        body: ChangeNotifierProvider(
            create: (context) => MenuMerchantProvider(),
            child: InputTransactionContent(
              listData: _listMenuMerchant,
              callback: _callbackMenuMerchant,
            )),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  TextEditingController searchController;
  List<dynamic> listData;
  final Function callback;

  SearchField(
      {required this.listData,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    offset: const Offset(1, 4),
                  )
                ]),
            child: TextField(
              controller: widget.searchController,
              onChanged: (searchValue) {
                print(searchValue);
                List<MenuMerchantModel> tempMenuMerchant = [];
                if (searchValue.isNotEmpty) {
                  _masterMenuModel.listMenuMerchant.forEach((rs) {
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
                      widget.listData = tempMenuMerchant;
                    }

                    if (tempMenuMerchant.isEmpty) {
                      widget.listData = [];
                    }
                  });
                } else {
                  widget.listData = _masterMenuModel.listMenuMerchant;
                }
                // widget.callback(widget.listData);
              },
              style: const TextStyle(
                  color: Colors.black, fontFamily: "Poppins", fontSize: 14),
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      widget.searchController.clear();
                    },
                    child: const Icon(
                      Icons.cancel_rounded,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(right: 10, top: 8),
                  border: InputBorder.none,
                  hintText: "Cari Menu",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins",
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  prefixIconColor: Colors.grey),
            ),
          ),
        ),
      ]),
    );
  }
}

// ignore: must_be_immutable
class InputTransactionContent extends StatefulWidget {
  List<MenuMerchantModel> listData = [];
  Function callback;

  InputTransactionContent(
      {super.key, required this.listData, required this.callback});

  @override
  State<InputTransactionContent> createState() =>
      _InputTransactionContentState();
}

class _InputTransactionContentState extends State<InputTransactionContent> {
  @override
  Widget build(BuildContext context) {
    menuMerchantProvider = Provider.of<MenuMerchantProvider>(context);
    selectedMenu = menuMerchantProvider.getListSelected;
    // menuMerchantProvider.setListMenu(listData);
    var theme = Theme.of(context);
    var sizeScreen = MediaQuery.of(context).size;
    TextEditingController searchController = TextEditingController();
    return SafeArea(
        child: Row(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: sizeScreen.width * .4,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(4, 0),
                    )
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blueGrey,
                        theme.colorScheme.onPrimaryContainer,
                      ])),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TextField(
                      // autofocus: true,
                      style: TrxTxtStyle.valTxtField,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        labelText: "Nama",
                        labelStyle: TrxTxtStyle.lblTxtField,
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white)),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(100, 255, 255, 255))),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 10),
                    child: TextField(
                      // autofocus: true,
                      style: TrxTxtStyle.valTxtField,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        labelText: "Tgl. Transaksi",
                        labelStyle: TrxTxtStyle.lblTxtField,
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white)),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(100, 255, 255, 255))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.transparent.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.3),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(1, 4),
                                  )
                                ]),
                            child: Column(
                              children: [
                                const Text(
                                  "List Item:",
                                  style: TrxTxtStyle.totTagihanText,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Table(
                                  children: [
                                    TableRow(children: [
                                      Column(
                                        children: [
                                          for (var i = 0;
                                              i < widget.listData.length;
                                              i++) ...{
                                            if (selectedMenu.containsKey(
                                                widget.listData[i].id)) ...{
                                              rowItemDetail(
                                                  context,
                                                  selectedMenu[
                                                      widget.listData[i].id]!)
                                            }
                                          }
                                        ],
                                      )
                                    ])
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: sizeScreen.width * .4,
                  child: Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        // height: 30,
                        decoration: BoxDecoration(
                            color: Colors.green[900],
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(1),
                                  offset: const Offset(0, 0),
                                  spreadRadius: 1,
                                  blurRadius: 100)
                            ]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total:",
                                    style: TrxTxtStyle.totTagihanText,
                                  ),
                                  Text(
                                    menuMerchantProvider.getTotalTransaksi() > 0
                                        ? Utils().formatCurrency(
                                            menuMerchantProvider
                                                .getTotalTransaksi()
                                                .toString(),
                                            "")
                                        : "Rp 0",
                                    style: TrxTxtStyle.totTagihanVal,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              FontAwesomeIcons.circleChevronRight,
                              color: Colors.white,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.transparent,
          height: double.infinity,
          width: sizeScreen.width * .6,
          child: Stack(
            children: [
              Column(
                children: [
                  // SearchField(
                  //   listData: widget.listData,
                  //   searchController: searchController,
                  //   callback: widget.callback),
                  LineDividerWidget(
                    color: Colors.grey.withOpacity(.3),
                    height: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.listData.length,
                          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisCount: 2,
                          //   mainAxisSpacing: 5,
                          //   crossAxisSpacing: 20,
                          //   childAspectRatio: 1.2),
                          itemBuilder: (context, index) => Wrap(
                                children: [
                                  Container(
                                    // height: 200,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(.3),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(1, 4),
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.listData[index]
                                                      .nama_menu_merchant,
                                                  style: TrxTxtStyle.nmMenuText,
                                                ),
                                                Text(
                                                  Utils().formatCurrency(
                                                      widget.listData[index]
                                                          .harga,
                                                      "nonSymbol"),
                                                  style: TrxTxtStyle.hargaText,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: 65,
                                                  // color: Colors.amber,
                                                  // padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          menuMerchantProvider
                                                              .removeMenu(widget
                                                                      .listData[
                                                                  index]);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  width: 2)),
                                                          child: const Icon(
                                                            FontAwesomeIcons
                                                                .minus,
                                                            color:
                                                                Colors.blueGrey,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        selectedMenu.containsKey(
                                                                widget
                                                                    .listData[
                                                                        index]
                                                                    .id)
                                                            ? selectedMenu[widget
                                                                    .listData[
                                                                        index]
                                                                    .id]!
                                                                .selectedCount
                                                                .toString()
                                                            : "0",
                                                        style: selectedMenu
                                                                .containsKey(widget
                                                                    .listData[
                                                                        index]
                                                                    .id)
                                                            ? TrxTxtStyle
                                                                .qtyText
                                                            : TrxTxtStyle
                                                                .qtyTextZero,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          menuMerchantProvider
                                                              .addMenu(widget
                                                                      .listData[
                                                                  index]);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  width: 2)),
                                                          child: const Icon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                            color:
                                                                Colors.blueGrey,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        LineDividerWidget(
                                          color: Colors.grey.withOpacity(.3),
                                          height: 1,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          // color: Colors.amber,
                                          // padding: const EdgeInsets.symmetric(vertical: 3),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // const Text("Total: ", style: TrxTxtStyle.lblTotal, textAlign: TextAlign.end),
                                              SizedBox(
                                                // width: 60,
                                                child: Text(
                                                  // selectedMenu.containsKey(listData[index].id) ? selectedMenu[listData[index].id]!.selectedCount.toString()
                                                  selectedMenu.containsKey(
                                                          widget.listData[index]
                                                              .id)
                                                      ? Utils().formatCurrency(
                                                          (selectedMenu[widget
                                                                          .listData[
                                                                              index]
                                                                          .id]!
                                                                      .selectedCount *
                                                                  int.parse(selectedMenu[widget
                                                                          .listData[
                                                                              index]
                                                                          .id]!
                                                                      .harga))
                                                              .toString(),
                                                          "nonSymbol")
                                                      : "0",
                                                  style: selectedMenu
                                                          .containsKey(widget
                                                              .listData[index]
                                                              .id)
                                                      ? TrxTxtStyle.valTotal
                                                      : TrxTxtStyle
                                                          .valTotalZero,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  ),
                  const SizedBox(
                    height: 65,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

Widget rowItemDetail(BuildContext context, MenuMerchantModel item) => Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.transparent,
                    width: constraints.maxWidth * .65,
                    // child: Text(namaMenu, style: TrxTxtStyle.lblDetailItem,),
                    child: Text(
                      item.nama_menu_merchant,
                      style: TrxTxtStyle.lblDetailItem,
                    ),
                  ),
                  // Text(Utils().formatCurrency(totalHarga, "nonSymbol"),
                  Text(
                    Utils().formatCurrency(
                        (int.parse(item.harga) * item.selectedCount).toString(),
                        "nonSymbol"),
                    style: TrxTxtStyle.lblTotDetailItem,
                  )
                ],
              );
            },
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.selectedCount.toString()}  x ${Utils().formatCurrency(item.harga, "nonSymbol")}",
                style: TrxTxtStyle.lblHrgSatuanItem,
              ),
              InkWell(
                onTap: () {
                  menuMerchantProvider.removeSelectedMenu(item);
                },
                child: const Icon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.red,
                  size: 12,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          LineDividerWidget(
            color: Colors.grey.withOpacity(.3),
          )
        ],
      ),
    );

class TrxTxtStyle {
  static var lblTxtField = TextStyle(
    fontSize: 12,
    color: Colors.grey[400],
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins",
  );

  static const valTxtField = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins",
  );

  static const nmMenuText = TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      overflow: TextOverflow.ellipsis);

  static const hargaText = TextStyle(
    fontFamily: "Poppins",
    fontSize: 13,
    color: Colors.black,
    // fontWeight: FontWeight.bold
  );

  static var qtyTextZero = TextStyle(
      fontSize: 14,
      // color: Colors.black,
      color: const Color.fromARGB(255, 158, 158, 158).withOpacity(.4),
      fontWeight: FontWeight.bold);

  static const qtyText =
      TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);

  static const addBtn =
      TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);

  static const lblTotal = TextStyle(
      fontSize: 12,
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static final valTotalZero = TextStyle(
      fontFamily: "Poppins",
      fontSize: 12,
      color: const Color.fromARGB(255, 158, 158, 158).withOpacity(.4),
      fontWeight: FontWeight.bold);

  static const valTotal = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const lblBtnTotal = TextStyle(
      fontSize: 14,
      color: Colors.white,
      // fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valBtnTotal = TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const totTagihanText = TextStyle(
    fontFamily: "Poppins",
    fontSize: 10,
    color: Colors.white,
    // fontWeight: FontWeight.bold
  );

  static const lblDetailItem = TextStyle(
    // fontFamily: "Poppins",
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const lblHrgSatuanItem = TextStyle(
    // fontFamily: "Poppins",
    fontSize: 10,
    color: Color.fromARGB(255, 154, 183, 198),
    fontWeight: FontWeight.bold,
  );

  static const lblTotDetailItem = TextStyle(
    // fontFamily: "Poppins",
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const totTagihanVal = TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold);
}
