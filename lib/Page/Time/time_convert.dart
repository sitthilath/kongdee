class TimeConvert{


  static String timeLeft(int time) {

    String timeRemain="Loading...";
    Duration _timeUntilDue = Duration(seconds: time); //due.difference(DateTime.now());

    int _dayUntil = _timeUntilDue.inDays;
    int _hoursUntil = _timeUntilDue.inHours - (_dayUntil * 24);
    int _minUntil = _timeUntilDue.inMinutes - (_dayUntil * 24 * 60) - (_hoursUntil * 60);
    int _secUntil = _timeUntilDue.inSeconds - (_dayUntil * 24 * 60 * 60) - (_hoursUntil * 60 * 60) - (_minUntil * 60);

    if(_dayUntil > 0){
      timeRemain = _dayUntil.toString() + "d" +  _hoursUntil.toString() + "h" ;
    }else if(_hoursUntil > 0){
      timeRemain =  _hoursUntil.toString() + "h" + _minUntil.toString() + "min" ;


    }else if(_minUntil > 0){
      timeRemain=   _minUntil.toString() + "min" + _secUntil.toString() + "s";

    }else if(_secUntil > 0){
      timeRemain =  _secUntil.toString() + "s";
    }else{
      timeRemain = "ໝົດເວລາ";
    }

    return timeRemain;
  }

}