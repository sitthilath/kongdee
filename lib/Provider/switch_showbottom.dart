import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AutoAuctionProvider extends ChangeNotifier {
  final String key = "_autoAuction";
  SharedPreferences _prefs;
  bool _autoAuction=false;
  TextEditingController _priceController;

  bool get autoAuction => _autoAuction;
  TextEditingController get priceController => _priceController;


  AutoAuctionProvider() {
    _autoAuction = false;
    _loadFromPrefs();

  }

  toggleAutoAuction() {
    _autoAuction = !_autoAuction;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _autoAuction = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setBool(key, _autoAuction);
  }

  setPriceController(TextEditingController priceController){
    _priceController = priceController;
    notifyListeners();
  }
}




//-------------------------------------------------------------------------------
///class Select RadioButton
class SelectSendingProvider extends ChangeNotifier {




  final String key = "_sending_byself";
  SharedPreferences _prefs;
  // ignore: non_constant_identifier_names
  int _sending_byself=0;

  // ignore: non_constant_identifier_names
  int get sending_byself => _sending_byself;

  SelectSendingProvider() {
    _sending_byself = 0;
    _loadFromPrefs();
  }

  // ignore: non_constant_identifier_names
  Khoi_Ja_Ao_Bai_Pai_Sg() {
    //this _sending_byself is khoii ja ao bai pai sg
    _sending_byself = 1;
    _saveToPrefs();
    notifyListeners();
  }
  // ignore: non_constant_identifier_names
  Jut_Sg_Eng() {
    //this _sending_byself is jut sg eng
    _sending_byself = 0;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _sending_byself = _prefs.getInt(key) ?? 0;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setInt(key, _sending_byself);
  }
}

//------------------------------------------------------------------------------------
///class ToggleButton Notification if has someone auction morethan you
class NotificationIfHasSomeoneAuctionMoreProvider extends ChangeNotifier{


  final String key = "_autoNotification";
  SharedPreferences _prefs;
  bool _autoNotification;
  bool get autoNotification => _autoNotification;


  NotificationIfHasSomeoneAuctionMoreProvider() {

    _autoNotification = true;
    _loadFromPrefs();

  }

  toggleAutoNotification() {
    _autoNotification = !_autoNotification;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _autoNotification = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setBool(key, _autoNotification);
  }
}
