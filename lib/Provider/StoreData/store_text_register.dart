import 'package:flutter/cupertino.dart';

class StoreTextRegisterProvider extends ChangeNotifier{
  String _name,_surname,_date,_password,_phoneNo,_village,_district,_province;

  String get name => _name;
  String get surname => _surname;
  String get date => _date;
  String get password => _password;
  String get phoneNo => _phoneNo;
  String get village => _village;
  String get district => _district;
  String get province => _province;

  setName(String name){
    _name = name;
    notifyListeners();
  }

  setSurname(String surname){
    _surname = surname;
    notifyListeners();
  }

  setDate(String date){
    _date = date;
    notifyListeners();
  }

  setPassword(String password){
    _password = password;
    notifyListeners();
  }

  setPhoneNo(String phoneNo){
    _phoneNo = phoneNo;
    notifyListeners();
  }

  setVillage(String village){
    _village = village;
    notifyListeners();
  }

  setDistrict(String district){
    _district = district;
    notifyListeners();
  }

  setProvince(String province){
    _province = province;
    notifyListeners();
  }
}