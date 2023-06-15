import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posumkm/views/widget/HttpToastDialog.dart';

ConfirmationDialogRest(
  BuildContext context,
  DialogType type,
  String title, description,
  Function okFunction
){
  return AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.TOPSLIDE,
    title: title,
    desc: description,
    showCloseIcon: true,
    // btnOkText: "Tutup",
    // btnOkColor: Colors.red,
    btnOkOnPress: () => okFunction().then((value) {
      httpToastDialog(
        value, context, ToastGravity.BOTTOM, const Duration(seconds: 3), const Duration(seconds: 3)
      );
      if(value.code == 200){
        Navigator.of(context).pop();
      }
    }),
    btnCancelOnPress: () {},
  ).show();
}