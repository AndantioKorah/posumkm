import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget emptyDataWidget(BuildContext ctx){
  return SingleChildScrollView(
    child: SizedBox(
      width: MediaQuery.of(ctx).size.width,
      child: Column(
        children: [
          Center(
            child: Image(
              width: MediaQuery.of(ctx).size.width * .6,
              image: const AssetImage("assets/images/empty-data-image.png")),
          ),
          Center(
            child: Text("TIDAK ADA DATA", 
            style: TextStyle(
              fontFamily: "Poppins",
              color: Theme.of(ctx).colorScheme.onPrimaryContainer,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),),)
        ],
      ),
    ),
  );
}