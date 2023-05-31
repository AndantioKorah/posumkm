import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:toast/toast.dart';

import '../../controllers/api/UserController.dart';
import 'HttpToastDialog.dart';


void showChangePasswordDialog(BuildContext context){
  var theme = Theme.of(context);

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();
  final RoundedLoadingButtonController buttonSumbit = RoundedLoadingButtonController();

  AwesomeDialog(
    context: context,
    animType: AnimType.BOTTOMSLIDE,
    dialogType: DialogType.NO_HEADER,
    // showCloseIcon: true,
    autoDismiss: false,
    onDissmissCallback: (_) {},
    body: Column(
      children: [
        Row(
          children: [
            Expanded(child: 
              Stack(
                children: [
                  Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold
                      ),
                      child: Text("GANTI PASSWORD"),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 15,
                        color: Colors.black,
                      ),
                    )
                  )
                ],
              )
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    )),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Password Lama',
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.lock_clock_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: oldPassword,
                ),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    )),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Password Baru',
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: newPassword,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    )),
                child: TextField(
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      hintText: 'Konfirmasi Password Baru',
                      prefixIcon: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  controller: confirmNewPassword,
                ),
              ),
            ),
          ],
        )
      ],
    ),
    btnOk: SizedBox(
      width: double.infinity,
      child: RoundedLoadingButton(
        height: 45,
        color: theme.colorScheme.onPrimaryContainer,
        controller: buttonSumbit,
        resetDuration: const Duration(seconds: 3),
        resetAfterDuration: true,
        child: const Text(
          "Submit", 
          style: TextStyle(
            color: Colors.white),
        ),
        onPressed: () => {
          UserController.changePasswordFunction(
            oldPassword.text, 
            newPassword.text, 
            confirmNewPassword.text
          ).then((value) => {
            oldPassword.clear(),
            newPassword.clear(),
            confirmNewPassword.clear(),
            httpToastDialog(
              value, context, 
              ToastGravity.BOTTOM, 
              const Duration(seconds: 2),
              const Duration(milliseconds: 100)
            ),
            if(value.code == 200){
              Navigator.pop(context)
            }
          })
        }
      ),
    ),
    // btnOkOnPress: () => _attemptChangePassword(
    //   oldPassword.text, 
    //   newPassword.text, 
    //   confirmNewPassword.text, 
    //   context),
    // onDissmissCallback: ,
    btnOkText: "SUBMIT",
    ).show();
}