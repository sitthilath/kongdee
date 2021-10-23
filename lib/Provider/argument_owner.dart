
import 'package:flutter/foundation.dart';



class ArgumentOwner extends ChangeNotifier {


  int _ownerId ;

  set ownerId(val) {
    _ownerId = val;
    notifyListeners();
  }

  get ownerId => _ownerId;


}
