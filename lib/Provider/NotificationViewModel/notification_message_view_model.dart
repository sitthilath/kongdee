
import 'package:buddhistauction/Model/buddhist_notification.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';



class NotificationMessageViewModel extends ChangeNotifier {
  List<Datum> _notificationMessageList = [];
  bool _isLoading = false;
  int _notificationMessCount=0;
  bool _notificationMessShow = false;

  List<Datum> get notificationMessageList => _notificationMessageList;
  get isLoading => _isLoading;
  int get notificationMessCount=>_notificationMessCount;

  bool get notificationMessShow=>_notificationMessShow;

  set notificationMessageList(val){
    _notificationMessageList.addAll(val);
    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set notificationMessCount(val) {
    _notificationMessCount = val;
    notifyListeners();
  }

  set notificationMessShow(val) {
    _notificationMessShow = val;
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


  Future<void> fetchMessageNotification(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }
    try {
      final response = await  ServiceApi.fetchMessageNotification(pageKey);
      notificationMessageList = response.data;
      _buddhistListMeta = response.meta;

      final messageCount = await ServiceApi.fetchMessageNotificationCount();
      notificationMessCount = messageCount.notificationCount;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage=false;
    }
  }


}
