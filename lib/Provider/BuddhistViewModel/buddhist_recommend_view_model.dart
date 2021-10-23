import 'package:buddhistauction/Model/buddhist_recommend.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/material.dart';

class BuddhistRecommendViewModel extends ChangeNotifier{

  List<Datum> _buddhistRecommendList=[];

  List<Datum> get buddhistRecommendList => _buddhistRecommendList;

  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(val){
    _isLoading = val;
    notifyListeners();
  }
  Future<void> fetchBuddhistRecommend(String idt, String idb) async{
    isLoading = true;
    try{
      final response = await ServiceApi.fetchBuddhistRecommend(idt, idb);
      _buddhistRecommendList = response.data;
    }catch(e){
      print(e);
    }finally{
      isLoading = false;
    }




  }

}