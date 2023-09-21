import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posumkm/controllers/api/UserController.dart';
import 'package:posumkm/models/UserModel.dart';
import 'package:posumkm/views/widget/LoadingImageWidget.dart';

import '../../main.dart';
import '../../models/HttpResponseModel.dart';
import '../widget/HttpToastDialog.dart';
import '../widget/Redicrect.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool _showLoader = true;
  List<UserModel> listUser = [];
  
  Future<void> getAllMerchantUser() async {
    setState((){
      _showLoader = true;
    });
    HttpResponseModel rs = await UserController.getAllMerchantUsers();
    // ignore: unnecessary_null_comparison
    if(rs != null){
      if(rs.code == 200){
        // print(rs.data.toString());
        setState((){
          if(rs.data.length > 0){
            listUser = convertToList(rs.data);
          }
        });
      } else if (rs.code == 302) {
        // ignore: use_build_context_synchronously
        redirectLogout(context, rs.message!);
      } else {
        // ignore: use_build_context_synchronously
        httpToastDialog(
          rs, 
          context, 
          ToastGravity.BOTTOM, 
          const Duration(seconds: 2), 
          const Duration(seconds: 2));
      } 
    }
    setState((){
      _showLoader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllMerchantUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
          title: const Text("USER MANAGEMENT", style: BaseTextStyle.appBarTitle),
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  getAllMerchantUser();
                },
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: AppsColor.alternativeWhite,
                ),
              ),
            )
          ],
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            color: AppsColor.alternativeWhite,
            height: double.infinity,
            width: double.infinity,
            child: _showLoader ?
            loadingDataWidget(context):
            Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listUser.length,
                itemBuilder: (context, index){
                  return Container(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Row(
                          children: [
                            
                          ],
                        );
                      }),
                  );
                }
              ),
            ),
          ) 
        ),
      ),
    );
  }
}