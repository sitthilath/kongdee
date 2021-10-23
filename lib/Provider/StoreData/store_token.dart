import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreTokenProvider extends ChangeNotifier{
  final String key = "_tokens";
  final String keyFcm = "_fcmTokens";
  SharedPreferences _prefs;

   String _tokens;
   String _fcmTokens;

  String get tokens => _tokens;
  String get fcmTokens => _fcmTokens;

  StoreTokenProvider(){
    _loadFromPrefsToken();
    _loadFromPrefsFCM();

  }

  setTokens(String tokens) {
    _tokens = tokens;
    _saveToPrefs();
    notifyListeners();
  }

  setFcmTokens(String fcmTokens) {
    _fcmTokens = fcmTokens;
    _saveToPrefsFCM();
    notifyListeners();
  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefsToken() async {
    await _initPrefs();
    _tokens = _prefs.getString(key) ?? '';

    notifyListeners();

  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setString(key, _tokens);

  }

  _loadFromPrefsFCM() async {
    await _initPrefs();

    _fcmTokens = _prefs.getString(keyFcm) ?? '';
    notifyListeners();
  }

  _saveToPrefsFCM() async{
    await _initPrefs();

    _prefs.setString(keyFcm, _fcmTokens);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Future<String> getFcmToken() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(keyFcm);
  // }




  void clearLocalStorageToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove(key);
  }

  void clearLocalStorageFcmToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove(keyFcm);
  }
}