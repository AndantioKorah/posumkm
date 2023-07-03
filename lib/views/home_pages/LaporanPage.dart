import 'package:flutter/material.dart';

import '../../main.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
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
                color: AppsColor.alternativeWhite,
              ),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          title: const Text("LAPORAN", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Container(
          color: AppsColor.alternativeWhite,
          height: double.infinity,
          width: double.infinity,
        )),
      ),
    );
  }
}
