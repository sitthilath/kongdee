
import 'package:buddhistauction/Model/buddhist_notification.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';



class NotificationBiddingViewModel extends ChangeNotifier {
  final String keyBid = "_notificationBid";
  final String keyResult = "_notificationBidResult";
  final String keyMessage = "_notificationMessage";
  SharedPreferences _prefs;

  NotificationBiddingViewModel() {

    _loadFromPrefs();

  }

  _initPrefs() async {
    if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _notificationBidBuddhistId = _prefs.getStringList(keyBid) ?? [] ;
    _notificationBidResultBuddhistId = _prefs.getStringList(keyResult) ?? [] ;
    _notificationMessageBuddhistId = _prefs.getStringList(keyMessage) ?? [] ;
    notifyListeners();
  }



  _saveToPrefsBid()async {
    await _initPrefs();
    _prefs.setStringList(keyBid, _notificationBidBuddhistId);
  }

  _saveToPrefsBidResult()async {
    await _initPrefs();
    _prefs.setStringList(keyResult, _notificationBidResultBuddhistId);
  }

  _saveToPrefsMessage()async {
    await _initPrefs();
    _prefs.setStringList(keyMessage, _notificationMessageBuddhistId);
  }

  List<Datum> _notificationBiddingList = [];
  bool _isLoading = false;
  int _notificationBidCount=0;
  bool _notificationBidShow=false;
  List<String> _notificationBidBuddhistId=[];
  List<String> _notificationBidResultBuddhistId=[];
  List<String> _notificationMessageBuddhistId=[];

  List<Datum> get notificationBiddingList => _notificationBiddingList;
 bool get isLoading => _isLoading;
  int get notificationBidCount=>_notificationBidCount;
  bool get notificationBidShow => _notificationBidShow;
  List<String> get notificationBidBuddhistId=>_notificationBidBuddhistId;
  List<String> get notificationBidResultBuddhistId=>_notificationBidResultBuddhistId;
  List<String> get notificationMessageBuddhistId=>_notificationMessageBuddhistId;

  set notificationBiddingList(val){
    _notificationBiddingList.addAll(val);
    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set notificationBidCount(val) {
    _notificationBidCount = val;
    notifyListeners();
  }

  set notificationBidShow(val) {
    _notificationBidShow = val;
    notifyListeners();
  }

  set notificationBidBuddhistId(val) {
    _notificationBidBuddhistId.add(val);
    _saveToPrefsBid();
    notifyListeners();
  }

  set notificationBidResultBuddhistId(val) {
    _notificationBidResultBuddhistId.add(val);
    _saveToPrefsBidResult();
    notifyListeners();
  }

  set notificationMessageBuddhistId(val) {
    _notificationMessageBuddhistId.add(val);
    _saveToPrefsMessage();
    notifyListeners();
  }

  set notificationBidBuddhistIdRemove(val) {

    _notificationBidBuddhistId.removeWhere((element)=> element == val);
     _saveToPrefsBid();
    notifyListeners();
  }

  set notificationBidResultBuddhistIdRemove(val) {

    _notificationBidResultBuddhistId.removeWhere((element)=> element == val);
    _saveToPrefsBidResult();
    notifyListeners();
  }

  set notificationMessageBuddhistIdRemove(val) {

    _notificationMessageBuddhistId.removeWhere((element)=> element == val);
    _saveToPrefsMessage();
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



  Future<void> fetchNotificationBidding(int pageKey) async {
    if (pageKey == 1) {
      isLoading = true;
    } else {
      isLoadingPage = true;
    }

    try {
      final response = await  ServiceApi.fetchBiddingNotification(pageKey);

      notificationBiddingList = response.data;
      _buddhistListMeta = response.meta;

      final bidingCount = await ServiceApi.fetchBiddingNotificationCount();
      notificationBidCount = bidingCount.notificationCount;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      isLoadingPage=false;
    }
  }


}

