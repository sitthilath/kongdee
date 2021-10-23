
import 'package:buddhistauction/Model/user.dart';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class UserViewModel extends ChangeNotifier {
  UserInfo _userList;
  UserInfo get userList => _userList;

  int _userId;

  int get userId=>_userId;

  set userId(val){
    _userId = val;
    notifyListeners();
  }



  bool _isLoading = false;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  get isLoading => _isLoading;



  bool _isUser = false;

  set isUser(val) {
    _isUser = val;
    notifyListeners();
  }

  get isUser => _isUser;


  Future<void> fetchUser(BuildContext context) async {
    isLoading = true;

    try {
      final response = await ServiceApi.fetchUser(context);
      _userList = response.data;
      userId = response.data.id ;
      List<String> images=[];
      images.add(_userList.picture);

      await Future.wait(images.map((urlImage) => cacheImage(context, urlImage)).toList());

      if(response.data != null){
        isUser = true;
      }else{
        isUser = false;
      }
    } catch (e) {
      print("Error Fetch PV user : $e");

    } finally {
      isLoading = false;
    }
  }

  Future cacheImage(BuildContext context,String urlImage)=>precacheImage(CachedNetworkImageProvider(urlImage), context);

}
