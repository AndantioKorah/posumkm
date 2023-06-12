import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingDataWidget(BuildContext ctx){
  return SingleChildScrollView(
    child: SizedBox(
      width: MediaQuery.of(ctx).size.width,
      child: Column(
        children: [
          Center(
            child: Image(
              width: MediaQuery.of(ctx).size.width * .6,
              image: const AssetImage("assets/images/loading-image.png")),
          ),
          Center(
            child: SpinKitSpinningLines(
              size: 15,
              color: Theme.of(ctx).colorScheme.onPrimaryContainer,
            ),
          ),
          Center(
            child: Text("retrieving data from server", 
            style: TextStyle(
              fontFamily: "Poppins",
              color: Theme.of(ctx).colorScheme.onPrimaryContainer,
              fontSize: 10,
              // fontWeight: FontWeight.bold
            ),),)
        ],
      ),
    ),
  );
}