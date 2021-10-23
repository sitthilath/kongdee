
import 'package:buddhistauction/Model/user.dart';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class OwnerViewModel extends ChangeNotifier {
  UserInfo _ownerList;
  UserInfo get ownerList => _ownerList;

  int _ownerId;

  int get ownerId=>_ownerId;

  set ownerId(val){
    _ownerId = val;
    notifyListeners();
  }



  bool _isLoading = false;

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  get isLoading => _isLoading;




  Future<void> fetchOwner(BuildContext context,String ownerId) async {
    isLoading = true;

    try {
      final response = await ServiceApi.fetchOwner("$ownerId");
      _ownerList = response.data;

      List<String> images=[];
      images.add(_ownerList.picture);

      await Future.wait(images.map((urlImage) => cacheImage(context, urlImage)).toList());

    } catch (e) {
      print("Error Fetch PV owner : $e");

    } finally {
      isLoading = false;
    }
  }

  Future cacheImage(BuildContext context,String urlImage)=>precacheImage(CachedNetworkImageProvider(urlImage), context);

}
