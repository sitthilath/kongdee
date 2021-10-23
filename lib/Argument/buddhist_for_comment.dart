import 'package:buddhistauction/Model/buddhist_detail.dart' as buddhistDetail;
import 'package:buddhistauction/Model/buddhist_favorite.dart';
import 'package:flutter/cupertino.dart';

class BuddhistArgumentsForComment{
  final List<buddhistDetail.BuddhistDetailData> buddhistItem;
  final int idx;
  final List<BuddhistFavorite> buddhistItemID;
  BuddhistArgumentsForComment({@required this.buddhistItem,@required this.buddhistItemID,@required this.idx});
}