
import 'package:flutter/material.dart';

class StoreTextForgetPasswordProvider extends ChangeNotifier{
  String _password,_phoneNo;


  String get password => _password;
  String get phoneNo => _phoneNo;


  setPassword(String password){
    _password = password;
    notifyListeners();
  }

  setPhoneNo(String phoneNo){
    _phoneNo = phoneNo;
    notifyListeners();
  }


}