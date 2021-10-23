
import 'package:flutter/cupertino.dart';

class ArgumentComment with ChangeNotifier{

  int _id;
  ScrollController _scrollController;
  ScrollController _scrollControllerChat;
  int get id => _id;
  ScrollController get scrollController => _scrollController;
  ScrollController get scrollControllerChat => _scrollControllerChat;

  set scrollController(val){
    _scrollController = val;
    notifyListeners();
  }

  set scrollControllerChat(val){
    _scrollControllerChat = val;
    notifyListeners();
  }

  setId(int id){
    _id = id;
    notifyListeners();
  }

}

