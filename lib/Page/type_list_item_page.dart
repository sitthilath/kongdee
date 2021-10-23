import 'dart:async';
import 'package:buddhistauction/Model/buddhist_type_id.dart';
import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../Provider/BuddhistViewModel/buddhist_type_view_model.dart';
import 'package:buddhistauction/Provider/countdown.dart';


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
final currencyFormat = new NumberFormat("#,###", "en_US");

class TypeListItemPage extends StatefulWidget {
  @override
  _TypeListItemPageState createState() => _TypeListItemPageState();
}

class _TypeListItemPageState extends State<TypeListItemPage> with WidgetsBindingObserver {


  BuddhistTypeViewModel _buddhistTypeViewModel;
  int currentPage=1;
  ScrollController _scrollController =new ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _buddhistTypeViewModel = Provider.of<BuddhistTypeViewModel>(context,listen:false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _buddhistTypeViewModel.fetchBuddhistType(currentPage);
    });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(currentPage>=_buddhistTypeViewModel.buddhistListMeta.lastPage){
          print("isLastPage");

          _buddhistTypeViewModel.isLastPage=true;
        }else{
          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(mounted){
              _buddhistTypeViewModel.fetchBuddhistType(currentPage);
            }
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _buddhistTypeViewModel.pagingItemList.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      if(mounted){
        _buddhistTypeViewModel = Provider.of<BuddhistTypeViewModel>(context, listen: false);
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if(mounted){

          currentPage=1;
          _buddhistTypeViewModel.pagingItemList.clear();
          _buddhistTypeViewModel.fetchBuddhistType(currentPage);
        }
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




    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Consumer<BuddhistTypeViewModel>(
            builder: (context, typeViewModel, child) =>
             Text("${typeViewModel.typeName}",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),

      ),

      body: SafeArea(
        child: Consumer<BuddhistTypeViewModel>(
          builder: (context, typeViewModel, child) {
            if (typeViewModel.isLoading) {
              return Container(
                  alignment: Alignment.centerLeft,
                  child: Center(child: WidgetStatic.buildLoadingCat()));
            }
           return RefreshIndicator(
              onRefresh: ()async{
                currentPage=1;
                typeViewModel.pagingItemList.clear();
                await typeViewModel.fetchBuddhistType(1);
              },
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    children: [
                      typeViewModel.pagingItemList.isNotEmpty
                      ?
                      Stack(
                        children: [
                          ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                          padding: EdgeInsets.only(top:10),
                              itemCount: typeViewModel.pagingItemList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _CardItem(
                                  cardItem:  typeViewModel.pagingItemList,
                                  index: index,
                                );
                              }),
                          typeViewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
                              : Container(),
                        ],
                      )
                          :
                          Container()
                    ],
                  ),
                  typeViewModel.pagingItemList.isNotEmpty
                      ?
                      Container()
                      :
                  Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

                ],
              ),
            );
          },

                ),

      ),
    );
  }
}

class _CardItem extends StatefulWidget {
  final List<Datum> cardItem;
  final int index;

  const _CardItem({Key key, @required this.cardItem, @required this.index})
      : super(key: key);
  @override
  __CardItemState createState() => __CardItemState();
}

class __CardItemState extends State<_CardItem> {
  var maxPrice;

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  Stream<Event> priceRealtime(int id) {
    DatabaseReference _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('buddhist')
        .child(id.toString());
    return _databaseReference.onValue;
  }

  String _timeUntil = '';
  Timer _timer;
  int remainTime=0,childLength=0;
  void _startTimer(BuildContext context) {
    Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingType = true;
     remainTime =widget.cardItem[widget.index].timeRemain;

    Timer.periodic(Duration(seconds: 1), (timer) {

      if (this.mounted) {
        Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingType = false;
        _timeUntil = TimeConvert.timeLeft(remainTime);

        if (remainTime <=
            0) {
          timer.cancel();
        } else {

          remainTime--;


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
      height: 100,
      decoration: BoxDecoration(
        border: Border(
          top:  BorderSide(
            width:widget.index == 0 ? 0.5 : 0,
            color:widget.index == 0 ? Colors.grey:Colors.transparent,
          ),
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey,
          ),
        ),
      ),
      child: isPriceNull == false ? InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
         Provider.of<BuddhistDetailViewModel>(context,listen: false).buddhistId = widget.cardItem[widget.index].id;
          Navigator.of(context).pushNamed('/detailpage',);
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              height: 100,
              width: 100,
              child: ClipRRect(

                child:
                CachedNetworkImage(
                  cacheManager: customCacheManager,
                  key: UniqueKey(),
                  imageUrl:
                  "${widget.cardItem[widget.index].picture[0]}",
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
            SizedBox(
        height: 10,
            ),
            Expanded(

        child: Container(
          padding: EdgeInsets.only(left:8.0,right:8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${widget.cardItem[widget.index].place}',
                    style: TextStyle(color: Colors.grey,fontSize: 14),
                  ),
                  Spacer(),
                  Consumer<CountDownProvider>(
                    builder: (context, value, child) =>
                    value.isTimesLoadingType==true ?
                    SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 2,))
                        :
                     Text(
                      "$_timeUntil",
                      style: TextStyle(color: remainTime <=3600?Colors.redAccent:Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(widget.cardItem[widget.index].name,style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis,),
              SizedBox(
                height: 5,
              ),
              StreamBuilder(
                stream: priceRealtime(widget.cardItem[widget.index].id),
                builder:
                    (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {

                        isPriceNull = false;

                    final snapshotResult =
                        snapshot.data.snapshot as DataSnapshot;
                    final Map<dynamic, dynamic> values =
                        snapshotResult.value;
                    final List<int> _prices = [];
                        final List<int> _bidderId = [];
                    values.forEach((key, item) {
                      _prices.add(int.parse(item['price']));
                      _bidderId.add(item['id']);
                    });
                    maxPrice = _prices.reduce(math.max);
                    print(childLength);
                    print(values.length);
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (childLength == values.length) {
                        print("value length is equal");
                      } else if (childLength < values.length) {
                        if (remainTime <= 180 && remainTime > 0) {

                          print("pa moon leo");
                          remainTime +=60;

                        } else {
                          print('Time is not Lower than');
                        }
                      } else {
                        print("br me y");
                      }
                    });
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [


                          FittedBox(
                            child: Text(
                              '${currencyFormat.format(
                                  maxPrice)} Kip',

                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'boonhome'),
                            ),
                          ),
                          Text(
                            '${_bidderId.length - 1}' +
                                ' ຄົນປະມູນ',
                            style: TextStyle(
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    isPriceNull = true;
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner
                  return Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
            )
          ]),
      ) : Container(
        width: MediaQuery.of(context).size.width * 0.4,
        color: Colors.grey[400],
        child: Center(child: Text("ພະຖືກລົບແລ້ວ"),),
      ),
    );
  }
}
