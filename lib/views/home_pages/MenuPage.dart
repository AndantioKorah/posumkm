import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posumkm/models/HttpResponseModel.dart';
import 'package:posumkm/models/JenisMenuModel.dart';

import '../../controllers/api/MasterController.dart';
import '../../main.dart';
import '../widget/HttpToastDialog.dart';

List<JenisMenuModel> _listJenisMenu = [];

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  Future<void> _getAllJenisMenu() async {
    final rs = await MasterController.getAllJenisMenu();
    if(rs.code == 200){
      _listJenisMenu = rs.data;
    } else {

    }
  }

  Future<HttpResponseModel> _refreshJenisMenu() async {
    HttpResponseModel rs = await MasterController.getAllJenisMenu();
    _listJenisMenu = rs.data;
    setState(() {});
    return rs;
  }

  Future<void> _refreshMasterMenu() async {
    HttpResponseModel rs = await MasterController.getAllMasterMenu();
    print("endpoint: ${rs.data.toString()}");
    // setState(() {});
    // return rs;
  }

  @override
  void initState() {
    super.initState();
    _getAllJenisMenu();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              backgroundColor: theme.colorScheme.onPrimaryContainer,
              title: const Text("MASTER DATA MENU",
                  style: BaseTextStyle.appBarTitle),
              centerTitle: true,
              bottom: const TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: "Jenis"),
                  Tab(text: "Kategori"),
                  Tab(text: "Menu"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: [
                    Container(
                      // height: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      width: double.infinity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // InkWell(
                            //   child: CustomButton(
                            //     color: Colors.amber[900],
                            //     text: "Tambah",
                            //     icon: Icons.add_rounded,
                            //     colorText: Colors.white,
                            //   ),
                            // ),
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
                                        offset: Offset(1, 4),
                                      )
                                    ]),
                                child: const TextField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                      fontSize: 14),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(right: 10, top: 8),
                                      border: InputBorder.none,
                                      hintText: "Cari Data",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Poppins",
                                      ),
                                      prefixIcon: Icon(Icons.search_rounded),
                                      prefixIconColor: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () => _refreshMasterMenu(),
                                // onTap: () =>
                                    // _refreshJenisMenu().then((value) => {
                                    //       if (value.code != 200)
                                    //         {
                                    //           AwesomeDialog(
                                    //                   context: context,
                                    //                   dialogType:
                                    //                       DialogType.ERROR,
                                    //                   animType: AnimType.SCALE,
                                    //                   title: "ERROR",
                                    //                   desc: value.message,
                                    //                   showCloseIcon: true,
                                    //                   btnOkText: "Tutup",
                                    //                   btnOkColor: Colors.red,
                                    //                   btnOkOnPress: () {})
                                    //               .show()
                                    //         }
                                    //       else
                                    //         {
                                    //           httpToastDialog(
                                    //               value,
                                    //               context,
                                    //               ToastGravity.BOTTOM,
                                    //               const Duration(seconds: 2),
                                    //               const Duration(
                                    //                   milliseconds: 100)),
                                    //         }
                                    //     }),
                                child: CustomButton(
                                  color: Colors.green[900],
                                  text: "Refresh",
                                  icon: Icons.refresh_rounded,
                                  colorText: Colors.white,
                                ))
                          ]),
                    ),
                    const Divider(
                        height: 10, thickness: 1, color: Colors.white),
                    Row(
                      children: [
                        Expanded(
                            child: FutureBuilder(
                          future: _getAllJenisMenu(),
                          builder: (context, _) {
                            return jenisMenuItem(_listJenisMenu);
                          },
                        ))
                      ],
                    ),
                  ],
                ),
                const Center(
                  child: Text("Kategori"),
                ),
                const Center(
                  child: Text("Menu"),
                )
              ],
            )),
      ),
    );
  }
}

Widget jenisMenuItem(List<JenisMenuModel>? data) => ListView.builder(
      shrinkWrap: true,
      itemCount: _listJenisMenu.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 238, 238, 238)),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(1, 4),
                      )
                    ]),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      width: MediaQuery.of(context).size.width * .65,
                      child: Text(
                        _listJenisMenu[index].nama_jenis_menu,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.edit_rounded,
                            size: 25,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          child: Icon(
                            Icons.delete_rounded,
                            size: 25,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? colorText;
  final IconData icon;

  const CustomButton(
      {super.key,
      required this.text,
      required this.color,
      required this.icon,
      this.colorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: colorText,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
                color: colorText, fontSize: 12, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
