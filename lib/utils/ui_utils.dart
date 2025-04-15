import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtils {
  BuildContext context;
  UiUtils(this.context);

  static showToast(String message){
    return Fluttertoast.showToast(msg: message);
  }

  showSnackBar(String message){
    ScaffoldMessengerState? scaffoldMessengerState = ScaffoldMessenger.maybeOf(context);
    if(scaffoldMessengerState == null){
      return showToast(message);
    }else{
      return scaffoldMessengerState.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}