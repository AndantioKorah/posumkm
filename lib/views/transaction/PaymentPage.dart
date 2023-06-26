import 'package:flutter/material.dart';
import '../../main.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sizeScreen = MediaQuery.of(context).size;

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
          title: const Text("PEMBAYARAN", style: BaseTextStyle.appBarTitle),
          centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: const InkWell(
                child: Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            )
          ]
        ),
        body: SafeArea(
          child: Container(
            color: Colors.grey[100],
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: sizeScreen.width * .45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Colors.blueGrey,
                          theme.colorScheme.onPrimaryContainer,
                        ])
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("TOTAL TAGIHAN", style: PaymentStyle.totTagihanText,),
                          const SizedBox(height: 2,),
                          const Text("Rp 213.142.231", style: PaymentStyle.totTagihanVal,),
                          const SizedBox(height: 5,),
                          const LineDividerWidget(color: Colors.white,),
                          const SizedBox(height: 5,),
                          Container(
                            child: Column(
                              children: [],
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     LineDividerWidget(color: Colors.white,)
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: sizeScreen.width * .45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Colors.blueGrey,
                          theme.colorScheme.onPrimaryContainer,
                        ])
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("TOTAL TAGIHAN", style: PaymentStyle.totTagihanText,),
                          const SizedBox(height: 2,),
                          const Text("Rp 213.142.231", style: PaymentStyle.totTagihanVal,),
                          const SizedBox(height: 5,),
                          const LineDividerWidget(color: Colors.white,),
                          const SizedBox(height: 5,),
                          Container(),
                          // Row(
                          //   children: [
                          //     LineDividerWidget(color: Colors.white,)
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentStyle {
  static const totTagihanText = TextStyle(
    fontFamily: "Poppins",
    fontSize: 12,
    color: Colors.white,
    // fontWeight: FontWeight.bold
  );

  static const totTagihanVal = TextStyle(
    fontFamily: "Poppins",
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold
  );
}