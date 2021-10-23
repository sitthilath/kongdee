import 'dart:async';


import 'package:buddhistauction/Model/buddhist_favorite.dart';
import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/FavoriteViewModel/favorite_view_model.dart';
import 'package:buddhistauction/Provider/countdown.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/Service/service_stream.dart';

import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


final currencyFormat = new NumberFormat("#,###", "en_US");

class BottomFollow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BottomFollowState();
  }
}

class _BottomFollowState extends State<BottomFollow>
    with AutomaticKeepAliveClientMixin,WidgetsBindingObserver {
  FavoriteViewModel _favoriteViewModel;
  int currentPage=1;
  ScrollController _scrollController =new ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    _favoriteViewModel = Provider.of<FavoriteViewModel>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _favoriteViewModel.fetchFavorite(context,currentPage);
    });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(currentPage>=_favoriteViewModel.buddhistListMeta.lastPage){
          print("isLastPage");

          _favoriteViewModel.isLastPage=true;
        }else{

          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(mounted){
              _favoriteViewModel.fetchFavorite(context,currentPage);
            }
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _favoriteViewModel.buddhistFavoriteList.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      if(mounted){
        _favoriteViewModel = Provider.of<FavoriteViewModel>(context, listen: false);
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if(mounted){

          currentPage=1;
          _favoriteViewModel.buddhistFavoriteList.clear();
          _favoriteViewModel.fetchFavorite(context,currentPage);
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
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ຕິດຕາມ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Consumer<FavoriteViewModel>(builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Container(
                    alignment: Alignment.centerLeft,
                    child: Center(child: WidgetStatic.buildLoadingCat()));
              }
          return RefreshIndicator(
            onRefresh: () async{
              currentPage=1;
              viewModel.buddhistFavoriteList.clear();
              await viewModel.fetchFavorite(context,1);

            },
            child: Stack(
              children: [
                ListView(

                    controller: _scrollController,
                    children: [
                  Divider(),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      children: [
                        viewModel.buddhistFavoriteList.length > 0
                            ? Text('${viewModel.buddhistFavoriteList.length} ລາຍການ')
                            : Text('0 ລາຍການ'),
                        Spacer(),
                        IconButton(onPressed: (){
                          viewModel.setIsGrid();
                        }, icon: Icon(viewModel.isGrid ?Icons.view_headline : Icons.apps))
                      ],
                    ),
                  ),
                  Divider(),
                viewModel.buddhistFavoriteList.length > 0
                        ? Stack(
                          children: [

                            viewModel.isGrid == false?
                            ListView.builder(

                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,

                                itemCount: viewModel.buddhistFavoriteList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _CardItem(
                                    cardItem: viewModel.buddhistFavoriteList,
                                    index: index,
                                  );
                                }):

                            GridView.builder(
                              padding: EdgeInsets.only(left:12,right: 12),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 284,
                                  crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:viewModel.buddhistFavoriteList.length,
                              itemBuilder: (context, index) {
                                return CardItemGrid(cardItem:viewModel.buddhistFavoriteList,index: index,);
                              },
                            ),

                            viewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
                                : Container(),
                          ],
                        )
                        : Container(),


                ]),
                viewModel.buddhistFavoriteList.isNotEmpty
                     ?
                    Container()
                    :
                Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

              ],
            ),
          );
        }),
      ),
      floatingActionButton: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) =>
    Consumer<FavoriteViewModel>(
    builder: (context, favoriteViewModel, child) =>
            Visibility(
              visible: favoriteViewModel.isLoading ? false : true,
              child: FloatingActionButton(
               heroTag: "heroTag2",
elevation: 0.0,
                onPressed: () {
                  userViewModel.isUser == false
                      ? Navigator.pushNamed(
                      context, "/loginpage")
                      :     Navigator.pushNamed(
                      context, "/first_page");
                },
                child: const Icon(Icons.add,size: 28,),
                backgroundColor: Color.fromRGBO(255, 196, 39, 1),
              ),
            ),
    ),
      ),

    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

class _CardItem extends StatefulWidget {
  final List<FavoriteInfo> cardItem;
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


  String _timeUntil = '';
  var maxPrice;
  var childLength;
  Timer _timer;
  int remainTime = 0;


  void _startTimer() {

    Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingFavorite = true;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if (this.mounted) {
        Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingFavorite = false;
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
      _startTimer();
      FirebaseDatabase.instance
          .reference()
          .child('buddhist')
          .child(widget.cardItem[widget.index].buddhistId.toString())
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId=widget.cardItem[widget.index].buddhistId;
          Navigator.of(context).pushNamed('/detailpage');
        },
        child: Container(
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
          child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              flex: 1,
              child: Container(
                width:100,
                height: 100,
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
            //10
            buildSizedBoxHeight(10),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 8,right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.cardItem[widget.index].place,
                          style: TextStyle(color: Colors.grey,fontSize: 14),
                        ),
                        Spacer(),
                        Consumer<CountDownProvider>(
                          builder: (context, value, child) =>
                          value.isTimesLoadingFavorite==true ?
                          SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(strokeWidth: 2,))
                              :
                          FittedBox(
                            child:
                            Text(
                              "$_timeUntil ",
                              style: TextStyle(color:  widget.cardItem[widget.index].timeRemain<=3600 ? Colors.redAccent :  Colors.blue),
                            ),

                          ),
                        ),
                      ],
                    ),
                    //20
                    buildSizedBoxHeight(5),
                    Text(
                      widget.cardItem[widget.index].name,
                      style: TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                    //15

                    StreamBuilder(
                      stream: ServiceStream.priceRealtime(
                          widget.cardItem[widget.index].buddhistId),
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_users.length - 1}' + ' ຄົນປະມູນ',
                                style: TextStyle(
                                  color: Colors.indigo,
                                ),
                              ),

                              Text(
                                '${currencyFormat.format(maxPrice)} Kip',
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    //10
                    buildSizedBoxHeight(10),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}

/// Class _CardItem ///////////////////////////////////////////////////////////////////////////
class CardItemGrid extends StatefulWidget {
  final List<FavoriteInfo> cardItem;
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
                child: Consumer<FavoriteViewModel>(
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
                             CircularProgressIndicator();

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
