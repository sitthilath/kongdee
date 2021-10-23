
import 'dart:async';


import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Model/buddhist_recommend.dart';
import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_recommend_view_model.dart';
import 'package:buddhistauction/Provider/countdown.dart';

import 'package:buddhistauction/Service/service_stream.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
final currencyFormat = new NumberFormat("#,###", "en_US");





class BuddhistRecommend extends StatefulWidget {
  final List<BuddhistDetailData> buddhistDetailList;

  const BuddhistRecommend({Key key, this.buddhistDetailList}) : super(key: key);
  @override
  _BuddhistRecommendState createState() => _BuddhistRecommendState();
}

class _BuddhistRecommendState extends State<BuddhistRecommend> with WidgetsBindingObserver {


  BuddhistRecommendViewModel _buddhistRecommendViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _buddhistRecommendViewModel = Provider.of<BuddhistRecommendViewModel>(context,listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _buddhistRecommendViewModel.fetchBuddhistRecommend(widget.buddhistDetailList[0].type.id.toString(),
          widget.buddhistDetailList[0].id.toString());

    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){

      if(mounted){
        _buddhistRecommendViewModel = Provider.of<BuddhistRecommendViewModel>(context,listen: false);
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _buddhistRecommendViewModel.fetchBuddhistRecommend(widget.buddhistDetailList[0].type.id.toString(),
            widget.buddhistDetailList[0].id.toString());

      });
      print("resumed");
    }else if(state == AppLifecycleState.inactive){
      print("inactive");
    }else if(state == AppLifecycleState.detached){
      print("detached");
    }else if(state == AppLifecycleState.paused){
      print("paused");
    }else{
      print("unknown");
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: Row(
        children: [
          Expanded(
            child: Consumer<BuddhistRecommendViewModel>(
              builder: (context, viewModel, child) {
                if(viewModel.isLoading){
                  return Center(child: WidgetStatic.buildLoadingCatSmall(),);
                }
                return Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.buddhistRecommendList.length >= 6 ? 6 : viewModel.buddhistRecommendList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemOther(cardItem: viewModel.buddhistRecommendList, index: index);

                      }),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}


class ItemOther extends StatefulWidget {
  final List<Datum> cardItem;
  final int index;

  const ItemOther({Key key, @required this.cardItem, @required this.index})
      : super(key: key);

  @override
  _ItemOtherState createState() => _ItemOtherState();
}

class _ItemOtherState extends State<ItemOther> {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  String _timeUntil = '';
  Timer _timer;

  var remainTime=0,childLength,maxPrice;


  void _startTimer(BuildContext context) {

Provider.of<CountDownProvider>(context,listen: false).isTimesLoadingRecommend = true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        Provider.of<CountDownProvider>(context,listen: false).isTimesLoadingRecommend = false;

        _timeUntil = TimeConvert.timeLeft(widget.cardItem[widget.index].timeRemain);

        if (widget.cardItem[widget.index].timeRemain <= 0) {
          timer.cancel();
        } else {

          widget.cardItem[widget.index].timeRemain--;
        }
      }
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
       _startTimer(context);

      FirebaseDatabase.instance
          .reference()
          .child('buddhist')
          .child(widget.cardItem[widget.index].id.toString())
          .once()
          .then((value) {
        Map data = value.value;
        print(data.length);
        childLength = data.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }
  bool isPriceNull = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
      child:
      GestureDetector(
        onTap: isPriceNull == false
            ?  () {
          Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId=widget.cardItem[widget.index].id;
          print("${Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId}");
          print("${widget.index}");
          Navigator.of(context).pushReplacementNamed('/detailpage');
        } : null,
        child: isPriceNull == false
            ?  Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                  color: Colors.grey.withOpacity(0.5)
              )
          ),
          width: 162,
          height: 284,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 162,
                    height: 137,
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child:
                      CachedNetworkImage(
                        cacheManager: customCacheManager,
                        key: UniqueKey(),
                        imageUrl:
                        "${widget.cardItem[widget.index].image[0]}",
                        fit: BoxFit.cover,
                        // maxHeightDiskCache: 75,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FittedBox(

                            child:
                            Text(
                              '${widget.cardItem[widget.index].place == "ນະຄອນຫຼວງວຽງຈັນ" ? "ນວຈ" :widget.cardItem[widget.index].place}',
                              style: TextStyle(color: Colors.grey),
                            ),


                          ),
                          Spacer(),

                          Consumer<CountDownProvider>(
                            builder: (context, value, child) =>
                            value.isTimesLoading==true ?
                            SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(strokeWidth: 2,))
                                :
                            FittedBox(
                              child:
                              Text(
                                "$_timeUntil ",
                                style: TextStyle(color:  widget.cardItem[widget.index].timeRemain<=180 ? Colors.redAccent :  Colors.blue),
                              ),

                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        widget.cardItem[widget.index].name,
                        style: TextStyle(fontSize: 18),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    StreamBuilder(
                      stream: ServiceStream.priceRealtime(
                          widget.cardItem[widget.index].id),
                      builder: (BuildContext context,
                          AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          isPriceNull = false;

                          final snapshotResult =
                          snapshot.data.snapshot as DataSnapshot;

                          final Map<dynamic, dynamic> values =
                              snapshotResult.value;

                          final List<int> _prices = [];
                          final List<String> _users = [];
                          values.forEach((key, item) {
                            _prices.add(int.parse(item['price']));
                            _users.add(item['uid']);
                          });

                          maxPrice = _prices.reduce(math.max);
                          // print(values.length);
                          SchedulerBinding.instance
                              .addPostFrameCallback((_) {
                            if (childLength == values.length) {
                              print("value length is equal");
                            } else if (childLength < values.length) {
                              if (widget.cardItem[widget.index].timeRemain <= 180 && widget.cardItem[widget.index].timeRemain > 0) {
                                print("pa moon leo");
                                widget.cardItem[widget.index].timeRemain += 60;
                              } else {
                                print('Time is not Lower than');
                              }
                            } else {
                              print("br me y");
                            }
                          });

                          return Container(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_users.length - 1}' + ' ຄົນປະມູນ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                FittedBox(
                                  child: Text(
                                    '${currencyFormat.format(maxPrice)} Kip',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: 'boonhome'),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          isPriceNull = true;
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner

                        return Center(
                            child: CircularProgressIndicator());
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        )
            : Container(
          width: MediaQuery.of(context).size.width * 0.4,
          color: Colors.grey[400],
          child: Center(
            child: Text("ພະຖືກລົບແລ້ວ"),
          ),
        ),
      ),
    );
  }
}