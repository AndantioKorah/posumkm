import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/transaction/TransactionChooseMenuPage.dart';
import 'package:posumkm/views/transaction/TransactionDetailItem.dart';
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
          title: const Text("TRANSAKSI BARU", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
          // actions: [
          //   Container(
          //     padding: const EdgeInsets.all(10),
          //     child: InkWell(
          //       onTap: () => _refreshMasterMenu().then((value) => {
          //             if (value.code != 200)
          //               {
          //                 httpToastDialog(
          //                     value,
          //                     context,
          //                     ToastGravity.BOTTOM,
          //                     const Duration(seconds: 2),
          //                     const Duration(milliseconds: 100))
          //               }
          //           }),
          //       child: const Icon(
          //         Icons.refresh_rounded,
          //         size: 20,
          //         color: Colors.white,
          //       ),
          //     ),
          //   )
          // ]
        ),
        body: ChangeNotifierProvider(
            create: (context) => MenuMerchantProvider(),
            child: InputTransactionContent()),
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
                widget.callback(widget.listData);
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
  const InputTransactionContent({
    super.key,
  });

  @override
  State<InputTransactionContent> createState() =>
      _InputTransactionContentState();
}

class _InputTransactionContentState extends State<InputTransactionContent> {
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
  }

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
        TransactionDetailitem(
            listDataItem: _listMenuMerchant, selectedDataItem: selectedMenu),
        Container(
          color: Colors.transparent,
          height: double.infinity,
          width: sizeScreen.width * .6,
          child: Column(
            children: [
              // SearchField(
              //     listData: _listMenuMerchant,
              //     searchController: searchController,
              //     callback: _callbackMenuMerchant),
              // LineDividerWidget(
              //   color: Colors.grey.withOpacity(.3),
              //   height: 1,
              // ),
              const SizedBox(
                height: 10,
              ),
              TransactionChooseMenuPage(listData: _listMenuMerchant),
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
