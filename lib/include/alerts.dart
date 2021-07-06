import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class alerts{
  String getCurrentDate(){
    DateTime now = DateTime.now();
    String date = now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString()+" "+now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString();
    return date;
  }
  String getCurrentDateCodeFormat(){
    DateTime now = DateTime.now();
    String date = now.year.toString()+"/"+now.month.toString()+"/"+now.day.toString();
    return date;
  }
  void ErrorMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  void SuccessMessage(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}