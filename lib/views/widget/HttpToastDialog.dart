import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:posumkm/main.dart';
import 'package:posumkm/views/widget/Redicrect.dart';

import '../../models/HttpResponseModel.dart';

void httpToastDialog(
  HttpResponseModel res,
  BuildContext context,
  ToastGravity gravity,
  Duration toastDuration,
  Duration fadeDuration,
) {
  final fToast = FToast().init(context);
  // var theme = Theme.of(context);

  Color? _color = Colors.red[900];
  IconData _icon = Icons.close_rounded;
  Color? _icon_color = AppsColor.alternativeWhite;

  if (res.code == 200 || res.code == 201) {
    _color = Colors.green[900];
    _icon = FontAwesomeIcons.circleCheck;
    _icon_color = AppsColor.alternativeWhite;
  }

  fToast.showToast(
      toastDuration: toastDuration,
      gravity: gravity,
      child: Container(
        padding: const EdgeInsets.all(5),
        // padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _icon,
                size: 12,
                color: _icon_color,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                res.message ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppsColor.alternativeWhite,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ));

  if (res.code == 302) {
    redirectLogout(context, "");
  }
}
