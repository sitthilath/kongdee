import 'dart:async';
import 'package:buddhistauction/Filter/search_all.dart';
import 'package:buddhistauction/Model/buddhist_bottom_search.dart' as BuddhistBottomSearch;
import 'package:buddhistauction/Model/buddhist_type.dart' as BuddhistType;
import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Page/section_list_show_all.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';

import 'package:buddhistauction/Service/service_stream.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../Provider/BuddhistViewModel/buddhist_type_view_model.dart';
import '../../Provider/BuddhistViewModel/buddhist_view_model.dart';
import 'package:buddhistauction/Provider/countdown.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final currencyFormat = new NumberFormat("#,###", "en_US");

class BottomSearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomSearchState();
  }
}

class _BottomSearchState extends State<BottomSearch>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  BuddhistViewModel _buddhistViewModel;




  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);
    _buddhistViewModel = Provider.of<BuddhistViewModel>(context, listen: false);


      SchedulerBinding.instance.addPostFrameCallback((_) {

          _buddhistViewModel.fetchBuddhists(context);
      });




    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        _buddhistViewModel =
            Provider.of<BuddhistViewModel>(context, listen: false);
      }


        SchedulerBinding.instance.addPostFrameCallback((_) {
          if(mounted) {
            _buddhistViewModel.fetchBuddhists(context);
          }
        });



      print("resumed");
    } else if (state == AppLifecycleState.inactive) {
      print("inactive");
    } else if (state == AppLifecycleState.detached) {
      print("detached");
    } else if (state == AppLifecycleState.paused) {
      print("paused");
    } else {
      print("unknown");
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Provider.of<BuddhistViewModel>(context,listen:false).fetchBuddhists(context),
        child:
        Consumer<BuddhistViewModel>(
          builder: (context, BuddhistViewModel viewModel, child) {
            return
        Stack(
          children: [

            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: ListView(children: [

                 Column(
                      children: [

                        Container(
                          alignment: Alignment.centerLeft,
                          child: RichText(

                            text: TextSpan(
                              text: 'ສະບາຍດີ!',

                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromRGBO(252, 177, 58, 1),
                                  fontWeight: FontWeight.bold),
                              children: [
                                WidgetSpan(child: Image.asset('asset/image/small_cat.png')),
                              ]
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: DataSearch(viewModel.buddhistList));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 15, 20),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //border: Border.all(),

                              color: Color.fromARGB(255, 253, 243, 243),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "ຊອກຫາເຄື່ອງທັງໝົດ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'boonhome',
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        buddhistType(viewModel),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 10.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              child: Text(
                                "ສິນຄ້າໃຫມ່",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SectionListShowAll(
                                            indexSection: 0,
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      "ເບິ່ງທັງໝົດ",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(184, 133, 13, 1)),
                                    ),
                                  ),
                                  Container(
                                      child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Color.fromRGBO(184, 133, 13, 1),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        buddhistCardItem(viewModel),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 10.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              child: Text(
                                "ລາຍການຍອດນິຍົມ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SectionListShowAll(
                                            indexSection: 1,
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      "ເບິ່ງທັງໝົດ",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(184, 133, 13, 1)),
                                    ),
                                  ),
                                  Container(
                                      child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Color.fromRGBO(184, 133, 13, 1),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        buddhistCardItemPopular(viewModel),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  top: 10.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              child: Text(
                                "ໃກ້ໝົດເວລາປະມູນ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SectionListShowAll(
                                            indexSection: 2,
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      "ເບິ່ງທັງໝົດ",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(184, 133, 13, 1)),
                                    ),
                                  ),
                                  Container(
                                      child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Color.fromRGBO(184, 133, 13, 1),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        buddhistCardItemTimeLower(viewModel),
                      ],
                    ),

              ]),
            ),

            viewModel.isLoading == true
                ? Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: WidgetStatic.buildLoadingCat())
                : Container()
          ],
        );
          },
        ),
      ),
      floatingActionButton: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) =>
         Consumer<BuddhistViewModel>(
           builder: (context, viewModel, child) =>
            Visibility(
             visible: viewModel.isLoading ? false : true,
             child: FloatingActionButton(
               heroTag: "heroTag1",
              elevation: 0.0,
              onPressed: () {
                userViewModel.isUser == false
                    ? Navigator.pushNamed(
                    context, "/loginpage")
                    :     Navigator.pushNamed(
                    context, "/first_page");
              },
              child: const Icon(Icons.add,size: 30,),
              backgroundColor: Color.fromRGBO(255, 196, 39, 1),
        ),
           ),
         ),
      ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ///Widget Card Buddhist/////////////////////////////////////////////////////////////////
  Widget buddhistCardItem(BuddhistViewModel viewModel) {
    if (viewModel.isLoading) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Center(child: CircularProgressIndicator()));
    }
    return Container(
      height: 284,
      alignment: Alignment.centerLeft,
      child:
      ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:viewModel.buddhistList.length,
          itemBuilder: (BuildContext context, int index) {
            return _CardItem(cardItem: viewModel.buddhistList, index: index);
          }),


    );
  }

  ///Widget Card Buddhist/////////////////////////////////////////////////////////////////
  Widget buddhistCardItemPopular(BuddhistViewModel viewModel) {
    if (viewModel.isLoading) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Center(child: CircularProgressIndicator()));
    }
    return Container(
      height: 284,
      alignment: Alignment.centerLeft,
       child:
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:viewModel.buddhistListPopular.length,
          itemBuilder: (BuildContext context, int index) {
            return _CardItem(
                cardItem: viewModel.buddhistListPopular, index: index);
          }),


    );
  }

  ///Widget Card Buddhist/////////////////////////////////////////////////////////////////
  Widget buddhistCardItemTimeLower(BuddhistViewModel viewModel) {
    if (viewModel.isLoading) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Center(child: CircularProgressIndicator()));
    }
    return Container(
      height: 284,
      alignment: Alignment.centerLeft,
      child:
      ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:viewModel.buddhistListTimeLower.length,
          itemBuilder: (BuildContext context, int index) {
            return _CardItem(
                cardItem: viewModel.buddhistListTimeLower, index: index);
          }),

    );
  }

  ///Widget Type Buddhist/////////////////////////////////////////////////////////////////
  Widget buddhistType(BuddhistViewModel viewModel) {

    if (viewModel.isLoading) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Center(child: CircularProgressIndicator()));
    }
    return Container(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.buddhistTypeList.length,
                  itemBuilder: (context, index) {
                    return _TypeItem(typeItem: viewModel.buddhistTypeList, index: index);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Class _CardItem ///////////////////////////////////////////////////////////////////////////
class _TypeItem extends StatefulWidget {
  final List<BuddhistType.Datum> typeItem;
  final int index;

  const _TypeItem({Key key, @required this.typeItem, @required this.index})
      : super(key: key);

  @override
  _TypeItemState createState() => _TypeItemState();
}

class _TypeItemState extends State<_TypeItem> {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));



  @override
  Widget build(BuildContext context) {
   return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Consumer<BuddhistTypeViewModel>(
        builder: (context, value, child) => InkWell(
          onTap: () {


            value.typeId = widget.typeItem[widget.index].id;
            value.typeName =
                widget.typeItem[widget.index].name;

            Navigator.pushNamed(
              context,
              "/typelistitempage",
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  cacheManager: customCacheManager,
                   key: UniqueKey(),
                  imageUrl:
                  "${widget.typeItem[widget.index].imagePath}",
                  fit: BoxFit.cover,
                  width: 60.0,
                  height: 60.0,
                  // maxHeightDiskCache: 75,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey),
                  errorWidget: (context, url, error) =>
                      Container(
                        color: Colors.black12,
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                ),
              ),
              Text(widget.typeItem[widget.index].name),
            ],
          ),
        ),
      ),
    );
  }
}


/// Class _CardItem ///////////////////////////////////////////////////////////////////////////
class _CardItem extends StatefulWidget {
  final List<BuddhistBottomSearch.Datum> cardItem;
  final int index;

  const _CardItem({Key key, @required this.cardItem, @required this.index})
      : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<_CardItem> {
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
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                          width: 162,
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
                        padding: EdgeInsets.fromLTRB(8,8,8,0),
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,8,8),
                      child: Consumer<BuddhistViewModel>(
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
