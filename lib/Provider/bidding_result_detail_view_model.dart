import 'package:buddhistauction/Model/bidding_result_detail.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/cupertino.dart';

class BiddingResultDetailViewModel extends ChangeNotifier {
  BiddingResultDetailData _biddingResultList;

  BiddingResultDetailData get biddingResultList => _biddingResultList;
  bool _isOwner = false;
  bool _isLoading = false;
  int _buddhistId = -1;
  int _buddhistTypeId = -1;

  set isOwner(val){
    _isOwner = val;
    notifyListeners();
  }

  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set buddhistId(val) {
    _buddhistId = val;
    notifyListeners();
  }

  set buddhistTypeId(val) {
    _buddhistTypeId = val;
    notifyListeners();
  }

  get isOwner => _isOwner;
  get isLoading => _isLoading;

  get buddhistId => _buddhistId;

  get buddhistTypeId => _buddhistTypeId;

  Future<void> fetchBiddingResultDetail(int buddhistId) async {
    isLoading = true;

    try {
      final response = await ServiceApi.fetchBiddingResultDetail(buddhistId);
      _biddingResultList = response.data;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
