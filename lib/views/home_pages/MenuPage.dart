import 'package:flutter/material.dart';

import '../../main.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
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
            title: const Text("MASTER DATA MENU", style: BaseTextStyle.appBarTitle),
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
          body: const TabBarView(
            children: [
              Center(child: Text("Jenis"),),
              Center(child: Text("Kategori"),),
              Center(child: Text("Menu"),)
            ],)
        ),
      ),
    );
  }
}