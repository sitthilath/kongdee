
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StoreRecentSearch extends ChangeNotifier{
  final String key = "_recentSearch";
  SharedPreferences _prefs;
  List<String> _recentSearch=[];


  List<String> get recentSearch => _recentSearch;



  StoreRecentSearch() {
    _loadFromPrefs();
  }


  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _recentSearch = _prefs.getStringList(key) ?? [];
    notifyListeners();
  }

  _saveToPrefs()async {
    await _initPrefs();
    _prefs.setStringList(key, _recentSearch);
  }

  set recentSearch(val){
    if(_recentSearch.contains(val) || val.isEmpty){
      print("exist recentSearch");
    }else{
      _recentSearch.add(val);
      _saveToPrefs();
    }

    notifyListeners();
  }
}