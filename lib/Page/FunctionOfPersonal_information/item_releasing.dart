import 'dart:async';


import 'package:buddhistauction/Model/releasing.dart';
import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/item_releasing_view_model.dart';
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

final currencyFormat = new NumberFormat("#,##0.00", "en_US");

class ItemReleasing extends StatefulWidget {
  @override
  _ItemReleasingState createState() => _ItemReleasingState();
}

class _ItemReleasingState extends State<ItemReleasing> with WidgetsBindingObserver {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  int currentPage=1;
  ScrollController _scrollController =new ScrollController();

 ItemReleasingViewModel _itemReleasingViewModel;
 bool isPriceNull=false;



  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _itemReleasingViewModel = Provider.of<ItemReleasingViewModel>(context,listen:false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _itemReleasingViewModel.fetchReleasing(currentPage);

    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage >= _itemReleasingViewModel.buddhistListMeta.lastPage) {
          print("isLastPage");

          _itemReleasingViewModel.isLastPage = true;
        } else {
          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _itemReleasingViewModel.fetchReleasing(currentPage);
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _itemReleasingViewModel.itemReleasingList.clear();
    _scrollController.dispose();
    super.dispose();
  }

 @override
 void didChangeAppLifecycleState(AppLifecycleState state) {
   if (state == AppLifecycleState.resumed) {
     if (mounted)
   {
   _itemReleasingViewModel =
       Provider.of<ItemReleasingViewModel>(context, listen: false);
 }
     SchedulerBinding.instance.addPostFrameCallback((_) {
       if(mounted) {
         currentPage = 1;
         _itemReleasingViewModel.itemReleasingList.clear();
         _itemReleasingViewModel.fetchReleasing(currentPage);
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
        title: Text("ເຄື່ອງທີ່ປ່ອຍຢູ່ດຽວນີ້", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
      ),
      body: Consumer<ItemReleasingViewModel>(
        builder: (context, viewModel, child) {

          if (viewModel.isLoading) {
            return Container(
                alignment: Alignment.centerLeft,
                child: Center(child:WidgetStatic.buildLoadingCat()));
          }

          return RefreshIndicator(
            onRefresh: () async{
              currentPage=1;
              viewModel.itemReleasingList.clear();
              await viewModel.fetchReleasing(1);
            },
            child: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  children: [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Text("${viewModel.itemReleasingList.length ?? 0} ລາຍການ"),
                            ),
                            Spacer(),
                            Container(
                                child: IconButton(onPressed: (){
                                  viewModel.setIsGrid();
                                }, icon: Icon(viewModel.isGrid ?Icons.view_headline : Icons.apps))
                            ),
                          ],
                        ),

                      ),
                    ),
                    Divider(),

                    viewModel.itemReleasingList.isNotEmpty ?
                    buildCardItem(viewModel)
                        :Container()
                  ],
                ),

                viewModel.itemReleasingList.isNotEmpty ?
                Container()
                    :
                Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

              ],

            ),
          );
        },

      ),
    );
  }

  Widget buildCardItem(ItemReleasingViewModel viewModel) {

        int childLength=0;
        var maxPrice;
          return Stack(
            children: [
              viewModel.isGrid == false?
              ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.itemReleasingList.length,
                itemBuilder: (context, index) {
                  FirebaseDatabase.instance
                      .reference()
                      .child('buddhist')
                      .child(viewModel.itemReleasingList[index].id.toString())
                      .once()
                      .then((value) {
                    Map data = value.value;
                    // print(data.length);
                    childLength = data.length;
                  });
                  return GestureDetector(
                    onTap: (){
                      Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId=viewModel
                          .itemReleasingList[index]
                          .id;
                      Navigator.of(context).pushNamed('/detailpage');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top:  BorderSide(
                            width:index == 0 ? 0.5 : 0,
                            color:index == 0 ? Colors.grey:Colors.transparent,
                          ),
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child:
                            CachedNetworkImage(
                              cacheManager: customCacheManager,
                              key: UniqueKey(),
                              imageUrl:
                              "${viewModel.itemReleasingList[index].image[0]}",
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
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left:8,right:8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                        children: [
                                          Container(child: Text("${viewModel.itemReleasingList[index].place}",style: TextStyle(color: Colors.grey),),),


                                               Container(child: RemainTime(index:index ,)),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        width: MediaQuery.of(context).size.width-140,
                                        child: Text("${viewModel.itemReleasingList[index].name}"
                                      ,
                                        overflow: TextOverflow.ellipsis,
                                      ),),

                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                       StreamBuilder(
                                        stream: ServiceStream.priceRealtime(
                                            viewModel.itemReleasingList[index].id),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
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
                                            // print(values.length);
                                            SchedulerBinding.instance
                                                .addPostFrameCallback((_) {
                                              if (childLength == values.length) {
                                                print("value length is equal");
                                              } else if (childLength < values.length) {
                                                if (viewModel.itemReleasingList[index].timeRemain <= 180 && viewModel.itemReleasingList[index].timeRemain >0) {
                                                  print("pa moon leo");
                                                  viewModel.itemReleasingList[index].timeRemain += 60;
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

                                          return Center(
                                              child: CircularProgressIndicator());
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },



      )
              :GridView.builder(
                padding: EdgeInsets.only(left:12,right: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 284,
                    crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount:viewModel.itemReleasingList.length,
                itemBuilder: (context, index) {
                  return CardItemGrid(cardItem:viewModel.itemReleasingList,index: index,);
                },
              ),

              viewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
                  : Container(),
            ],
          );
    }


}

class RemainTime extends StatefulWidget {

  final int index;

  const RemainTime({Key key,this.index}) : super(key: key);
  @override
  _RemainTimeState createState() => _RemainTimeState();
}

class _RemainTimeState extends State<RemainTime> {

  String _timeUntil = 'Loading...';
  Timer _timer;
  int remainTime=0;

  void _startTimer() {
     Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingReleasing = true;


    remainTime = Provider.of<ItemReleasingViewModel>(context,listen:false).remainTime[widget.index];
     print(remainTime);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if (this.mounted) {
        Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingReleasing = false;

        _timeUntil = TimeConvert.timeLeft(remainTime);

        if (remainTime <= 0) {
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
      _startTimer();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CountDownProvider>(
        builder: (context, value, child) =>

        value.isTimesLoadingReleasing == true ? SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(strokeWidth: 2,)) :
         Text("$_timeUntil",  style: TextStyle(color: remainTime <=3600 ? Colors.red : Colors.blue),));
  }
}

/// Class _CardItem ///////////////////////////////////////////////////////////////////////////
class CardItemGrid extends StatefulWidget {
  final List<ReleasingData> cardItem;
  final int index;

  const CardItemGrid({Key key, @required this.cardItem, @required this.index})
      : super(key: key);

  @override
  _CardItemGridState createState() => _CardItemGridState();
}

class _CardItemGridState extends State<CardItemGrid> {
  String _timeUntil = '';
  Timer _timer;
  int maxPrice, remainTime = 0, childLength = 0;



  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));



  void _startTimer() {
    Provider.of<CountDownProvider>(context, listen: false).isTimesLoading =
    true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        Provider.of<CountDownProvider>(context, listen: false).isTimesLoading =
        false;

        _timeUntil =
            TimeConvert.timeLeft(widget.cardItem[widget.index].timeRemain);

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



      _startTimer();
      FirebaseDatabase.instance
          .reference()
          .child('buddhist')
          .child(widget.cardItem[widget.index].id.toString())
          .once()
          .then((value) {
        Map data = value.value;
        // print(data.length);
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap: isPriceNull == false
            ? () {
          Provider.of<BuddhistDetailViewModel>(context, listen: false)
              .buddhistId = widget.cardItem[widget.index].id;
          print(
              "${Provider.of<BuddhistDetailViewModel>(context, listen: false).buddhistId}");
          print("${widget.index}");
          Navigator.of(context).pushNamed('/detailpage');
        }
            : null,
        child: isPriceNull == false
            ? Container(
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
                    width: MediaQuery.of(context).size.width,
                    height: 137,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: CachedNetworkImage(
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
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FittedBox(
                            child: Text(
                              '${widget.cardItem[widget.index].place == "ນະຄອນຫຼວງວຽງຈັນ" ? "ນວຈ" : widget.cardItem[widget.index].place}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Spacer(),
                          Consumer<CountDownProvider>(
                            builder: (context, value, child) => value
                                .isTimesLoading ==
                                true
                                ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                                : FittedBox(
                              child: Text(
                                "$_timeUntil ",
                                style: TextStyle(
                                    color: widget
                                        .cardItem[
                                    widget.index]
                                        .timeRemain <=
                                        3600
                                        ? Colors.redAccent
                                        : Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
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
                child: Consumer<ItemReleasingViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: ServiceStream.priceRealtime(
                              widget.cardItem[widget.index].id),
                          builder: (BuildContext context,
                              AsyncSnapshot snapshot) {
                            print("$snapshot");
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
                                  if (widget.cardItem[widget.index]
                                      .timeRemain <=
                                      180 &&
                                      widget.cardItem[widget.index]
                                          .timeRemain >
                                          0) {
                                    print("pa moon leo");
                                    widget.cardItem[widget.index]
                                        .timeRemain += 60;
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
                                    SizedBox(
                                      height: 5,
                                    ),
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

                            // return Center(
                            //     child: CircularProgressIndicator());

                            return
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '0 ຄົນປະມູນ',
                                    style: TextStyle(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '${currencyFormat.format(widget.cardItem[widget.index].highestPrice)} Kip',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: 'boonhome'),
                                    ),
                                  )
                                ],
                              );

                          },
                        ),
                      ],
                    );
                  },

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

