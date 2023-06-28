import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:posumkm/controllers/api/TransactionController.dart';
import 'package:posumkm/views/transaction/InputTransactionPage.dart';
import 'package:posumkm/views/transaction/PaymentPage.dart';
import 'package:posumkm/views/widget/ToastDialog.dart';

import '../../utils/Utils.dart';

// ignore: must_be_immutable
class TransactionDetailitem extends StatefulWidget {
  var listDataItem;
  var selectedDataItem;

  TransactionDetailitem(
      {super.key, required this.listDataItem, required this.selectedDataItem});

  @override
  State<TransactionDetailitem> createState() => _TransactionDetailitemState();
}

class _TransactionDetailitemState extends State<TransactionDetailitem> {
  DateTime selectedDate = DateTime.now();
  TextEditingController tglTransaksiController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  DateTime? datePicked;
  TimeOfDay? timePicked;
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  Future<void> _selectDate(BuildContext context) async {
    datePicked = await showDatePicker(
        confirmText: "Lanjut",
        cancelText: "Batal",
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (datePicked != null && datePicked != selectedDate) {
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
          tglTransaksiController.text =
              Utils().formatDate(selectedDate.toString(), "/");
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tglTransaksiController.text =
        Utils().formatDate(selectedDate.toString(), "/");
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sizeScreen = MediaQuery.of(context).size;
    return Stack(
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
                  controller: namaController,
                  // autofocus: true,
                  style: TrxTxtStyle.valTxtField,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    labelText: "Nama",
                    labelStyle: TrxTxtStyle.lblTxtField,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white)),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(100, 255, 255, 255))),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: tglTransaksiController,
                    enabled: false,
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
                      disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(100, 255, 255, 255))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(100, 255, 255, 255))),
                      // color: Color.fromARGB(100, 255, 255, 255))),
                    ),
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
                                          i < widget.listDataItem.length;
                                          i++) ...{
                                        if (widget.selectedDataItem.containsKey(
                                            widget.listDataItem[i].id)) ...{
                                          rowItemDetail(
                                              context,
                                              widget.selectedDataItem[
                                                  widget.listDataItem[i].id]!)
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
            onTap: () {
              if (selectedMenu.length == 0) {
                ToastDialog(
                        context: context,
                        color: const Color.fromARGB(255, 183, 28, 28),
                        message: "Belum ada menu yang dipilih",
                        icon: FontAwesomeIcons.exclamation,
                        gravity: ToastGravity.BOTTOM)
                    .showDialog();
              } else {
                // TransactionController.createTransaksi(json.encode(selectedMenu),
                //         tglTransaksiController.text, namaController.text)
                //     .then((value) {
                //   if (value.code != 200 || value.code != 201) {
                //     AwesomeDialog(
                //             context: context,
                //             dialogType: DialogType.ERROR,
                //             animType: AnimType.SCALE,
                //             title: "Error",
                //             desc: value.message,
                //             showCloseIcon: true,
                //             btnOkText: "Tutup",
                //             btnOkColor: Colors.red,
                //             btnOkOnPress: () {})
                //         .show();
                //   } else {
                Navigator.push(
                    context,
                    PageTransition(
                        // child: PaymentPage(id: value.data,),
                        child: PaymentPage(
                          id: "10",
                        ),
                        type: PageTransitionType.rightToLeft));
                //   }
                // });
              }
            },
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
    );
  }
}
