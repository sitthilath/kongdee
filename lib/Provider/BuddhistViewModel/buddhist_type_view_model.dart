import 'package:buddhistauction/Model/buddhist_type_id.dart';

import 'package:buddhistauction/Service/service_api.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class BuddhistTypeViewModel extends ChangeNotifier {

  List<Datum> _buddhistTypeListOnSearch=[];
  List<Datum> get buddhistTypeListOnSearch => _buddhistTypeListOnSearch;


  set buddhistTypeListOnSearch(value){
    _buddhistTypeListOnSearch = value;
    notifyListeners();
  }


  int _typeId;

  int get typeId=>_typeId;

  set typeId(val){
    _typeId = val;
    notifyListeners();
  }

  String _typeName;

  String get typeName=>_typeName;

  set typeName(val){
    _typeName = val;
    notifyListeners();
  }

  bool _isLoading = false;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  get isLoading => _isLoading;


  List<Datum> _pagingItemList = [];

  Meta _buddhistListMeta;

  Meta get buddhistListMeta => _buddhistListMeta;

  List<Datum>  get pagingItemList => _pagingItemList;

  set pagingItemList(val) {
    _pagingItemList.addAll(val);
  }

  bool _isLoadingPage = false;

  get isLoadingPage => _isLoadingPage;

  set isLoadingPage(val) {
    _isLoadingPage = val;
    notifyListeners();
  }

  bool _isLastPage = false;
  get isLastPage => _isLastPage;

  set isLastPage(val) {
    _isLastPage = val;
    notifyListeners();
  }



  Future<void> fetchBuddhistType(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }

    try {
      final response = await ServiceApi.fetchBuddhistListType(_typeId.toString(),pageKey);
      pagingItemList = response.data;
      _buddhistListMeta = response.meta;

    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }



}
