
import 'package:buddhistauction/Model/fail_release.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';



class FailReleaseViewModel extends ChangeNotifier {
  List<FailReleaseData> _failReleaseList = [];

  List<FailReleaseData> get failReleaseList => _failReleaseList;

  set failReleaseList(val){
    _failReleaseList.addAll(val);
    notifyListeners();
  }

  bool _isLoading = false;
  bool _isGrid = false;
  get isGrid=>_isGrid;
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

  Future<void> fetchFailRelease(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      final response = await  ServiceApi.fetchFailRelease(pageKey);
      failReleaseList = response.data;
      _buddhistListMeta = response.meta;


    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }


}
