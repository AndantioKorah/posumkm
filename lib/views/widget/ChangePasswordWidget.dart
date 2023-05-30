import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../controllers/api/UserController.dart';

void showChangePasswordDialog(BuildContext context){
  var theme = Theme.of(context);
  final TextEditingController _old_password = TextEditingController();
  final TextEditingController _new_password = TextEditingController();
  final TextEditingController _confirm_new_password = TextEditingController();
  
  AwesomeDialog(
    context: context,
    animType: AnimType.BOTTOMSLIDE,
    dialogType: DialogType.NO_HEADER,
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
                  controller: _old_password,
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
                  controller: _new_password,
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
                  controller: _confirm_new_password,
                ),
              ),
            ),
          ],
        )
      ],
    ),
    btnOkOnPress: () => UserController.changePasswordFunction(
      _old_password.text, 
      _new_password.text, 
      _confirm_new_password.text).then((value) => print(value)),
    btnOkText: "SUBMIT",
    ).show();
}