
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../widget/HttpToastDialog.dart';
import '../widget/Redicrect.dart';

PembayaranModel? pembayaranModel;
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
  TextEditingController kembalianController = TextEditingController();
  TextEditingController tanggalPembayaranController = TextEditingController();
  TextEditingController noRefController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? datePicked;
  TimeOfDay? timePicked;
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  RoundedLoadingButtonController btnPayController =
      RoundedLoadingButtonController();
  bool _showLoaderButton = false;

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

  Future<HttpResponseModel> _getPembayaranDetail(var result) async {
    setState(() {
      _showLoader = true;
      pembayaranModel = null;
    });

    HttpResponseModel rs;

    if (result != null) {
      rs = result;
    } else {
      rs = await TransactionController.getPembayaranDetail(widget.id);
    }
    // ignore: unnecessary_null_comparison
    if (rs != null) {
      if (rs.code == 200 || rs.code == 201 || rs.code == 409) {
        if (rs.data['pembayaran'] != null) {
          pembayaranModel = PembayaranModel.fromJson(rs.data['pembayaran']);
        }
        transactionModel = TransactionModel.fromJson(rs.data['transaksi']);
        transactionDetailModel = transactionModel.detail;
        namaPembayarController.text = transactionModel.nama;
        totalPembayaranController.text = transactionModel.total_harga;
        kembalianController.text = "0";

        selectedDate = DateTime.parse(transactionModel.tanggal_transaksi);
        tanggalPembayaranController.text =
            Utils().formatDate(selectedDate.toString(), "/");
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
    _getPembayaranDetail(null);
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
                color: AppsColor.alternativeWhite,
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
                                  color: AppsColor.alternativeWhite,
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
                                                        color: AppsColor
                                                            .alternativeBlack,
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
                                                    color: AppsColor
                                                        .alternativeWhite,
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
                                      // ignore: unnecessary_null_comparison
                                      if (pembayaranModel != null) ...{
                                        Container(
                                          color: Colors.green[100],
                                          padding: const EdgeInsets.all(10),
                                          child: LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints constraints) {
                                              return Column(
                                                children: [
                                                  const Center(
                                                    child: Text(
                                                      "Data Pembayaran",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: const Text(
                                                            "Tanggal Pembayaran",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins"),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: Text(
                                                            Utils().formatDate(
                                                                pembayaranModel!
                                                                    .tanggal_pembayaran,
                                                                "/"),
                                                            style: PaymentTextStyle
                                                                .valDataPembayaran,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ]),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: const Text(
                                                            "Jenis Pembayaran",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins"),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: Text(
                                                            pembayaranModel!
                                                                .nama_jenis_pembayaran,
                                                            style: PaymentTextStyle
                                                                .valDataPembayaran,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ]),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: const Text(
                                                            "Nomor Referensi",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins"),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: Text(
                                                            pembayaranModel!
                                                                .nomor_referensi_pembayaran,
                                                            style: PaymentTextStyle
                                                                .valDataPembayaran,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ]),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: const Text(
                                                            "Nama Pembayar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins"),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: Text(
                                                            pembayaranModel!
                                                                .nama_pembayar,
                                                            style: PaymentTextStyle
                                                                .valDataPembayaran,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ]),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: const Text(
                                                            "Jumlah Pembayaran",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins"),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: Text(
                                                            Utils().formatCurrency(
                                                                pembayaranModel!
                                                                    .total_pembayaran,
                                                                ""),
                                                            style: PaymentTextStyle
                                                                .valDataPembayaran,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ]),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: const Text(
                                                            "Kembalian",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins"),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors
                                                              .transparent,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .45,
                                                          child: Text(
                                                            Utils().formatCurrency(
                                                                pembayaranModel!
                                                                    .kembalian,
                                                                ""),
                                                            style: PaymentTextStyle
                                                                .valDataPembayaran,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ])
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
                                      },
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
                                        child: Column(
                                          children: [
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    width:
                                                        constraints.maxWidth *
                                                            .45,
                                                    child: const Text(
                                                      "Total",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.transparent,
                                                    width:
                                                        constraints.maxWidth *
                                                            .45,
                                                    child: Text(
                                                      Utils().formatCurrency(
                                                          transactionModel
                                                              .total_harga,
                                                          "symbolOnLeft"),
                                                      style: const TextStyle(
                                                          color: AppsColor
                                                              .alternativeBlack,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Poppins"),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  )
                                                ]),
                                            // ignore: unnecessary_null_comparison
                                            if (pembayaranModel == null) ...{
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: const Text(
                                                        "Tgl. Pembayaran",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: InkWell(
                                                        onTap: () {
                                                          _selectDate(context);
                                                        },
                                                        child: SizedBox(
                                                          height: 40,
                                                          child: TextField(
                                                            textAlign:
                                                                TextAlign.right,
                                                            controller:
                                                                tanggalPembayaranController,
                                                            enabled: false,
                                                            // autofocus: true,
                                                            style:
                                                                PaymentTextStyle
                                                                    .valTxtField,
                                                            cursorColor: AppsColor
                                                                .alternativeWhite,
                                                            decoration: InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            0),
                                                                labelStyle:
                                                                    PaymentTextStyle
                                                                        .lblTxtField,
                                                                disabledBorder:
                                                                    const UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey))),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: const Text(
                                                        "Jenis Pembayaran",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: SizedBox(
                                                        height: 40,
                                                        child:
                                                            DropdownButtonFormField(
                                                          focusColor:
                                                              Colors.blueGrey,
                                                          isExpanded: true,
                                                          value:
                                                              selectedJenisPembayaran,
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .chevronDown,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimaryContainer,
                                                            size: 12,
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                            labelStyle:
                                                                PaymentTextStyle
                                                                    .lblTxtField,
                                                            focusColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .onPrimaryContainer,
                                                          ),
                                                          items: const [
                                                            DropdownMenuItem(
                                                                value: 1,
                                                                child: Text(
                                                                  "Tunai",
                                                                  style: PaymentTextStyle
                                                                      .itemDropDown,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                )),
                                                            DropdownMenuItem(
                                                                value: 2,
                                                                child: Text(
                                                                  "Transfer",
                                                                  style: PaymentTextStyle
                                                                      .itemDropDown,
                                                                )),
                                                            DropdownMenuItem(
                                                                value: 3,
                                                                child: Text(
                                                                  "QRIS",
                                                                  style: PaymentTextStyle
                                                                      .itemDropDown,
                                                                )),
                                                            DropdownMenuItem(
                                                                value: 4,
                                                                child: Text(
                                                                  "Credit / Debit Card",
                                                                  style: PaymentTextStyle
                                                                      .itemDropDown,
                                                                )),
                                                            DropdownMenuItem(
                                                                value: 5,
                                                                child: Text(
                                                                  "ShopeePay",
                                                                  style: PaymentTextStyle
                                                                      .itemDropDown,
                                                                )),
                                                            DropdownMenuItem(
                                                                value: 6,
                                                                child: Text(
                                                                  "Lainnya",
                                                                  style: PaymentTextStyle
                                                                      .itemDropDown,
                                                                )),
                                                          ],
                                                          onChanged:
                                                              (selected) {
                                                            setState(() {
                                                              selectedJenisPembayaran =
                                                                  selected!;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: const Text(
                                                        "No. Referensi (optional)",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              noRefController,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          // autofocus: true,
                                                          style:
                                                              PaymentTextStyle
                                                                  .valTxtField,
                                                          textAlign:
                                                              TextAlign.right,
                                                          cursorColor: theme
                                                              .colorScheme
                                                              .onPrimaryContainer,
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            0),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: const Text(
                                                        "Nama Pembayar",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              namaPembayarController,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          // autofocus: true,
                                                          style:
                                                              PaymentTextStyle
                                                                  .valTxtField,
                                                          textAlign:
                                                              TextAlign.right,
                                                          cursorColor: theme
                                                              .colorScheme
                                                              .onPrimaryContainer,
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            0),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: const Text(
                                                        "Jumlah Pembayaran",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          controller:
                                                              totalPembayaranController,
                                                          onChanged: (value) {
                                                            // if (value.length >
                                                            //     3) {
                                                            //   totalPembayaranController
                                                            //           .text =
                                                            //       Utils().formatCurrency(
                                                            //           totalPembayaranController
                                                            //               .text,
                                                            //           "nonSymbol");
                                                            // }
                                                            var kembalian = (int.parse(
                                                                    totalPembayaranController
                                                                        .text) -
                                                                int.parse(
                                                                    transactionModel
                                                                        .total_harga));
                                                            kembalianController
                                                                .text = kembalian >=
                                                                    0
                                                                ? Utils().formatCurrency(
                                                                    kembalian
                                                                        .toString(),
                                                                    "nonSymbol")
                                                                : "0";
                                                          },
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          // autofocus: true,
                                                          style: PaymentTextStyle
                                                              .valTxtFieldJumlahPembayaran,
                                                          textAlign:
                                                              TextAlign.right,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          cursorColor: theme
                                                              .colorScheme
                                                              .onPrimaryContainer,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        0),
                                                            labelStyle:
                                                                PaymentTextStyle
                                                                    .lblTxtField,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: const Text(
                                                        "Kembalian",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width:
                                                          constraints.maxWidth *
                                                              .45,
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          enabled: false,
                                                          controller:
                                                              kembalianController,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          // autofocus: true,
                                                          style:
                                                              PaymentTextStyle
                                                                  .valTxtField,
                                                          textAlign:
                                                              TextAlign.right,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          cursorColor: theme
                                                              .colorScheme
                                                              .onPrimaryContainer,
                                                          decoration: InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          0),
                                                              labelStyle:
                                                                  PaymentTextStyle
                                                                      .lblTxtField,
                                                              disabledBorder:
                                                                  const UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.grey))),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            }
                                          ],
                                        ),
                                      ),
                                      _showLoaderButton
                                          ? InkWell(
                                              child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(
                                                      10),
                                                  decoration: BoxDecoration(
                                                      // ignore: unnecessary_null_comparison
                                                      color: pembayaranModel !=
                                                              null
                                                          ? Colors.red[900]
                                                          : Colors.green[100],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                  height: 50,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SpinKitSpinningLines(
                                                        color: Color.fromARGB(
                                                            255, 27, 94, 32),
                                                        size: 25,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Please Wait",
                                                          style: TextStyle(
                                                              // ignore: unnecessary_null_comparison
                                                              color: pembayaranModel !=
                                                                      null
                                                                  ? Colors
                                                                      .red[900]
                                                                  : Colors.green[
                                                                      900],
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  )),
                                            )
                                          :
                                          // ignore: unnecessary_null_comparison
                                          pembayaranModel != null
                                              ? InkWell(
                                                  onTap: () {
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.QUESTION,
                                                      animType:
                                                          AnimType.TOPSLIDE,
                                                      title:
                                                          "Hapus Data Pembayaran",
                                                      desc:
                                                          "Apakah Anda yakin?",
                                                      showCloseIcon: true,
                                                      // btnOkText: "Tutup",
                                                      // btnOkColor: Colors.red,
                                                      btnOkOnPress: () {
                                                        TransactionController
                                                                .deletePembayaran(
                                                                    pembayaranModel!
                                                                        .id)
                                                            .then((value) {
                                                          httpToastDialog(
                                                              value,
                                                              context,
                                                              ToastGravity
                                                                  .BOTTOM,
                                                              const Duration(
                                                                  seconds: 2),
                                                              const Duration(
                                                                  seconds: 2));
                                                          if (value.code ==
                                                              200) {
                                                            _getPembayaranDetail(
                                                                value);
                                                          }
                                                        });
                                                      },
                                                      btnCancelColor:
                                                          Colors.red[900],
                                                      btnOkText: "Hapus",
                                                      btnOkColor:
                                                          Colors.green[900],
                                                      btnCancelOnPress: () {},
                                                    ).show();
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 250, 230, 228),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5))),
                                                    height: 50,
                                                    child: Center(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Hapus Pembayaran",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[900],
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .trash,
                                                          color:
                                                              Colors.red[900],
                                                          size: 20,
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _showLoaderButton = true;
                                                    });

                                                    TransactionController.createPembayaran(
                                                            transactionModel.id,
                                                            tanggalPembayaranController
                                                                .text,
                                                            selectedJenisPembayaran
                                                                .toString(),
                                                            namaPembayarController
                                                                .text,
                                                            totalPembayaranController
                                                                .text,
                                                            kembalianController
                                                                .text)
                                                        .then((value) {
                                                      if (value.code != 200 &&
                                                          value.code != 201 &&
                                                          value.code != 409) {
                                                        AwesomeDialog(
                                                                context:
                                                                    context,
                                                                dialogType:
                                                                    DialogType
                                                                        .ERROR,
                                                                animType:
                                                                    AnimType
                                                                        .SCALE,
                                                                title: "Error",
                                                                desc: value
                                                                    .message,
                                                                showCloseIcon:
                                                                    true,
                                                                btnOkText:
                                                                    "Tutup",
                                                                btnOkColor:
                                                                    Colors.red,
                                                                btnOkOnPress:
                                                                    () {})
                                                            .show();
                                                        setState(() {
                                                          _showLoaderButton =
                                                              false;
                                                        });
                                                      } else {
                                                        _getPembayaranDetail(
                                                            value);
                                                        httpToastDialog(
                                                            value,
                                                            context,
                                                            ToastGravity.BOTTOM,
                                                            const Duration(
                                                                seconds: 2),
                                                            const Duration(
                                                                seconds: 2));
                                                        setState(() {
                                                          _showLoaderButton =
                                                              false;
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .green[900],
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5))),
                                                    height: 50,
                                                    child: const Center(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Sumbit Pembayaran",
                                                          style: TextStyle(
                                                              color: AppsColor
                                                                  .alternativeWhite,
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .arrowUpRightFromSquare,
                                                          color: AppsColor
                                                              .alternativeWhite,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
      color: AppsColor.alternativeBlack,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const tableItemSmall = TextStyle(
      color: Colors.blueGrey,
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const itemDropDown = TextStyle(
      color: AppsColor.alternativeBlack,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static var lblTxtField = TextStyle(
      color: Colors.grey[400],
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valTxtField = TextStyle(
      color: AppsColor.alternativeBlack,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valTxtFieldJumlahPembayaran = TextStyle(
      color: AppsColor.alternativeBlack,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valDataPembayaran = TextStyle(
      color: AppsColor.alternativeBlack,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");
}
