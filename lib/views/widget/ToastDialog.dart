import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastDialog{
  late BuildContext context;
  late String message;
  late IconData icon;
  Color color;
  ToastGravity gravity;

  ToastDialog({
    required this.context,
    required this.message,
    required this.icon,
    required this.color,
    required this.gravity,
  });


  void showDialog(){
    final fToast = FToast().init(context);
    var theme = Theme.of(context);

    // color = theme.colorScheme.onPrimaryContainer;

    fToast.showToast(
      gravity: gravity,
      child: 
      Container(
        // padding: EdgeInsets.symmetric(ver: 10),
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ), child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 10,
              color: color,
            ),
            const SizedBox(width: 5,),
            Text(message, style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
            ),)
          ],
        ),
      )  
    );
  }
}