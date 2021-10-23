
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CountDownProvider extends ChangeNotifier{


  bool _isTimesUp=false;
  bool _isTimesLoading=true;
  bool _isTimesLoadingDetail=true;
  bool _isTimesLoadingType=true;
  bool _isTimesLoadingSearch=true;
  bool _isTimesLoadingRecommend=true;
  bool _isTimesLoadingFavorite=true;
  bool _isTimesLoadingSection=true;
  bool _isTimesLoadingAuctioning=true;
  bool _isTimesLoadingReleasing=true;

  bool get isTimesUp => _isTimesUp;
  bool get isTimesLoading => _isTimesLoading;
  bool get isTimesLoadingDetail => _isTimesLoadingDetail;
  bool get isTimesLoadingType => _isTimesLoadingType;
  bool get isTimesLoadingSearch => _isTimesLoadingSearch;
  bool get isTimesLoadingRecommend => _isTimesLoadingRecommend;
  bool get isTimesLoadingFavorite => _isTimesLoadingFavorite;
  bool get isTimesLoadingSection=>_isTimesLoadingSection;
  bool get isTimesLoadingAuctioning=>_isTimesLoadingAuctioning;
  bool get isTimesLoadingReleasing=>_isTimesLoadingReleasing;


  set isTimesLoadingReleasing(bool isTimesLoadingReleasing){
    _isTimesLoadingReleasing = isTimesLoadingReleasing;
    notifyListeners();
  }
  set isTimesLoadingAuctioning(bool isTimesLoadingAuctioning){
    _isTimesLoadingAuctioning = isTimesLoadingAuctioning;
    notifyListeners();
  }
  set isTimesLoadingSection(bool isTimesLoadingSection){
    _isTimesLoadingSection = isTimesLoadingSection;
    notifyListeners();
  }

  set isTimesLoadingFavorite(bool isTimesLoadingFavorite){
    _isTimesLoadingFavorite = isTimesLoadingFavorite;
    notifyListeners();
  }


  set isTimesLoadingRecommend(bool isTimesLoadingRecommend){
    _isTimesLoadingRecommend = isTimesLoadingRecommend;
    notifyListeners();
  }

  set isTimesLoadingSearch(bool isTimesLoadingSearch){
    _isTimesLoadingSearch = isTimesLoadingSearch;
    notifyListeners();
  }

  set isTimesLoadingType(bool isTimesLoadingType){
    _isTimesLoadingType = isTimesLoadingType;
    notifyListeners();
  }

  set isTimesLoadingDetail(bool isTimesLoadingDetail){
    _isTimesLoadingDetail = isTimesLoadingDetail;
    notifyListeners();
  }

  set isTimesLoading(bool isTimesLoading){
    _isTimesLoading = isTimesLoading;
    notifyListeners();
  }


  setIsTimesUp(bool isTimesUp){
    _isTimesUp = isTimesUp;
    notifyListeners();
  }






}