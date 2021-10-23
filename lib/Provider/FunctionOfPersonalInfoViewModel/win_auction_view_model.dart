
import 'package:buddhistauction/Model/win_auction.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';



class WinAuctionViewModel extends ChangeNotifier {
  List<WinAuctionData> _winAuctionList = [];

  List<WinAuctionData> get winAuctionList => _winAuctionList;


  bool _isGrid=false;
  get isGrid=>_isGrid;
  setIsGrid(){
    _isGrid = !_isGrid;
    notifyListeners();
  }
  bool _isLoading = false;

  set winAuctionList(val){
    _winAuctionList.addAll(val);
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

  Future<void> fetchWinAuction(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }

    try {
      final response = await  ServiceApi.fetchWinAuction(pageKey);
      winAuctionList = response.data;
      _buddhistListMeta = response.meta;

    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage = false;
    }
  }


}
