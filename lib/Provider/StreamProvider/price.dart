import 'dart:async';

import 'package:buddhistauction/Page/Time/time_convert.dart';

import 'package:flutter/material.dart';

class Price extends ChangeNotifier{

//    List<int> _prices = [];
//    List<String> _users = [];
//    bool _isLoading=false;
//
//    get prices => _prices;
//    get users => _users;
//    get isLoading => _isLoading;
//
//    set prices(val){
//     _prices = val;
//     notifyListeners();
//    }
//
//    set users(val){
//      _users = val;
//      notifyListeners();
//    }
//
//    set isLoading(val){
//      _isLoading = val;
//      notifyListeners();
//    }
//
//
//   Stream<List<int>> streamPrice()  async*{
//     isLoading = true;
//
//     try {
//       final response =  ServiceStream.priceRealtime(128);
//        response.listen((event) {
//          event.snapshot.value
//          .forEach((key, item) {
//             _prices.add(int.parse(item['price']));
//
//          });
//
//
//       });
//
// yield _prices;
//
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading = false;
//     }
//   }
//
//    Stream<void> streamUser()  {
//      isLoading = true;
//
//      try {
//        final response =  ServiceStream.priceRealtime(128);
//        response.listen((event) {
//          event.snapshot.value
//              .forEach((key, item) {
//
//            _users.add(item['uid']);
//          });
//
//
//        });
//
//
//
//      } catch (e) {
//        print(e);
//      } finally {
//        isLoading = false;
//      }
//    }


  bool _isTimeLoading = true;


  bool get isTimeLoading => _isTimeLoading;

  set isTimeLoading(value){
    _isTimeLoading = value;
    notifyListeners();
  }

  Timer _timer;
  String _timeUntil;
  int _remainTime=0;

  get timer => _timer;
  get timeUntil => _timeUntil;
  get remainTime => _remainTime;

  set remainTime(val){
    _remainTime = val;
    notifyListeners();
  }

  String startTimer(int remainTime) {
    isTimeLoading = true;


    // remainTime = widget.timeRemain;
    print(_remainTime);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      isTimeLoading = false;

      _timeUntil = TimeConvert.timeLeft(remainTime);

      if (remainTime <= 0) {
        timer.cancel();

        return _timeUntil;
      } else {

        remainTime--;
        return _timeUntil;
      }

    });

    return _timeUntil;
  }

  void disposeTime(){
    print("disposeTime");
    if(_timer != null){
      _timer.cancel();
    }
  }
}