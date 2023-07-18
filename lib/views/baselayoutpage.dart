// ignore_for_file: prefer_const_constructors

// import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:posumkm/views/HomePage.dart';
import 'package:posumkm/views/UserAccountPage.dart';

import 'package:posumkm/main.dart';

import '../models/UserModel.dart';
import '../utils/ImageUtils.dart';
import 'transaction/TransactionPage.dart';

UserModel? userLoggedIn;

// ignore: must_be_immutable
class BaseLayoutPage extends StatefulWidget {
  // int openPage;
  const BaseLayoutPage({
    Key? key,
    // required this.openPage
  }) : super(key : key);

  @override
  State<BaseLayoutPage> createState() => _BaseLayoutPageState();
}

Future<void> loadUserLoggedIn() async {
  UserPreferences.getUserLoggedIn().then((value) => userLoggedIn = value);
}

class _BaseLayoutPageState extends State<BaseLayoutPage> {
  var selectedPage = 0;
  List<Widget> listWidget = [];

  _changeStatePage(int selectedIndex) {
    setState(() {
      selectedPage = selectedIndex;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   selectedPage = widget.openPage;
  //   setState(() {
      
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    switch (selectedPage) {
      case 0:
        listWidget = [
          TopWidget(),
          HistoryTransactionWidget(),
          SizedBox(
            height: 20,
          ),
          HomePage()
        ];
        break;
      case 1:
        listWidget = [TransactionPage()];
        break;
      case 2:
        listWidget = [TopWidgetUserAccount(), UserAccountPage()];
        break;
      default:
        throw UnimplementedError();
    }

    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: AppsColor.alternativeWhite,
          buttonBackgroundColor: theme.colorScheme.onPrimaryContainer,
          color: theme.colorScheme.onPrimaryContainer,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          index: selectedPage,
          onTap: _changeStatePage,
          items: const <Widget>[
            Icon(
              Icons.home,
              size: 20,
              color: AppsColor.alternativeWhite,
            ),
            Icon(
              FontAwesomeIcons.cashRegister,
              size: 20,
              color: AppsColor.alternativeWhite,
            ),
            Icon(
              FontAwesomeIcons.user,
              size: 20,
              color: AppsColor.alternativeWhite,
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  theme.colorScheme.onPrimaryContainer,
                  Color.fromRGBO(68, 80, 131, 1),
                  // theme.colorScheme.onPrimaryContainer,
                  // Color.fromRGBO(47, 56, 92, 1)
                ],
              ),
            ),
            child: Column(children: listWidget),
          ),
        ));
  }
}

class ItemTransactionWidget extends StatefulWidget {
  final String jenisPembayaran;
  final String tanggalTransaksi;
  final String totalTransaksi;
  final String listMenu;
  final String jumlahMenu;

  const ItemTransactionWidget({
    super.key,
    required this.jenisPembayaran,
    required this.tanggalTransaksi,
    required this.totalTransaksi,
    required this.listMenu,
    required this.jumlahMenu,
  });

  @override
  State<ItemTransactionWidget> createState() => _ItemTransactionWidgetState();
}

class _ItemTransactionWidgetState extends State<ItemTransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 50,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 41, 154, 36),
                    borderRadius: BorderRadius.circular(5)),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.jenisPembayaran,
                      style: BaseTextStyle.ltJpTunai,
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.tanggalTransaksi,
                  style: BaseTextStyle.ltTanggal,
                ),
                Text(
                  widget.totalTransaksi,
                  style: BaseTextStyle.ltRpLunas,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.listMenu, style: BaseTextStyle.ltListMenu)),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.jumlahMenu,
                  style: BaseTextStyle.ltItemCounts,
                )),
            SizedBox(
              height: 8,
            ),
            LineDividerWidget(
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryTransactionWidget extends StatefulWidget {
  const HistoryTransactionWidget({super.key});

  @override
  State<HistoryTransactionWidget> createState() =>
      _HistoryTransactionWidgetState();
}

class _HistoryTransactionWidgetState extends State<HistoryTransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          // height: sizeScreen.height * 0.48,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaksi Terakhir",
                    style: BaseTextStyle.labelTransaksiHome,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        )),
                    child: Row(
                      children: const [
                        Text(
                          "Refresh ",
                          style: BaseTextStyle.buttonTransaksiHome,
                        ),
                        Icon(
                          Icons.autorenew_rounded,
                          size: 13,
                          color: AppsColor.alternativeWhite,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ItemTransactionWidget(
                tanggalTransaksi: "24 Mei 2023, 18:16",
                jenisPembayaran: "Tunai",
                jumlahMenu: "5 items",
                listMenu:
                    "Roti Bakar Keju, Tahu Isi, Pisang Molen, Pisang Goreng, Tahu Garing",
                totalTransaksi: "Rp 70.239",
              ),
              ItemTransactionWidget(
                tanggalTransaksi: "24 Mei 2023, 18:16",
                jenisPembayaran: "Tunai",
                jumlahMenu: "5 items",
                listMenu:
                    "Roti Bakar Keju, Tahu Isi, Pisang Molen, Pisang Goreng, Tahu Garing",
                totalTransaksi: "Rp 70.239",
              ),
              ItemTransactionWidget(
                tanggalTransaksi: "24 Mei 2023, 18:16",
                jenisPembayaran: "Tunai",
                jumlahMenu: "5 items",
                listMenu:
                    "Roti Bakar Keju, Tahu Isi, Pisang Molen, Pisang Goreng, Tahu Garing",
                totalTransaksi: "Rp 70.239",
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUserLoggedIn(),
        builder: ((context, _) => Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),

            // margin: EdgeInsets.symmetric(vertical: 20),
            // decoration: BoxDecoration(color: AppsColor.alternativeWhite),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w400,
                    // fontFamily: 'Rubik-Black'
                  ),
                  child: Text("Welcome,"),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 25,
                      color: AppsColor.alternativeWhite,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PT-Sans'),
                  child: Text(userLoggedIn?.nama_user ?? ''),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: CardContentWidget(),
                )
              ],
            ))));
  }
}

class CardContentWidget extends StatelessWidget {
  const CardContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);

    return FutureBuilder(
      future: loadUserLoggedIn(),
      builder: (context, _) => Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: DecorationImage(
                image: ImageUtils().loadMerchantLogo(userLoggedIn?.logo ?? ''),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              border: Border.all(
                color: AppsColor.alternativeWhite,
                width: .5,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 18,
                    color: AppsColor.alternativeWhite,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'PT-Sans',
                  ),
                  child: Text(userLoggedIn?.nama_merchant ?? 'PROGRAMMER'),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: AppsColor.alternativeWhite,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'PT-Sans',
                  ),
                  child: Text(userLoggedIn?.alamat ?? 'PROGRAMMER'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
