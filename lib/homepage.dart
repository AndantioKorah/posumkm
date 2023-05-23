// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: MenusWidget(),
      ),
    );
  }
}

class MasterDataWidget extends StatefulWidget{
  const MasterDataWidget({super.key});

  @override
  State<MasterDataWidget> createState() => _MasterDataWidgetState();
}

class MenusWidget extends StatefulWidget{
  const MenusWidget({super.key});

  @override
  State<MenusWidget> createState() => _MenusWidgetState();
}

class _MasterDataWidgetState extends State<MasterDataWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<MenuList> menuMasterData = [
      MenuList(1, "Menu", Icons.menu_book),
      MenuList(2, "User", FontAwesomeIcons.userGear),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Master Data", 
        style: BaseTextStyle.gridTextDivider,
      ),
      // SizedBox(
      //   height: 10,
      // ),
      GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 50,
          mainAxisSpacing: 10
        ),
        itemCount: menuMasterData.length,
        itemBuilder: (context, index) {
          return TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:  CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  menuMasterData[index].icon,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 25,
                ),
                SizedBox(height: 10,),
                Text(
                  menuMasterData[index].title,
                  style: BaseTextStyle.gridItemText
                )
              ],
            ),
          );
        },
      ),
      ]
    );
  }
}

class MenuList{
  int menuId;
  String title;
  IconData icon;

  MenuList(this.menuId, this.title, this.icon);
}

class _MenusWidgetState extends State<MenusWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          MasterDataWidget()
        ],
      ),
    );
  }
}