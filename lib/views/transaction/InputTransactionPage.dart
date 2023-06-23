import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:posumkm/utils/Utils.dart';
import 'package:posumkm/views/transaction/PaymentPage.dart';

import '../../controllers/api/MasterController.dart';
import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../../models/JenisMenuModel.dart';
import '../../models/KategoriMenuModel.dart';
import '../../models/MasterMenuModel.dart';
import '../../models/MenuMerchantModel.dart';
import '../widget/HttpToastDialog.dart';
import '../widget/Redicrect.dart';

class InputTransactionPage extends StatefulWidget {
  const InputTransactionPage({super.key});

  @override
  State<InputTransactionPage> createState() => _InputTransactionState();
}

class _InputTransactionState extends State<InputTransactionPage> {
  List<JenisMenuModel> _listJenisMenu = [];
  List<KategoriMenuModel> _listKategoriMenu = [];
  List<MenuMerchantModel> _listMenuMerchant = [];
  late MasterMenuModel _masterMenuModel;
  bool _isRedirectLogout = false;
  String _messageRedirect = "";
  
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
      } else if(rs.code == 302){
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
    var theme = Theme.of(context);
    var sizeScreen = MediaQuery.of(context).size;
    TextEditingController _searchController = TextEditingController();

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
            onPressed: () => Navigator.of(context).pop()
          ),
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          title: const Text("TRANSAKSI BARU", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () => _refreshMasterMenu().then((value) => {
                      if (value.code != 200){
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
          ]
        ), 
        body: SafeArea(
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
                        ]
                      )
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: TextField(
                            // autofocus: true,
                            style: TrxTxtStyle.valTxtField,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              labelText: "Nama",
                              labelStyle: TrxTxtStyle.lblTxtField,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1, color: Colors.white
                                )                 
                              ),
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1, color: Color.fromARGB(100, 255, 255, 255)
                                )                 
                              ),
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              labelText: "Tgl. Transaksi",
                              labelStyle: TrxTxtStyle.lblTxtField,
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1, color: Colors.white
                                )                 
                              ),
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1, color: Color.fromARGB(100, 255, 255, 255)
                                )                 
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                                    ]
                                  ),
                                  child: Column(
                                    children: [
                                      const Text("List Item:", style: TrxTxtStyle.totTagihanText,),
                                      const SizedBox(height: 5,),
                                      Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              Column(
                                                children: [
                                                  for(var i = 0; i < 1; i ++)
                                                  rowItemDetail(context,
                                                    "Jus Manggasss",
                                                    "20000",
                                                    "2",
                                                    "10000"
                                                  ),
                                                ],
                                              )
                                            ]
                                          )
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
                        const SizedBox(height: 40,)
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
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              // height: 30,
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(1),
                                    offset: const Offset(0, 0),
                                    spreadRadius: 1,
                                    blurRadius: 100
                                  )
                                ]
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Total:", style: TrxTxtStyle.totTagihanText,),
                                        Text("3.000.000", style: TrxTxtStyle.totTagihanVal,),
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
                        Container(
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
                                  controller: _searchController,
                                  onChanged: (searchValue) {
                                    print(searchValue);
                                  },
                                  style: const TextStyle(
                                      color: Colors.black, fontFamily: "Poppins", fontSize: 14),
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _searchController.clear();
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
                                    hintStyle:const TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Poppins",
                                    ),
                                    prefixIcon: const Icon(Icons.search_rounded),
                                    prefixIconColor: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        LineDividerWidget(
                          color: Colors.grey.withOpacity(.3),
                          height: 1,
                        ),
                        const SizedBox(height: 10,),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _listMenuMerchant.length,
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
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                      ] 
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(_listMenuMerchant[index].nama_menu_merchant, style: TrxTxtStyle.nmMenuText,),
                                                Text(Utils().formatCurrency(
                                                  _listMenuMerchant[index].harga, "nonSymbol"), 
                                                style: TrxTxtStyle.hargaText,),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  // color: Colors.amber,
                                                  // padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        child: Container(
                                                          padding: const EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.circular(20),
                                                            border: Border.all(color: Colors.blueGrey, width: 2)
                                                          ),
                                                          child: const Icon(
                                                            FontAwesomeIcons.minus,
                                                            color: Colors.blueGrey,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      const Text("0", style: TrxTxtStyle.qtyText,),
                                                      InkWell(
                                                        child: Container(
                                                          padding: const EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.circular(20),
                                                            border: Border.all(color: Colors.blueGrey, width: 2)
                                                          ),
                                                          child: const Icon(
                                                            FontAwesomeIcons.plus,
                                                            color: Colors.blueGrey,
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
                                        LineDividerWidget(color: Colors.grey.withOpacity(.3), height: 1,),
                                        Container(
                                          width: double.infinity,
                                          // color: Colors.amber,
                                          // padding: const EdgeInsets.symmetric(vertical: 3),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text("Total: ", style: TrxTxtStyle.lblTotal, textAlign: TextAlign.end),
                                              SizedBox(
                                                width: 75,
                                                child: Text("3.000.000", style: TrxTxtStyle.valTotal, textAlign: TextAlign.end,),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                        const SizedBox(height: 65,)
                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: InkWell(
                    //     onTap: (){
                    //       Navigator.push(
                    //       context,
                    //       PageTransition(
                    //           child: const PaymentPage(),
                    //           type: PageTransitionType.rightToLeft));
                    //     },
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //       color: Colors.transparent,
                    //       child: Wrap(
                    //         children: [
                    //           Container(
                    //             width: double.infinity,
                    //             padding: const EdgeInsets.only(
                    //               left: 20,
                    //               right: 10,
                    //               top: 10,
                    //               bottom: 10
                    //             ),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(30),
                    //               gradient: LinearGradient(colors: [
                    //                 Colors.blueGrey,
                    //                 theme.colorScheme.onPrimaryContainer,
                    //               ])
                    //             ),
                    //             child: const Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text("Total Transaksi: ", style: TrxTxtStyle.lblBtnTotal),
                    //                     Text("Rp 5.127.532", style: TrxTxtStyle.valBtnTotal),
                    //                   ],
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text("Items: ", style: TrxTxtStyle.lblBtnTotal),
                    //                     Text("1 item", style: TrxTxtStyle.valBtnTotal),
                    //                   ],
                    //                 ),
                    //                 Align(
                    //                   alignment: Alignment.centerRight,
                    //                   child: Icon(
                    //                     Icons.chevron_right_rounded,
                    //                     size: 30,
                    //                     color: Colors.white,
                    //                   ),
                    //                 )
                    //               ],
                    //             )
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ) 
        ),
      ),
    );
  }
}

Widget rowItemDetail(
  BuildContext context,
  String namaMenu,
  String totalHarga,
  String qty,
  String hargaSatuan,) => Container(
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
                child: Text(namaMenu, style: TrxTxtStyle.lblDetailItem,),
              ),
              Text(Utils().formatCurrency(totalHarga, "nonSymbol"),
                style: TrxTxtStyle.lblTotDetailItem,)
            ],
          );
        },
      ),
      const SizedBox(height: 3,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$qty x ${Utils().formatCurrency(hargaSatuan, "nonSymbol")}", style: TrxTxtStyle.lblHrgSatuanItem,),
          InkWell(
            onTap: (){},
            child: const Icon(
              FontAwesomeIcons.trashCan,
              color: Colors.red,
              size: 12,
            ),
          )
        ],
      ),
      const SizedBox(height: 5,),
      LineDividerWidget(
        color: Colors.grey.withOpacity(.3),
      )
    ],
  ),
  );

class TrxTxtStyle{
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
    overflow: TextOverflow.ellipsis
  );

  static const hargaText = TextStyle(
    fontFamily: "Poppins",
    fontSize: 13,
    color: Colors.black,
    // fontWeight: FontWeight.bold
  );
  
  static const qtyText = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold
  );

  static const addBtn = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold
  );

  static const lblTotal = TextStyle(
    fontSize: 12,
    color: Colors.blueGrey,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

  static const valTotal = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

  static const lblBtnTotal = TextStyle(
    fontSize: 14,
    color: Colors.white,
    // fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

  static const valBtnTotal = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

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
    fontWeight: FontWeight.bold
  );
}