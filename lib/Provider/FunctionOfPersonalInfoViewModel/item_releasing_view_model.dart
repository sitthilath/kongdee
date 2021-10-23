
import 'package:buddhistauction/Model/releasing.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';



class ItemReleasingViewModel extends ChangeNotifier {
  List<ReleasingData> _itemReleasingList = [];

  List<ReleasingData> get itemReleasingList => _itemReleasingList;

  List<int> _remainTime=[];

  List<int> get remainTime => _remainTime;

  bool _isGrid=false;
  get isGrid=>_isGrid;
  setIsGrid(){
    _isGrid = !_isGrid;
    notifyListeners();
  }

  bool _isTimeLoading = true;

  bool get isTimeLoading => _isTimeLoading;

  set itemReleasingList(val){
    _itemReleasingList.addAll(val);
    notifyListeners();
  }

  set isTimeLoading(value){
    _isTimeLoading = value;
    notifyListeners();
  }

  bool _isLoading = false;

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

  Future<void> fetchReleasing(int pageKey) async {
    isLoading = true;

    try {
      final response = await  ServiceApi.fetchReleasing(pageKey);
      itemReleasingList = response.data;
      _buddhistListMeta = response.meta;

      for(int i=0;i<response.data.length;i++){
        _remainTime.add(response.data[i].timeRemain);

      }
      _remainTime.toList();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }


}
