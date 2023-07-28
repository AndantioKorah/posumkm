// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/transaction/InputTransactionPage.dart';
import 'package:posumkm/views/widget/EmptyDataImageWidget.dart';
import 'package:posumkm/views/widget/HttpToastDialog.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';

import '../../controllers/api/TransactionController.dart';
import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../../models/TransactionModel.dart';
import 'PaymentPage.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionModel> listTransaksi = [];
  DateTime selectedDate = DateTime.now();
  TextEditingController tglTransaksiController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool _showLoader = false;

  DateTime? datePicked;

  Future<void> _selectDate(BuildContext context) async {
    datePicked = await showDatePicker(
        confirmText: "Ok",
        cancelText: "Batal",
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        selectedDate = datePicked!;
        tglTransaksiController.text =
        Utils().formatDateOnly(selectedDate.toString(), "/");
      });
    }
  }

  Future<void> _getAllTransaksi() async {
    setState((){
      _showLoader = true;
    });
    HttpResponseModel rs = await TransactionController.getAllTransaksiByDate(tglTransaksiController.text);
    // ignore: unnecessary_null_comparison
    if(rs != null){
      if(rs.code == 200){
        setState((){
          if(rs.data.length > 0){
            listTransaksi = convertToList(rs.data);
          }
        });
      }
      // ignore: use_build_context_synchronously
      httpToastDialog(
        rs, 
        context, 
        ToastGravity.BOTTOM, 
        Duration(seconds: 2), 
        Duration(seconds: 2)); 
    }
    setState((){
      _showLoader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    tglTransaksiController.text =
        Utils().formatDateOnly(selectedDate.toString(), "/");
    _getAllTransaksi();
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Expanded(
      child: Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: InputTransactionPage(idTransaksi: "0",),
                    type: PageTransitionType.bottomToTop));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: theme.colorScheme.onPrimaryContainer,
            ),
            child: Icon(
              FontAwesomeIcons.plus,
              color: AppsColor.alternativeWhite,
              size: 20,
            ),
          ),
        ),
        appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.chevron_left_rounded,
          //     size: 30,
          //     color: AppsColor.alternativeWhite,
          //   ),
          //   onPressed: () => Navigator.of(context).pop()),
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          title: const Text("TRANSAKSI", style: BaseTextStyle.appBarTitle),
          // centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  _getAllTransaksi();
                },
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: AppsColor.alternativeWhite,
                ),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: sizeScreen.width * .45,
                    child: InkWell(
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
                          style: TextStyle(
                            color: AppsColor.alternativeBlack,
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold
                          ),
                          cursorColor: AppsColor.alternativeBlack,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            labelText: "Tgl. Transaksi",
                            labelStyle: TrxTxtStyle.lblTxtField,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppsColor.alternativeBlack)),
                            border: const OutlineInputBorder(),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppsColor.alternativeBlack)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppsColor.alternativeBlack)),
                            // color: Color.fromARGB(100, 255, 255, 255))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeScreen.width * .45,
                    child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: searchController,
                          // autofocus: true,
                          style: TextStyle(
                            color: AppsColor.alternativeBlack,
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold
                          ),
                          cursorColor: AppsColor.alternativeBlack,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            labelText: "Cari Data",
                            labelStyle: TrxTxtStyle.lblTxtField,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: AppsColor.alternativeBlack)),
                            border: const OutlineInputBorder(),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppsColor.alternativeBlack)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppsColor.alternativeBlack)),
                            // color: Color.fromARGB(100, 255, 255, 255))),
                          ),
                        ),
                      ),
                  )
                ],
              ),
              _showLoader ? 
              loadingDataWidget(context)
              :
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: ListTransaksiItem(listData: listTransaksi),
              )              
            ]
          ),
        )
      ),
    );
  }
}

// ignore: must_be_immutable
class ListTransaksiItem extends StatefulWidget {
  List<TransactionModel> listData;
  ListTransaksiItem({super.key, required this.listData});

  @override
  State<ListTransaksiItem> createState() => _ListTransaksiItemState();
}

class _ListTransaksiItemState extends State<ListTransaksiItem> {
  @override
  Widget build(BuildContext context) {
    return widget.listData.isNotEmpty ?
    ListView.builder(
      itemCount: widget.listData.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => 
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: (){
            Navigator.push(
                context,
                PageTransition(
                    child: 
                    widget.listData[index].status_transaksi == "Lunas" ?
                    PaymentPage(id: widget.listData[index].id)
                    :
                    InputTransactionPage(idTransaksi: widget.listData[index].id,),
                    type: PageTransitionType.bottomToTop));
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: LayoutBuilder(
                    builder:(BuildContext context, BoxConstraints constraints) => 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: widget.listData[index].status_transaksi == "Lunas" ? Colors.green[900] : Colors.red[900],
                                borderRadius: BorderRadius.circular(3)
                              ),
                              child: Text(widget.listData[index].status_transaksi, style: TranStyle.textTransaksiWhite,),
                            ),
                            Text(widget.listData[index].nomor_transaksi, style: TranStyle.textNomorTransaksi,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: constraints.maxWidth * .6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Utils().formatCurrency(widget.listData[index].total_harga, ""), style: TranStyle.textNomorTransaksi,),
                                  Text("Total Item: ${widget.listData[index].total_item}", style: TranStyle.textTransaksi,),
                                ],
                              ),
                            ),
                            Container(
                              width: constraints.maxWidth * .4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(Utils().formatDate(widget.listData[index].tanggal_transaksi, "/"), style: TranStyle.textTransaksi,),
                                  Text(widget.listData[index].nama == "" ? "-" : widget.listData[index].nama, style: TranStyle.textTransaksi,),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(widget.listData[index].list_nama_item, style: TranStyle.textListNamaItem, overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ),
                // Divider(height: 1, color: Colors.blueGrey,),
                // Container(
                //   padding: EdgeInsets.all(5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Container(
                //         child: InkWell(
                //           onTap: (){},
                //           child: Icon(
                //             Icons.search_rounded,
                //             color: AppsColor.alternativeBlack,
                //           ),
                //         ),
                //       ),
                //       Container(
                //         child: InkWell(
                //           onTap: (){},
                //           child: Icon(
                //             Icons.delete_rounded,
                //             color: Colors.red[900],
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            )
          ),
        )
    )
    :
    emptyDataWidget(context);
  }
}

class TranStyle{
  static var textNomorTransaksi = TextStyle(
    color: AppsColor.alternativeBlack,
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.bold
  );

  static var textTransaksi = TextStyle(
    color: AppsColor.alternativeBlack,
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.bold
  );

  static var textListNamaItem = TextStyle(
    color: Colors.grey,
    fontFamily: "Poppins",
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static var textTransaksiWhite = TextStyle(
    color: AppsColor.alternativeWhite,
    fontFamily: "Poppins",
    fontSize: 14,
    fontWeight: FontWeight.bold
  );
}