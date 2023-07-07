import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/controllers/api/TransactionController.dart';
import 'package:posumkm/models/TransactionDetailModel.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/transaction/TransactionChooseMenuPage.dart';
import 'package:posumkm/views/transaction/TransactionDetailItem.dart';
import 'package:posumkm/views/widget/HttpToastDialog.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../../models/MenuMerchantModel.dart';
import '../../models/TransactionModel.dart';
import '../../providers/MenuMerchantProvider.dart';
import '../widget/Redicrect.dart';

var selectedMenu;
var menuMerchantProvider;

// ignore: must_be_immutable
class InputTransactionPage extends StatefulWidget {
  String idTransaksi;
  InputTransactionPage({super.key, required this.idTransaksi});

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
                color: AppsColor.alternativeWhite,
              ),
              // onPressed: () => Navigator.of(context).pop()
              onPressed: () {
                if (selectedMenu.length > 0) {
                  Navigator.of(context).pop();
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.TOPSLIDE,
                    title: "Semua perubahan tidak akan tersimpan",
                    desc: "Apakah Anda yakin ingin tetap melanjutkan?",
                    showCloseIcon: true,
                    // btnOkText: "Tutup",
                    // btnOkColor: Colors.red,
                    btnOkOnPress: () {
                      Navigator.of(context).pop();
                    },
                    btnOkText: "Lanjutkan",
                    btnOkColor: Colors.green[900],
                    btnCancelOnPress: () {},
                    btnCancelColor: Colors.red[900],
                  ).show();
                }
              }),
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          title: const Text("TRANSAKSI BARU", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
            create: (context) => MenuMerchantProvider(),
            child: InputTransactionContent(idTransaksi: widget.idTransaksi,))
      ),
    );
  }
}

// ignore: must_be_immutable
class InputTransactionContent extends StatefulWidget {
  String? idTransaksi;
  InputTransactionContent({super.key, this.idTransaksi});

  @override
  State<InputTransactionContent> createState() => _InputTransactionContentState();
}

class _InputTransactionContentState extends State<InputTransactionContent> {
  bool _showLoader = true;
  String _messageRedirect = "";
  List<MenuMerchantModel> _listMenuMerchant = [];
  late TransactionModel _transaksi = TransactionModel.setNull();
  List<TransactionDetailModel> _listDetailTransaksi = [];
  late HttpResponseModel rs;

  Future<void> _getDetailTransaction() async {
    rs = await TransactionController.getTransactionDetail(widget.idTransaksi!);
    // ignore: unnecessary_null_comparison
    if (rs != null) {
      if (rs.code == 200) {
        if(rs.data['transaksi'].containsKey("id")){
          _transaksi = TransactionModel.fromJson(rs.data['transaksi']);
          _listDetailTransaksi = _transaksi.detail;
        }
        _listMenuMerchant = convertToListMenuMerchant(rs.data['list_menu']);
      } else if (rs.code == 302) {
        _messageRedirect = rs.message!;
        // ignore: use_build_context_synchronously
        redirectLogout(context, _messageRedirect);
      } else {
        // ignore: use_build_context_synchronously
        httpToastDialog(
          rs,
          context,
          ToastGravity.BOTTOM,
          const Duration(seconds: 2),
          const Duration(seconds: 2)
        );
      }
    }
    setState(() {
      _showLoader = false;
    }); 
  }

  @override
  void initState() {
    super.initState();
    _getDetailTransaction();
  }

  @override
  Widget build(BuildContext context) {
    if(!_showLoader){
      menuMerchantProvider = Provider.of<MenuMerchantProvider>(context, listen: false);
      if(_listDetailTransaksi.isNotEmpty){
        menuMerchantProvider.setListDataFromWs(_listDetailTransaksi);
      }
      selectedMenu = menuMerchantProvider.getListSelected;
    }
    var sizeScreen = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, value, child){
        return SafeArea(
        child: Row(
      children: [
        if(_showLoader)...{
          loadingDataWidget(context)
        } else...{
          TransactionDetailitem(
            listDataItem: _listMenuMerchant, transaksi: _transaksi,),
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
                TransactionChooseMenuPage(listData: _listMenuMerchant, callback: _getDetailTransaction,),
              ],
            ),
          ),
        }
      ],
    ));
      });
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
    color: AppsColor.alternativeWhite,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins",
  );

  static const nmMenuText = TextStyle(
      fontSize: 15,
      color: AppsColor.alternativeBlack,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins",
      overflow: TextOverflow.ellipsis);

  static const hargaText = TextStyle(
    fontFamily: "Poppins",
    fontSize: 13,
    color: AppsColor.alternativeBlack,
    // fontWeight: FontWeight.bold
  );

  static var qtyTextZero = TextStyle(
      fontSize: 14,
      // color: AppsColor.alternativeBlack,
      color: const Color.fromARGB(255, 158, 158, 158).withOpacity(.4),
      fontWeight: FontWeight.bold);

  static const qtyText = TextStyle(
      fontSize: 14,
      color: AppsColor.alternativeBlack,
      fontWeight: FontWeight.bold);

  static const addBtn = TextStyle(
      fontSize: 14,
      color: AppsColor.alternativeWhite,
      fontWeight: FontWeight.bold);

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
      color: AppsColor.alternativeBlack,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const lblBtnTotal = TextStyle(
      fontSize: 14,
      color: AppsColor.alternativeWhite,
      // fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valBtnTotal = TextStyle(
      fontSize: 15,
      color: AppsColor.alternativeWhite,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const totTagihanText = TextStyle(
    fontFamily: "Poppins",
    fontSize: 10,
    color: AppsColor.alternativeWhite,
    // fontWeight: FontWeight.bold
  );

  static const lblDetailItem = TextStyle(
    // fontFamily: "Poppins",
    fontSize: 10,
    color: AppsColor.alternativeWhite,
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
    color: AppsColor.alternativeWhite,
    fontWeight: FontWeight.bold,
  );

  static const totTagihanVal = TextStyle(
      fontFamily: "Poppins",
      fontSize: 16,
      color: AppsColor.alternativeWhite,
      fontWeight: FontWeight.bold);
}
