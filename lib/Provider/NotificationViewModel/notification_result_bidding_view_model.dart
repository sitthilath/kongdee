
import 'package:buddhistauction/Model/buddhist_notification.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';



class NotificationResultBiddingViewModel extends ChangeNotifier {
  List<Datum> _notificationResultBiddingList = [];
  int _notificationBidResultCount=0;
  bool _isLoading = false;
  bool _notificationBidResultShow=false;

  List<Datum> get notificationResultBiddingList => _notificationResultBiddingList;
int get notificationBidResultCount=>_notificationBidResultCount;
  get isLoading => _isLoading;
  bool get notificationBidResultShow=>_notificationBidResultShow;

  set notificationResultBiddingList(val){
    _notificationResultBiddingList.addAll(val);
    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }


  set notificationBidResultCount(val) {
    _notificationBidResultCount = val;
    notifyListeners();
  }

  set notificationBidResultShow(val) {
    _notificationBidResultShow = val;
    notifyListeners();
  }

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

  Future<void> fetchBiddingResultNotification(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      final response = await  ServiceApi.fetchBiddingResultNotification(pageKey);
      notificationResultBiddingList = response.data;
      _buddhistListMeta = response.meta;
      final bidResultCount = await  ServiceApi.fetchBiddingResultNotificationCount();
      notificationBidResultCount = bidResultCount.notificationCount;

    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage=false;
    }
  }


}
