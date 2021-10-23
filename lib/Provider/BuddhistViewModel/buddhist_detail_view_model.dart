
import 'package:flutter/foundation.dart';



class BuddhistDetailViewModel extends ChangeNotifier {

    int _buddhistId;

    int get buddhistId=>_buddhistId;

    set buddhistId(val){
      _buddhistId = val;
      notifyListeners();
    }


  }


