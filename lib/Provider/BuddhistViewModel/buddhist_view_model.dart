import 'dart:async';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:buddhistauction/Model/buddhist_bottom_search.dart'
    as buddhistBottomSearchModel;

import 'package:buddhistauction/Model/buddhist_type.dart' as buddhistTypeModel;


class BuddhistViewModel extends ChangeNotifier {

  List<buddhistBottomSearchModel.Datum> _buddhistList = [];
  List<buddhistBottomSearchModel.Datum> _buddhistListPopular = [];
  List<buddhistBottomSearchModel.Datum> _buddhistListTimeLower = [];
  List<buddhistBottomSearchModel.Datum> _buddhistListNewItem = [];
  List<buddhistTypeModel.Datum> _buddhistTypeList = [];

  List<buddhistBottomSearchModel.Datum> get buddhistList => _buddhistList;

  List<buddhistBottomSearchModel.Datum> get buddhistListPopular =>
      _buddhistListPopular;

  List<buddhistBottomSearchModel.Datum> get buddhistListTimeLower =>
      _buddhistListTimeLower;

  List<buddhistBottomSearchModel.Datum> get buddhistListOnSearch =>
      _buddhistListNewItem;

  List<buddhistTypeModel.Datum> get buddhistTypeList => _buddhistTypeList;



  bool _isLoading = true;
  bool _isTimeLoading = true;
  bool _isPriceLoading = false;
  bool _isGrid=false;

  get isGrid=> _isGrid;

  setIsGrid(){
    _isGrid = !_isGrid;
    notifyListeners();
  }

  get isPriceLoading => _isPriceLoading;
  set isPriceLoading(val){
    _isPriceLoading = val;
    notifyListeners();
  }

  get isLoading => _isLoading;

  bool get isTimeLoading => _isTimeLoading;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set isTimeLoading(value) {
    _isTimeLoading = value;
    notifyListeners();
  }

  Future<void> fetchBuddhists(BuildContext context) async {
    isLoading = true;

    try {
      //add List Model

      final response = await ServiceApi.fetchBuddhistBottomSearch(1);
      _buddhistList = response.data;

      final responsePopular =
          await ServiceApi.fetchBuddhistBottomSearchPopular(1);
      _buddhistListPopular = responsePopular.data;
      final responseTimeLower =
          await ServiceApi.fetchBuddhistBottomSearchTimeLower(1);
      _buddhistListTimeLower = responseTimeLower.data;
      final responseType = await ServiceApi.fetchBuddhistType();
      _buddhistTypeList = responseType.data;

      //Cache image
      await Future.wait(_buddhistTypeList
          .map((urlImage) => cacheImage(context, urlImage.imagePath))
          .toList());
      for (int i = 0; i < _buddhistList.length; i++) {
        await Future.wait(_buddhistList[i]
            .image
            .map((urlImage) => cacheImage(context, urlImage))
            .toList());
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  //Pagination Buddhist On Section Page

  List<buddhistBottomSearchModel.Datum> _pagingItemList = [];

  buddhistBottomSearchModel.Meta _buddhistListMeta;

  buddhistBottomSearchModel.Meta get buddhistListMeta => _buddhistListMeta;

  List<buddhistBottomSearchModel.Datum>  get pagingItemList => _pagingItemList;

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



  Future<void> fetchBuddhistsSectionNewItem(
        int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      //add List Model

      final response = await ServiceApi.fetchBuddhistBottomSearch(pageKey);

      pagingItemList = response.data;
      _buddhistListMeta = response.meta;


    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }

  Future<void> fetchBuddhistsSectionPopular(
        int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      //add List Model

      final responsePopular =
          await ServiceApi.fetchBuddhistBottomSearchPopular(pageKey);

      pagingItemList = responsePopular.data;
      _buddhistListMeta = responsePopular.meta;


    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }

  Future<void> fetchBuddhistsSectionTimeLower(
        int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      //add List Model

      final responseTimeLower =
          await ServiceApi.fetchBuddhistBottomSearchTimeLower(pageKey);

      pagingItemList = responseTimeLower.data;
      _buddhistListMeta = responseTimeLower.meta;


    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }

  //Search

  List<buddhistBottomSearchModel.Datum> _searchList=[];
  get searchList => _searchList;
  bool _isSearch = false;

  get isSearch => _isSearch;

  set isSearch(val) {
    _isSearch = val;
    notifyListeners();
  }


  Future<void> fetchSearching( String input) async {

      isLoading = true;

    try {
      //add List Model

      final response =
      await ServiceApi.fetchBuddhistForSearching(input);

      _searchList = response.data;



    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }

  Future cacheImage(BuildContext context, String urlImage) =>
      precacheImage(CachedNetworkImageProvider(urlImage), context);
}
