import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posumkm/controllers/api/MasterController.dart';
import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../widget/HttpToastDialog.dart';

class EditMasterMenu{
  final TextEditingController _namaJenisController = TextEditingController();
  final RoundedLoadingButtonController _buttonSaveController = RoundedLoadingButtonController();

  void editDataJenis(JenisMenuModel item,
  BuildContext context,
  Function callbackFunction){
    _namaJenisController.text = item.nama_jenis_menu;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 15,
                right: 15,
                bottom: 30
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width * .2,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  const Align(
                    child: Text("EDIT MASTER JENIS", style: styleText.labelTitle,),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    autofocus: true,
                    style: styleText.valueEditMaster,
                    controller: _namaJenisController,
                    decoration: InputDecoration(
                      labelText: "Nama Jenis Makanan",
                      labelStyle: styleText.labelEditMaster,
                      focusColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // InkWell(
                  //   child: buttonSave(context)
                  // ),
                  RoundedLoadingButton(
                    // resetAfterDuration: true,
                    // resetDuration: const Duration(seconds: 3),
                    borderRadius: 5,
                    height: 45,
                    controller: _buttonSaveController,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    onPressed: () {
                      MasterController.editMasterJenis(
                        _namaJenisController.text,
                        item.id
                      ).then((value) => {
                        _buttonSaveController.reset(),
                        httpToastDialog(
                          value,
                          context,
                          ToastGravity.BOTTOM,
                          const Duration(seconds: 3),
                          const Duration(seconds: 3),
                        ),
                        if(value.code == 200){
                          callbackFunction(""),
                          Navigator.of(context).pop()
                        }
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save_as_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 5,),
                        Text("Simpan", style: styleText.labelSaveButton,)
                      ]
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }
    );
  }
}

class styleText{
  static final labelEditMaster = TextStyle(
    fontSize: 14,
    color: Colors.grey[900],
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

  static const valueEditMaster = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

  static const labelTitle = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );

  static const labelSaveButton = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins"
  );
}

Widget buttonSave(BuildContext ctx){
  return Wrap(
    children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(5)
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_as_rounded,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 5,),
            Text("Simpan", style: styleText.labelSaveButton,)
          ],
        ),
      )
    ],
  );
}