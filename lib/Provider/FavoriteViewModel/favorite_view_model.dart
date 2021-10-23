import 'package:buddhistauction/Model/buddhist_favorite.dart';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class FavoriteViewModel extends ChangeNotifier {
  List<FavoriteInfo> _buddhistFavoriteList = [];

  List<FavoriteInfo> get buddhistFavoriteList => _buddhistFavoriteList;

  set buddhistFavoriteList(val){
    _buddhistFavoriteList.addAll(val);
    notifyListeners();
  }


  bool _isLoading = false;
  bool _isGrid = false;

  get isGrid => _isGrid;

  setIsGrid(){
    _isGrid = !_isGrid;
    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  get isLoading => _isLoading;

  Meta _buddhistListMeta;

  Meta get buddhistListMeta => _buddhistListMeta;


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

  Future<void> fetchFavorite(BuildContext context,int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }

    try {
      final response = await ServiceApi.fetchFavorite(context,pageKey);
      buddhistFavoriteList = response.data;
      _buddhistListMeta = response.meta;


    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }


}
