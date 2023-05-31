// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/views/home_pages/LaporanPage.dart';
import 'package:posumkm/views/home_pages/MenuPage.dart';
import 'package:posumkm/views/home_pages/UserManagementPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // var sizeScreen = MediaQuery.of(context).size;

    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: MenusWidget(),
    );
  }
}

class MenusWidget extends StatefulWidget {
  const MenusWidget({super.key});

  @override
  State<MenusWidget> createState() => _MenusWidgetState();
}

class MenuList {
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
          MerchantMenuWidget(),
        ],
      ),
    );
  }
}

class MerchantMenuWidget extends StatefulWidget {
  const MerchantMenuWidget({super.key});

  @override
  State<MerchantMenuWidget> createState() => _MerchantMenuWidgetState();
}

class _MerchantMenuWidgetState extends State<MerchantMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, 
                  PageTransition(
                    child: LaporanPage(), 
                    type: PageTransitionType.bottomToTop
                  )
                );
              },
              child: CustomButton(
                text: "Laporan",
                icon: Icons.summarize_rounded,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, 
                  PageTransition(
                    child: MenuPage(), 
                    type: PageTransitionType.bottomToTop
                  )
                );
              },
              child: CustomButton(
                text: "Menu",
                icon: Icons.menu_book_rounded,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, 
                  PageTransition(
                    child: UserManagementPage(), 
                    type: PageTransitionType.bottomToTop
                  )
                );
              },
              child: CustomButton(
                text: "User",
                icon: Icons.manage_accounts_rounded,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class CustomButton extends StatefulWidget {
  final String text;
  final IconData icon;
  // final Widget page;

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    // required this.page
  });

  @override
  State<CustomButton> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: sizeScreen.width * 0.28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 248, 248, 248),
        borderRadius: BorderRadius.circular(5),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 1,
        //     blurRadius: 1,
        //     offset: Offset(1, 2), 
        //   )
        // ]
      ),
      child: Column(
        children: [
          Icon(
            widget.icon,
            color: theme.colorScheme.onPrimaryContainer,
            size: 35,
          ), 
          Text(widget.text, style: BaseTextStyle.gridTextButton,)
      ]),
    );
  }
}