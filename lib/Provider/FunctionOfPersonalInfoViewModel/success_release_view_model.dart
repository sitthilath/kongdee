
import 'package:buddhistauction/Model/success_release.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';



class SuccessReleaseViewModel extends ChangeNotifier {
  List<SuccessReleaseData> _successReleaseList = [];

  List<SuccessReleaseData> get successReleaseList => _successReleaseList;

  bool _isGrid=false;
  get isGrid=>_isGrid;
  setIsGrid(){
    _isGrid = !_isGrid;
    notifyListeners();
  }

  bool _isLoading = false;

  set successReleaseList(val){
    _successReleaseList.addAll(val);
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

  Future<void> fetchSuccessRelease(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      final response = await  ServiceApi.fetchSuccessRelease(pageKey);
      successReleaseList = response.data;
      _buddhistListMeta = response.meta;

    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }


}
