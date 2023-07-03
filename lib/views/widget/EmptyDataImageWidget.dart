import 'package:flutter/material.dart';
import 'package:posumkm/main.dart';

Widget emptyDataWidget(BuildContext ctx, Function()? callbackRefresh) {
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
          callbackRefresh != null
              ? InkWell(
                  onTap: () => {callbackRefresh()},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(5),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 15,
                          color: AppsColor.alternativeWhite,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Refresh",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppsColor.alternativeWhite,
                              fontSize: 15,
                              fontFamily: "Poppins"),
                        )
                      ],
                    ),
                  ),
                )
              : const Text("")
        ],
      ),
    ),
  );
}
