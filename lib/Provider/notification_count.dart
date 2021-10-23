import 'package:flutter/cupertino.dart';

class NotificationCountProvider extends ChangeNotifier{


  bool _isNotificationShow = false;


  bool get isNotificationShow => _isNotificationShow;


  set isNotificationShow(bool isNotificationShow){
    _isNotificationShow = isNotificationShow;
    notifyListeners();
  }
}