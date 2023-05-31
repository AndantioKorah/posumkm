import 'package:flutter/material.dart';

import '../../main.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
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
          title: const Text("USER MANAGEMENT", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ) 
        ),
      ),
    );
  }
}