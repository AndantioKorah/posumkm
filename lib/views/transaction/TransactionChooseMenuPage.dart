import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/models/MenuMerchantModel.dart';
import 'package:posumkm/views/widget/EmptyDataImageWidget.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/resources/arrays.dart';

import '../../main.dart';
import '../../providers/MenuMerchantProvider.dart';
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
    final provider  = Provider.of<MenuMerchantProvider>(context, listen: true);
    var _selectedMenu = menuMerchantProvider.getListSelected;
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
              color: AppsColor.alternativeWhite,
              // borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(
                    color: _selectedMenu.containsKey(item.id)
                        ? Color.fromARGB(255, 27, 94, 32)
                        : Colors.transparent,
                    width: _selectedMenu.containsKey(item.id) ? 5 : 0),
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
                                    provider.removeMenu(item);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: _selectedMenu
                                                    .containsKey(item.id)
                                                ? Colors.blueGrey
                                                : Colors.grey.withOpacity(.4),
                                            width: 2)),
                                    child: Icon(
                                      FontAwesomeIcons.minus,
                                      color: _selectedMenu.containsKey(item.id)
                                          ? Colors.blueGrey
                                          : Colors.grey.withOpacity(.4),
                                      size: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  _selectedMenu.containsKey(item.id)
                                      ? _selectedMenu[item.id]!
                                          .selectedCount
                                          .toString()
                                      : "0",
                                  style: _selectedMenu.containsKey(item.id)
                                      ? TrxTxtStyle.qtyText
                                      : TrxTxtStyle.qtyTextZero,
                                ),
                                InkWell(
                                  onTap: () {
                                    provider.addMenu(item);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: _selectedMenu
                                                    .containsKey(item.id)
                                                ? Colors.blueGrey
                                                : Colors.grey.withOpacity(.4),
                                            width: 2)),
                                    child: Icon(
                                      FontAwesomeIcons.plus,
                                      color: _selectedMenu.containsKey(item.id)
                                          ? Colors.blueGrey
                                          : Colors.grey.withOpacity(.4),
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
                    color: _selectedMenu.containsKey(item.id)
                        ? const Color.fromARGB(255, 27, 94, 32)
                        : Colors.grey.withOpacity(.4),
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
                            // _selectedMenu.containsKey(listData[index].id) ? _selectedMenu[listData[index].id]!.selectedCount.toString()
                            _selectedMenu.containsKey(item.id)
                                ? Utils().formatCurrency(
                                    (_selectedMenu[item.id]!.selectedCount *
                                            int.parse(
                                                _selectedMenu[item.id]!.harga))
                                        .toString(),
                                    "nonSymbol")
                                : "0",
                            style: _selectedMenu.containsKey(item.id)
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
            }),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TransactionChooseMenuPage extends StatelessWidget {
  var listData;
  Function callback;

  TransactionChooseMenuPage({super.key, required this.listData, required this.callback});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _listMenuMerchant = listData;
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          // child: listData.length > 0 ? 
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       for(var i = 0; i < listData.length; i++)...{
          //         MenuItem(item: listData[i],)
          //       }
          //     ],
          //   ),
          // )
          // : emptyDataWidget(context),
          child: SearchableList<MenuMerchantModel>(
            initialList: listData,
            builder: (MenuMerchantModel item) => MenuItem(item: item),
            asyncListFilter: (q, list) {
              return list
                  .where((element) =>
                      element.nama_menu_merchant.toLowerCase().contains(q))
                  .toList();
            },
            loadingWidget: loadingDataWidget(context),
            errorWidget: emptyDataWidget(context),
            emptyWidget: emptyDataWidget(context),
            asyncListCallback: () async {
              // await Future.delayed(
              //   const Duration(
              //     milliseconds: 5000,
              //   ),
              // );
              return listData;
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
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              border: OutlineInputBorder(),
              hintText: "Cari Menu",
              fillColor: AppsColor.alternativeWhite,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: "Poppins",
              ),
              // prefixIcon: Icon(Icons.search_rounded),
              // prefixIconColor: Colors.grey
            ),
          ),
        ),
      ),
    );
  }
}
