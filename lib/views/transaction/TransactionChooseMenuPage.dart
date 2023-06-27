import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';
import 'package:posumkm/views/widget/EmptyDataImageWidget.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';
import 'package:searchable_listview/resources/arrays.dart';

import '../../main.dart';
import '../../utils/Utils.dart';
import 'InputTransactionPage.dart';

import 'package:searchable_listview/searchable_listview.dart';

List<MenuMerchantModel> _listMenuMerchant = [];

// ignore: must_be_immutable
class MenuItem extends StatelessWidget {
  MenuMerchantModel item;

  MenuItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          // padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Container(
            // height: 200,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              // color: Colors.grey[100],
              color: Colors.white,
              // borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(
                  color: selectedMenu.containsKey(item.id) ? Color.fromARGB(255, 27, 94, 32) : Colors.transparent,
                  width: selectedMenu.containsKey(item.id) ? 5 : 0
                ),
                // bottom: const BorderSide(
                //   color: Colors.grey,
                //   width: 1
                // ),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(.3),
              //     spreadRadius: 0,
              //     blurRadius: 4,
              //     offset: const Offset(1, 4),
              //   )
              // ]
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              // child: Column(
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: constraints.maxWidth * .65,
                            child: Text(
                              item.nama_menu_merchant,
                              style: TrxTxtStyle.nmMenuText,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Text(
                            Utils().formatCurrency(item.harga, "nonSymbol"),
                            style: TrxTxtStyle.hargaText,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: constraints.maxWidth * .35,
                            color: Colors.transparent,
                            // padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    menuMerchantProvider.removeMenu(item);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.blueGrey, width: 2)),
                                    child: const Icon(
                                      FontAwesomeIcons.minus,
                                      color: Colors.blueGrey,
                                      size: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  selectedMenu.containsKey(item.id)
                                      ? selectedMenu[item.id]!
                                          .selectedCount
                                          .toString()
                                      : "0",
                                  style: selectedMenu.containsKey(item.id)
                                      ? TrxTxtStyle.qtyText
                                      : TrxTxtStyle.qtyTextZero,
                                ),
                                InkWell(
                                  onTap: () {
                                    menuMerchantProvider.addMenu(item);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.blueGrey, width: 2)),
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
                  LineDividerWidget(
                    color: Colors.grey.withOpacity(.3),
                    // color: Theme.of(context).colorScheme.onPrimaryContainer,
                    height: 1,
                  ),
                  Container(
                    width: double.infinity,
                    // color: Colors.amber,
                    // padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // const Text("Total: ", style: TrxTxtStyle.lblTotal, textAlign: TextAlign.end),
                        SizedBox(
                          // width: 60,
                          child: Text(
                            // selectedMenu.containsKey(listData[index].id) ? selectedMenu[listData[index].id]!.selectedCount.toString()
                            selectedMenu.containsKey(item.id)
                                ? Utils().formatCurrency(
                                    (selectedMenu[item.id]!.selectedCount *
                                            int.parse(selectedMenu[item.id]!.harga))
                                        .toString(),
                                    "nonSymbol")
                                : "0",
                            style: selectedMenu.containsKey(item.id)
                                ? TrxTxtStyle.valTotal
                                : TrxTxtStyle.valTotalZero,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
              }
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TransactionChooseMenuPage extends StatefulWidget {
  var listData;
  

  TransactionChooseMenuPage({super.key, required this.listData});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionChooseMenuPageState createState() =>
      _TransactionChooseMenuPageState();
}

class _TransactionChooseMenuPageState extends State<TransactionChooseMenuPage> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _listMenuMerchant = widget.listData;
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: 
          SearchableList<MenuMerchantModel>(
            initialList: widget.listData,
            builder: (MenuMerchantModel item) => MenuItem(item: item),
            asyncListFilter: (q, list) {
              return list
                  .where((element) =>
                      element.nama_menu_merchant.toLowerCase().contains(q))
                  .toList();
            },
            loadingWidget: loadingDataWidget(context),
            errorWidget: emptyDataWidget(context, null),
            emptyWidget: emptyDataWidget(context, null),
            asyncListCallback: () async {
              await Future.delayed(
                const Duration(
                  milliseconds: 1000,
                ),
              );
              return widget.listData;
            },
            searchTextController: searchController,
            autoFocusOnSearch: false,
            searchTextPosition: SearchTextPosition.top,
            inputDecoration: const InputDecoration(
                // suffixIcon: InkWell(
                //   onTap: () {
                //     widget.searchController.clear();
                //   },
                //   child: const Icon(
                //     Icons.cancel_rounded,
                //     size: 15,
                //     color: Colors.grey,
                //   ),
                // ),
              contentPadding: EdgeInsets.only(left: 10, right: 10,),
              border: OutlineInputBorder(),
              hintText: "Cari Menu",
              fillColor: Colors.white,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: "Poppins",
              ),
                // prefixIcon: Icon(Icons.search_rounded),
                // prefixIconColor: Colors.grey
            ),
          ),
          // child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: _listMenuMerchant.length,
          //     itemBuilder: (context, index) => Wrap(
          //           children: [
          //             Container(
          //               // height: 200,
          //               margin: const EdgeInsets.only(bottom: 10),
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 5, horizontal: 10),
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(5),
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.grey.withOpacity(.3),
          //                       spreadRadius: 1,
          //                       blurRadius: 4,
          //                       offset: const Offset(1, 4),
          //                     )
          //                   ]),
          //               child: Column(
          //                 children: [
          //                   Row(
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                             _listMenuMerchant[index].nama_menu_merchant,
          //                             style: TrxTxtStyle.nmMenuText,
          //                           ),
          //                           Text(
          //                             Utils().formatCurrency(
          //                                 _listMenuMerchant[index].harga,
          //                                 "nonSymbol"),
          //                             style: TrxTxtStyle.hargaText,
          //                           ),
          //                         ],
          //                       ),
          //                       Column(
          //                         children: [
          //                           Container(
          //                             width: 65,
          //                             // color: Colors.amber,
          //                             // padding: const EdgeInsets.all(10),
          //                             child: Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 InkWell(
          //                                   onTap: () {
          //                                     menuMerchantProvider.removeMenu(
          //                                         _listMenuMerchant[index]);
          //                                   },
          //                                   child: Container(
          //                                     padding: const EdgeInsets.all(2),
          //                                     decoration: BoxDecoration(
          //                                         color: Colors.transparent,
          //                                         borderRadius:
          //                                             BorderRadius.circular(20),
          //                                         border: Border.all(
          //                                             color: Colors.blueGrey,
          //                                             width: 2)),
          //                                     child: const Icon(
          //                                       FontAwesomeIcons.minus,
          //                                       color: Colors.blueGrey,
          //                                       size: 12,
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Text(
          //                                   selectedMenu.containsKey(
          //                                           _listMenuMerchant[index].id)
          //                                       ? selectedMenu[widget
          //                                               .listData[index].id]!
          //                                           .selectedCount
          //                                           .toString()
          //                                       : "0",
          //                                   style: selectedMenu.containsKey(
          //                                           _listMenuMerchant[index].id)
          //                                       ? TrxTxtStyle.qtyText
          //                                       : TrxTxtStyle.qtyTextZero,
          //                                 ),
          //                                 InkWell(
          //                                   onTap: () {
          //                                     menuMerchantProvider.addMenu(
          //                                         _listMenuMerchant[index]);
          //                                   },
          //                                   child: Container(
          //                                     padding: const EdgeInsets.all(2),
          //                                     decoration: BoxDecoration(
          //                                         color: Colors.transparent,
          //                                         borderRadius:
          //                                             BorderRadius.circular(20),
          //                                         border: Border.all(
          //                                             color: Colors.blueGrey,
          //                                             width: 2)),
          //                                     child: const Icon(
          //                                       FontAwesomeIcons.plus,
          //                                       color: Colors.blueGrey,
          //                                       size: 12,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                   LineDividerWidget(
          //                     color: Colors.grey.withOpacity(.3),
          //                     height: 1,
          //                   ),
          //                   Container(
          //                     width: double.infinity,
          //                     // color: Colors.amber,
          //                     // padding: const EdgeInsets.symmetric(vertical: 3),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.end,
          //                       children: [
          //                         // const Text("Total: ", style: TrxTxtStyle.lblTotal, textAlign: TextAlign.end),
          //                         SizedBox(
          //                           // width: 60,
          //                           child: Text(
          //                             // selectedMenu.containsKey(listData[index].id) ? selectedMenu[listData[index].id]!.selectedCount.toString()
          //                             selectedMenu.containsKey(
          //                                     _listMenuMerchant[index].id)
          //                                 ? Utils().formatCurrency(
          //                                     (selectedMenu[_listMenuMerchant[
          //                                                         index]
          //                                                     .id]!
          //                                                 .selectedCount *
          //                                             int.parse(selectedMenu[
          //                                                     widget
          //                                                         .listData[index]
          //                                                         .id]!
          //                                                 .harga))
          //                                         .toString(),
          //                                     "nonSymbol")
          //                                 : "0",
          //                             style: selectedMenu.containsKey(
          //                                     _listMenuMerchant[index].id)
          //                                 ? TrxTxtStyle.valTotal
          //                                 : TrxTxtStyle.valTotalZero,
          //                             textAlign: TextAlign.end,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         )
          // ),
        ),
      ),
    );
  }
}
