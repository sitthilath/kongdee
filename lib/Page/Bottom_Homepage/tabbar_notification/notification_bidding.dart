import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';

import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;


final currencyFormat = new NumberFormat("#,###", "en_US");

class NotificationBidding extends StatefulWidget {
  @override
  _NotificationBiddingState createState() => _NotificationBiddingState();
}

class _NotificationBiddingState extends State<NotificationBidding> {
  NotificationBiddingViewModel _notificationBiddingViewModel;

  int currentPage=1;
  ScrollController _scrollController =new ScrollController();
  bool isKing=false;

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));


  @override
  void initState() {
    _notificationBiddingViewModel =
        Provider.of<NotificationBiddingViewModel>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _notificationBiddingViewModel.fetchNotificationBidding(currentPage);
      _notificationBiddingViewModel.notificationBidShow = false;
    });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(currentPage>=_notificationBiddingViewModel.buddhistListMeta.lastPage){
          print("isLastPage");

          _notificationBiddingViewModel.isLastPage=true;
        }else{
          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(mounted){
              _notificationBiddingViewModel.fetchNotificationBidding(currentPage);
            }
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _notificationBiddingViewModel.notificationBiddingList.clear();
    _scrollController.dispose();
    super.dispose();
  }

  int childLength = 0;
  var maxPrice;
  bool isPriceNull = false;


  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationBiddingViewModel>(
        builder: (context, biddingViewModel, child) {
      if (biddingViewModel.isLoading) {
        return Container(
            alignment: Alignment.centerLeft,
            child: Center(child: WidgetStatic.buildLoadingCat()));
      }

      return RefreshIndicator(
        onRefresh: ()  async{
      currentPage=1;
      biddingViewModel.notificationBiddingList.clear();
      await biddingViewModel.fetchNotificationBidding(1);

      },
        child: Stack(
          children: [
            ListView(
              controller: _scrollController,
              children: [
                biddingViewModel.notificationBiddingList.isNotEmpty
                ?
                Stack(
                  children: [
                    Container(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: biddingViewModel.notificationBiddingList.length,
                          itemBuilder: (context, index) {
                            FirebaseDatabase.instance
                                .reference()
                                .child('buddhist')
                                .child(biddingViewModel
                                    .notificationBiddingList[index].buddhistId
                                    .toString())
                                .once()
                                .then((value) {
                              Map data = value.value;

                              childLength = data.length;
                            });

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${DateFormat('dd LLLL y', 'lo-LA').format(DateTime.parse(biddingViewModel.notificationBiddingList[index].time))}   ເວລາ ${DateFormat.jm().format(DateFormat("hh:mm:ss").parse("${DateFormat.Hms().format(DateTime.parse(biddingViewModel.notificationBiddingList[index].time))}"))}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                //5
                                buildSizedBoxHeight(5),
                                Stack(
                                  children: [
                                    Container(
                                      height: 251,
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // if you need this
                                          side: BorderSide(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Container(

                                          width:
                                              MediaQuery.of(context).size.width * 0.4,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:16.0,top:17.0),
                                                child: Align(
                                                  child: StreamBuilder(
                                                    stream: ServiceStream.priceRealtime(
                                                        biddingViewModel
                                                            .notificationBiddingList[
                                                                index]
                                                            .buddhistId),
                                                    builder: (BuildContext context,
                                                        AsyncSnapshot snapshot) {
                                                      if (snapshot.hasData) {
                                                        isPriceNull = false;
                                                        final snapshotResult = snapshot
                                                            .data
                                                            .snapshot as DataSnapshot;
                                                        final Map<dynamic, dynamic>
                                                            values = snapshotResult.value;

                                                        final List<int> _bidderId = [];
                                                        values.forEach((key, item) {
                                                          _bidderId.add(item['id']);
                                                        });
                                                        print(_bidderId.length);


                                                        return Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Consumer<UserViewModel>(
                                                                builder: (context, value,
                                                                        child) {

                                                                  return  FittedBox(
                                                                  child: Text(
                                                                    '${_bidderId[_bidderId.length - 1] == value.userId ? 'ເຈົ້າກຳລັງນຳ' : 'ມີຄົນສະເໜີລາຄາຫຼາຍກ່ວາ'}',
                                                                    style: TextStyle(
                                                                        color: _bidderId[
                                                                                    _bidderId.length -
                                                                                        1] ==
                                                                                value
                                                                                    .userId
                                                                            ? Colors.blue
                                                                            : Colors
                                                                                .redAccent,
                                                                        fontSize: 16,
                                                                        fontFamily:
                                                                            'boonhome'),
                                                                  ),
                                                                );}
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
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                  ),
                                                  alignment: Alignment.topLeft,
                                                ),
                                              ),
                                              //5
                                              buildSizedBoxHeight(5),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:16.0),
                                                      child: Container(
                                                        width: 126,
                                                        height: 126,
                                                        child:
                                                        CachedNetworkImage(
                                                          cacheManager: customCacheManager,
                                                          key: UniqueKey(),
                                                          imageUrl:
                                                          "${biddingViewModel.notificationBiddingList[index].image[0]}",
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
                                                    //10
                                                    buildSizedBoxHeight(10),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              '${biddingViewModel.notificationBiddingList[index].buddhistName}',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                            ),
                                                            //5
                                                            buildSizedBoxHeight(5),


                                                            StreamBuilder(
                                                              stream: ServiceStream.priceRealtime(
                                                                  biddingViewModel
                                                                      .notificationBiddingList[
                                                                  index]
                                                                      .buddhistId),
                                                              builder: (BuildContext context,
                                                                  AsyncSnapshot snapshot) {
                                                                if (snapshot.hasData) {
                                                                  isPriceNull = false;
                                                                  final snapshotResult = snapshot
                                                                      .data
                                                                      .snapshot as DataSnapshot;
                                                                  final Map<dynamic, dynamic>
                                                                  values = snapshotResult.value;

                                                                  final List<int> _bidderId = [];
                                                                  values.forEach((key, item) {
                                                                    _bidderId.add(item['id']);
                                                                  });
                                                                  print(_bidderId.length);


                                                                  return Container(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        Consumer<UserViewModel>(
                                                                            builder: (context, value,
                                                                                child) {

                                                                              return  Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  FittedBox(
                                                                                    child: Text(
                                                                                      _bidderId.last == value.userId  ? 'ປະມູນເພີ່ມບໍ່':'ປະມູນສູ້ບໍ່'  ,
                                                                                      style: TextStyle(
                                                                                          color: Color.fromARGB(
                                                                                              255,
                                                                                              134,
                                                                                              139,
                                                                                              128),
                                                                                          fontSize: 16),
                                                                                    ),
                                                                                  ),
                                                                                  FittedBox(
                                                                                    child: Text(
                                                                                      _bidderId.last == value.userId ?'ເພາະທ່ານກຳລັງນຳ': 'ເພາະມີສະມາຊິກປະມູນໃນລາຄາ',
                                                                                      style: TextStyle(
                                                                                          color: Color.fromARGB(
                                                                                              255,
                                                                                              134,
                                                                                              139,
                                                                                              128),
                                                                                          fontSize: 16),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );}
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
                                                                    child:
                                                                    CircularProgressIndicator());
                                                              },
                                                            ),

                                                            Column(
                                                              children: [
                                                                StreamBuilder(
                                                                  stream: ServiceStream
                                                                      .priceRealtime(
                                                                          biddingViewModel
                                                                              .notificationBiddingList[
                                                                                  index]
                                                                              .buddhistId),
                                                                  builder: (BuildContext
                                                                          context,
                                                                      AsyncSnapshot
                                                                          snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      isPriceNull =
                                                                          false;
                                                                      final snapshotResult =
                                                                          snapshot.data
                                                                                  .snapshot
                                                                              as DataSnapshot;
                                                                      final Map<dynamic,
                                                                              dynamic>
                                                                          values =
                                                                          snapshotResult
                                                                              .value;
                                                                      final List<int>
                                                                          _prices = [];

                                                                      values.forEach(
                                                                          (key, item) {
                                                                        _prices.add(int
                                                                            .parse(item[
                                                                                'price']));
                                                                      });

                                                                      maxPrice = _prices
                                                                          .reduce(
                                                                              math.max);

                                                                      return Container(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                          children: [
                                                                            FittedBox(
                                                                              child:
                                                                                  Text(
                                                                                '${currencyFormat.format(maxPrice)} Kip',
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight
                                                                                        .bold,
                                                                                    fontSize:
                                                                                        18,
                                                                                    fontFamily:
                                                                                        'boonhome'),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    } else if (snapshot
                                                                        .hasError) {
                                                                      isPriceNull =
                                                                          true;
                                                                      return Text(
                                                                          "${snapshot.error}");
                                                                    }

                                                                    // By default, show a loading spinner

                                                                    return Center(
                                                                        child:
                                                                            CircularProgressIndicator());
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            //20
                                                            buildSizedBoxHeight(20),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                              Spacer(),
                                              Container(
                                                height: 51,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,

                                                child: TextButton(

                                                  style: TextButton.styleFrom(

                                                      backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(15.0),
                                                            bottomRight: Radius.circular(15.0))),
                                                  ),
                                                  onPressed: () {
                                                    Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId=biddingViewModel
                                                        .notificationBiddingList[index]
                                                        .buddhistId;
                                                    Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidBuddhistIdRemove = biddingViewModel.notificationBiddingList[index].buddhistId.toString();
                                                    print( "ID TEST = ${ Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidBuddhistId}");
                                                    Navigator.of(context).pushNamed('/detailpage');
                                                  },
                                                  child: StreamBuilder(
                                                    stream: ServiceStream.priceRealtime(
                                                        biddingViewModel
                                                            .notificationBiddingList[
                                                        index]
                                                            .buddhistId),
                                                    builder: (BuildContext context,
                                                        AsyncSnapshot snapshot) {
                                                      if (snapshot.hasData) {
                                                        isPriceNull = false;
                                                        final snapshotResult = snapshot
                                                            .data
                                                            .snapshot as DataSnapshot;
                                                        final Map<dynamic, dynamic>
                                                        values = snapshotResult.value;

                                                        final List<int> _bidderId = [];
                                                        values.forEach((key, item) {
                                                          _bidderId.add(item['id']);
                                                        });
                                                        print(_bidderId.length);

                                                        return Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Consumer<UserViewModel>(
                                                                builder: (context, value,
                                                                    child) =>
                                                                    FittedBox(
                                                                      child: Text(
                                                                        '${_bidderId[_bidderId.length - 1] == value.userId ? 'ປະມູນເພີ່ມ' : 'ປະມູນສູ້ບໍ່'}',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontFamily:
                                                                            'boonhome'),
                                                                      ),
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
                                                          child:
                                                          CircularProgressIndicator());
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Consumer<NotificationBiddingViewModel>(
                                        builder: (context, value, child) {
                                      for (int i = 0; i < value.notificationBidBuddhistId.length; i++)
                                      {
                                        print("notificationBiddingList:${biddingViewModel
                                            .notificationBiddingList[index]
                                            .buddhistId
                                            .toString()}");
                                        if (value.notificationBidBuddhistId[i] ==
                                                 biddingViewModel
                                                .notificationBiddingList[index]
                                                .buddhistId
                                                .toString()) {
                                          return Positioned(
                                            // draw a red marble
                                            top: 10.0,
                                            right: 10.0,
                                            child: Icon(Icons.circle_notifications,
                                                size: 20.0,
                                                color: Color.fromRGBO(255, 196, 39, 1)),
                                          );
                                        }
                                      }

                                      return SizedBox();
                                    }),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                    biddingViewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
                        : Container(),
                  ],
                )
                    :
                    Container()
              ],
            ),
            biddingViewModel.notificationBiddingList.isNotEmpty
                ?
                Container()
                :
            Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

          ],
        ),
      );
    });
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}
