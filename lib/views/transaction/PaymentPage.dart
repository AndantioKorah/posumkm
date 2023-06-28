import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/controllers/api/TransactionController.dart';
import 'package:posumkm/models/PembayaranModel.dart';
import 'package:posumkm/models/TransactionDetailModel.dart';
import 'package:posumkm/models/TransactionModel.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:toast/toast.dart';

import '../../controllers/api/UserController.dart';
import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../widget/HttpToastDialog.dart';
import '../widget/Redicrect.dart';
import 'InputTransactionPage.dart';

late PembayaranModel pembayaranModel;
late TransactionModel transactionModel;
List<TransactionDetailModel> transactionDetailModel = [];

// ignore: must_be_immutable
class PaymentPage extends StatefulWidget {
  String id;
  var selectedMenu;
  PaymentPage({super.key, required this.id, this.selectedMenu});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _messageRedirect = "";
  bool _showLoader = true;
  int selectedJenisPembayaran = 1;
  TextEditingController namaPembayarController = TextEditingController();
  TextEditingController totalPembayaranController = TextEditingController();
  TextEditingController tanggalPembayaranController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? datePicked;
  TimeOfDay? timePicked;
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  RoundedLoadingButtonController btnPayController =
      RoundedLoadingButtonController();

  Future<void> _selectDate(BuildContext context) async {
    datePicked = await showDatePicker(
        confirmText: "Lanjut",
        cancelText: "Batal",
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (datePicked != null) {
      setState(() {
        selectedDate = datePicked!;
      });
      // ignore: use_build_context_synchronously
      timePicked =
          await showTimePicker(context: context, initialTime: selectedTime);
      if (timePicked != null) {
        setState(() {
          selectedTime = timePicked!;
          selectedDate = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, timePicked!.hour, timePicked!.minute);
          tanggalPembayaranController.text =
              Utils().formatDate(selectedDate.toString(), "/");
        });
      }
    }
  }

  Future<HttpResponseModel> _getPembayaranDetail() async {
    setState(() {});
    HttpResponseModel rs =
        await TransactionController.getPembayaranDetail(widget.id);

    // ignore: unnecessary_null_comparison
    if (rs != null) {
      if (rs.code == 200) {
        if (rs.data['pembayaran'] != null) {
          pembayaranModel = PembayaranModel.fromJson(rs.data['pembayaran']);
        }
        transactionModel = TransactionModel.fromJson(rs.data['transaksi']);
        transactionDetailModel = transactionModel.detail;
        namaPembayarController.text = transactionModel.nama;
        totalPembayaranController.text = transactionModel.total_harga;
      } else if (rs.code == 302) {
        _messageRedirect = rs.message!;
        // ignore: use_build_context_synchronously
        redirectLogout(context, _messageRedirect);
      }
    }
    setState(() {
      _showLoader = false;
    });
    return rs;
  }

  @override
  void initState() {
    super.initState();
    _getPembayaranDetail();
    selectedDate = DateTime.parse(transactionModel.tanggal_transaksi);
    tanggalPembayaranController.text =
        Utils().formatDate(selectedDate.toString(), "/");
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sizeScreen = MediaQuery.of(context);

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
                Navigator.of(context).pop();
              }),
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          title: const Text("PEMBAYARAN", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
        ),
        body: _showLoader
            ? loadingDataWidget(context)
            : SafeArea(
                child: Stack(children: [
                Container(
                  height: sizeScreen.size.height * .2,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimaryContainer,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      )),
                ),
                SingleChildScrollView(
                  child: Container(
                    // height: 100,
                    margin: EdgeInsets.only(top: sizeScreen.size.height * .05),
                    child: Column(children: [
                      Center(
                        child: Wrap(
                          children: [
                            Container(
                              width: sizeScreen.size.width * .8,
                              // height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(1, 4),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                        color: Colors.grey.withOpacity(.5))
                                  ]),
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              // width: constraints.maxWidth * .7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transactionModel
                                                        .nomor_transaksi,
                                                    style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    transactionModel.nama,
                                                    style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 15,
                                                        color: Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    Utils().formatDate(
                                                        transactionModel
                                                            .tanggal_transaksi,
                                                        "/"),
                                                    style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 15,
                                                        color: Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // width: constraints.maxWidth * .25,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: transactionModel
                                                              .status_transaksi ==
                                                          "Belum Lunas"
                                                      ? Colors.red[900]
                                                      : Colors.green[900],
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                transactionModel
                                                    .status_transaksi,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins",
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey.withOpacity(.3),
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: LayoutBuilder(
                                          builder: (BuildContext context,
                                              BoxConstraints constraints) {
                                            return Column(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "List Item",
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                for (var i = 0;
                                                    i <
                                                        transactionDetailModel
                                                            .length;
                                                    i++) ...{
                                                  listItemWidget(
                                                      constraints,
                                                      transactionDetailModel[
                                                          i]),
                                                }
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey.withOpacity(.3),
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Total",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Poppins"),
                                              ),
                                              Text(
                                                  Utils().formatCurrency(
                                                      transactionModel
                                                          .total_harga,
                                                      "symbolOnLeft"),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Poppins"))
                                            ]),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        // width: sizeScreen.size.width * .8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(1, 4),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  color: Colors.grey.withOpacity(.5))
                            ]),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              const Text("Detail Pembayaran",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                focusColor: Colors.blueGrey,
                                isExpanded: true,
                                value: selectedJenisPembayaran,
                                icon: Icon(
                                  FontAwesomeIcons.chevronDown,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  size: 12,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Jenis Pembayaran",
                                  labelStyle: PaymentTextStyle.lblTxtField,
                                  focusColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  border: const OutlineInputBorder(),
                                ),
                                // items: listKategoriMenu.map((var item) {
                                //   return DropdownMenuItem(
                                //     value: item,
                                //     child: Text(item.nama_kategori_menu,
                                //         style: styleText.labelDropDownItem),
                                //   );
                                // }).toList(),
                                items: const [
                                  DropdownMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Tunai",
                                        style: PaymentTextStyle.itemDropDown,
                                      )),
                                  DropdownMenuItem(
                                      value: 2,
                                      child: Text(
                                        "Transfer",
                                        style: PaymentTextStyle.itemDropDown,
                                      )),
                                  DropdownMenuItem(
                                      value: 3,
                                      child: Text(
                                        "QRIS",
                                        style: PaymentTextStyle.itemDropDown,
                                      )),
                                  DropdownMenuItem(
                                      value: 4,
                                      child: Text(
                                        "Credit / Debit Card",
                                        style: PaymentTextStyle.itemDropDown,
                                      )),
                                  DropdownMenuItem(
                                      value: 5,
                                      child: Text(
                                        "ShopeePay",
                                        style: PaymentTextStyle.itemDropDown,
                                      )),
                                  DropdownMenuItem(
                                      value: 6,
                                      child: Text(
                                        "Lainnya",
                                        style: PaymentTextStyle.itemDropDown,
                                      )),
                                ],
                                onChanged: (selected) {
                                  setState(() {
                                    selectedJenisPembayaran = selected!;
                                  });
                                  print(selectedJenisPembayaran);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: namaPembayarController,
                                // autofocus: true,
                                style: PaymentTextStyle.valTxtField,
                                cursorColor:
                                    theme.colorScheme.onPrimaryContainer,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  labelText: "Nama Pembayar",
                                  labelStyle: PaymentTextStyle.lblTxtField,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: theme
                                              .colorScheme.onPrimaryContainer)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: theme
                                              .colorScheme.onPrimaryContainer)),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: totalPembayaranController,
                                // autofocus: true,
                                style: PaymentTextStyle.valTxtField,
                                keyboardType: TextInputType.number,
                                cursorColor:
                                    theme.colorScheme.onPrimaryContainer,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  labelText: "Total Pembayaran",
                                  labelStyle: PaymentTextStyle.lblTxtField,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: theme
                                              .colorScheme.onPrimaryContainer)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: theme
                                              .colorScheme.onPrimaryContainer)),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  // height: 40,
                                  // margin: const EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: tanggalPembayaranController,
                                    enabled: false,
                                    // autofocus: true,
                                    style: PaymentTextStyle.valTxtField,
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                      labelText: "Tanggal Pembayaran",
                                      labelStyle: PaymentTextStyle.lblTxtField,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: theme.colorScheme
                                                  .onPrimaryContainer)),
                                      border: const OutlineInputBorder(),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: theme.colorScheme
                                                  .onPrimaryContainer)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: theme.colorScheme
                                                  .onPrimaryContainer)),
                                      // color: Color.fromARGB(100, 255, 255, 255))),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              RoundedLoadingButton(
                                controller: btnPayController,
                                onPressed: () async {
                                  await Future.delayed(
                                      const Duration(seconds: 3));
                                  btnPayController.reset();
                                },
                                color: theme.colorScheme.onPrimaryContainer,
                                borderRadius: 5,
                                child: Container(
                                  width: double.infinity,
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                )
              ])),
      ),
    );
  }
}

Widget listItemWidget(
        BoxConstraints constraints, TransactionDetailModel item) =>
    Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: constraints.maxWidth * .7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.nama_menu_merchant,
                  style: PaymentTextStyle.tableItem,
                ),
                Text(
                  "${item.qty} x ${Utils().formatCurrency(item.harga, "nonSymbol")}",
                  style: PaymentTextStyle.tableItemSmall,
                ),
              ],
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * .2,
            child: Text(
              Utils().formatCurrency(
                  (int.parse(item.harga) * int.parse(item.qty)).toString(),
                  "nonSymbol"),
              style: PaymentTextStyle.tableItem,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );

class PaymentTextStyle {
  static final tableHeader = TextStyle(
      color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.normal);

  static const tableItem = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const tableItemSmall = TextStyle(
      color: Colors.blueGrey,
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const itemDropDown = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const lblTxtField = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valTxtField = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");
}

void showPaymentDialog(BuildContext context) {
  var theme = Theme.of(context);

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();
  final RoundedLoadingButtonController buttonSumbit =
      RoundedLoadingButtonController();

  AwesomeDialog(
    context: context,
    animType: AnimType.BOTTOMSLIDE,
    dialogType: DialogType.NO_HEADER,
    // showCloseIcon: true,
    autoDismiss: false,
    onDissmissCallback: (_) {},
    body: Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Stack(
              children: [
                Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold),
                    child: Text("GANTI PASSWORD"),
                  ),
                ),
                Positioned(
                    right: 15,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: Colors.black,
                      ),
                    ))
              ],
            )),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Password Lama',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.lock_clock_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: oldPassword,
                ),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Password Baru',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: newPassword,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Konfirmasi Password Baru',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: confirmNewPassword,
                ),
              ),
            ),
          ],
        )
      ],
    ),
    btnOk: SizedBox(
      width: double.infinity,
      child: RoundedLoadingButton(
          height: 45,
          color: theme.colorScheme.onPrimaryContainer,
          controller: buttonSumbit,
          resetDuration: const Duration(seconds: 3),
          resetAfterDuration: true,
          child: const Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => {
                UserController.changePasswordFunction(oldPassword.text,
                        newPassword.text, confirmNewPassword.text)
                    .then((value) => {
                          oldPassword.clear(),
                          newPassword.clear(),
                          confirmNewPassword.clear(),
                          httpToastDialog(
                              value,
                              context,
                              ToastGravity.BOTTOM,
                              const Duration(seconds: 2),
                              const Duration(milliseconds: 100)),
                          if (value.code == 200) {Navigator.pop(context)}
                        })
              }),
    ),
    // btnOkOnPress: () => _attemptChangePassword(
    //   oldPassword.text,
    //   newPassword.text,
    //   confirmNewPassword.text,
    //   context),
    // onDissmissCallback: ,
    btnOkText: "SUBMIT",
  ).show();
}
