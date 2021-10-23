
import 'package:buddhistauction/Model/item_auctioning.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';


class ItemAuctioningViewModel extends ChangeNotifier {
  List<ItemAuctioningData> _itemAuctioningList = [];

  List<ItemAuctioningData> get itemAuctioningList => _itemAuctioningList;

  List<int> _remainTime=[];

  List<int> get remainTime => _remainTime;

  bool _isGrid = false;
  get isGrid => _isGrid;

  setIsGrid(){
    _isGrid = !_isGrid;
    notifyListeners();
  }

  bool _isTimeLoading = true;

  bool get isTimeLoading => _isTimeLoading;

  set itemAuctioningList(val){
    _itemAuctioningList.addAll(val);
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

  Future<void> fetchItemAuctioning(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }

    try {
      final response = await  ServiceApi.fetchItemAuctioning(pageKey);
      itemAuctioningList = response.data;
      _buddhistListMeta = response.meta;

      for(int i=0;i<response.data.length;i++){
        _remainTime.add(response.data[i].timeRemain);
      }
      _remainTime.toList();
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }


}
