
import 'package:flutter/material.dart';

class StoreOtpNumber extends ChangeNotifier{
  String _otp1,_otp2,_otp3,_otp4,_otp5,_otp6;


  String get otp1 => _otp1;
  String get otp2 => _otp2;
  String get otp3 => _otp3;
  String get otp4 => _otp4;
  String get otp5 => _otp5;
  String get otp6 => _otp6;




 set otp1(val){
   _otp1 = val;
    notifyListeners();
  }

  set otp2(val){
    _otp2 = val;
    notifyListeners();
  }

  set otp3(val){
    _otp3 = val;
    notifyListeners();
  }

  set otp4(val){
    _otp4 = val;
    notifyListeners();
  }

  set otp5(val){
    _otp5 = val;
    notifyListeners();
  }

  set otp6(val){
    _otp6 = val;
    notifyListeners();
  }

}