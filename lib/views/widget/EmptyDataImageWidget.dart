import 'package:flutter/material.dart';

Widget emptyDataWidget(BuildContext ctx) {
  return SingleChildScrollView(
    child: SizedBox(
      width: MediaQuery.of(ctx).size.width,
      child: Column(
        children: [
          Center(
            child: Image(
                width: MediaQuery.of(ctx).size.height * .5,
                image: const AssetImage("assets/images/empty-data-image.png")),
          ),
          Center(
            child: Text(
              "TIDAK ADA DATA",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Theme.of(ctx).colorScheme.onPrimaryContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}