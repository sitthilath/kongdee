import 'dart:async';


import 'package:buddhistauction/Model/buddhist_bottom_search.dart';

import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_view_model.dart';
import 'package:buddhistauction/Provider/StoreData/store_recent_search.dart';
import 'package:buddhistauction/Provider/countdown.dart';
import 'package:buddhistauction/Service/service_stream.dart';

import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final currencyFormat = new NumberFormat("#,###", "en_US");

class DataSearch extends SearchDelegate<List<BuddhistBottomSearch>> {
  final List<Datum> buddhist;

  DataSearch(this.buddhist);



  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {


    SchedulerBinding.instance.addPostFrameCallback((_){
      Provider.of<StoreRecentSearch>(context,listen:false).recentSearch = query;
      Provider.of<BuddhistViewModel>(context,listen:false).fetchSearching( query);
    });

    return Consumer<BuddhistViewModel>(
      builder: (context, viewModel, child) {
        if(viewModel.isLoading){
          return Center(child: WidgetStatic.buildLoadingCatSmall(),);
        }
      return
        Consumer<BuddhistViewModel>(
          builder: (context, viewModel, child) {

           return viewModel.searchList.length != 0 ? Padding(
             padding: const EdgeInsets.only(top:10.0),
             child: ListView.builder(
                itemBuilder: (context, index) {
                  return _CardItem(cardItem: viewModel.searchList, index: index);
                },
                itemCount: viewModel.searchList.length,
              ),
           ) :  Center(
              child: Text(
                "ບໍ່ມີຂໍ້ມູນ",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            );

          }  );

      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("GG");
    final List<Datum> suggestionList = query.isEmpty
        ? []
        : buddhist
            .where((data) => data.name.toLowerCase().contains(query))
            .toList();

    return suggestionList.isEmpty
        ? Consumer<StoreRecentSearch>(
      builder: (context, recentNotify, child) =>
           ListView.builder(
      itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              query = recentNotify.recentSearch[index];
              showResults(context);

            },
            leading: Icon(Icons.access_time_outlined),
            title: RichText(
              text: TextSpan(
                  text:
                  recentNotify.recentSearch[index],
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                 ),
            ),
          );
      },
      itemCount: recentNotify.recentSearch.length,
    ),
        )
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  query = suggestionList[index].name;
                  showResults(context);
                },

                title: RichText(
                  text: TextSpan(
                      text:
                          suggestionList[index].name.substring(0, query.length),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: suggestionList[index]
                                .name
                                .substring(query.length),
                            style: TextStyle(color: Colors.grey))
                      ]),
                ),
              );
            },
            itemCount: suggestionList.length,
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
  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  var maxPrice;

  Stream<Event> priceRealtime(int id) {
    DatabaseReference _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('buddhist')
        .child(id.toString());
    return _databaseReference.onValue;
  }

  String _timeUntil = '';
  Timer _timer;
  var remainTime, childLength;

  void _startTimer(BuildContext context) {
    Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingSearch = true;


    remainTime= widget.cardItem[widget.index].timeRemain;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingSearch = false;

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
    return isPriceNull == false
        ? GestureDetector(
      onTap: () {
        Provider
            .of<BuddhistDetailViewModel>(context, listen: false)
            .buddhistId =


            widget.cardItem[widget.index]
                .id;
        Navigator.of(context).pushNamed('/detailpage');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: widget.index == 0 ? 0.5 : 0,
              color: widget.index == 0 ? Colors.grey : Colors.transparent,
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
                "${ widget.cardItem[widget.index].image[0]}",
                fit: BoxFit.cover,

                placeholder: (context, url) =>
                    Container(color: Colors.grey),
                errorWidget: (context, url, error) =>
                    Container(
                      color: Colors.black12,
                      child: Icon(Icons.error, color: Colors.red),
                    ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left:8.0,right:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Container(child: Text(
                              "${ widget.cardItem[widget.index].place}",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14),),),
                            Container(child:


                            Consumer<CountDownProvider>(
                              builder: (context, value, child) => value
                                  .isTimesLoadingSearch ==
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
                                          .cardItem[widget.index]
                                          .timeRemain <=
                                          3600
                                          ? Colors.redAccent
                                          : Colors.blue),
                                ),
                              ),
                            ),


                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 140,
                          child: Text(
                            "${ widget.cardItem[widget.index].name}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          ),),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Spacer(),
                    Column(
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
                              final List<int> _bidderId = [];
                              values.forEach((key, item) {
                                _prices.add(int.parse(item['price']));
                                _bidderId.add(item['id']);
                              });
                              print(_bidderId.length);
                              maxPrice = _prices.reduce(math.max);

                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                if (childLength == values.length) {
                                  print("value length is equal");
                                } else if (childLength < values.length) {
                                  if ( widget.cardItem[widget.index].timeRemain <=
                                      180 &&  widget.cardItem[widget.index]
                                      .timeRemain > 0) {
                                    print("pa moon leo");
                                    widget.cardItem[widget.index].timeRemain +=
                                    60;
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
    )
        : Container(
            width: MediaQuery.of(context).size.width * 0.4,
            color: Colors.grey[400],
            child: Center(
              child: Text("ພະຖືກລົບແລ້ວ"),
            ),
          );
  }
}
