
import 'dart:async';

import 'package:buddhistauction/Model/buddhist_bottom_search.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_view_model.dart';
import 'package:buddhistauction/Provider/StoreData/store_token.dart';

import 'package:buddhistauction/Provider/bidding_result_detail_view_model.dart';
import 'package:buddhistauction/Provider/countdown.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'Time/time_convert.dart';

import 'dart:math' as math;

final currencyFormat = new NumberFormat("#,###", "en_US");

class BiddingResultDetail extends StatefulWidget {
  @override
  _BiddingResultDetailState createState() => _BiddingResultDetailState();
}

class _BiddingResultDetailState extends State<BiddingResultDetail> {


  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  BiddingResultDetailViewModel _biddingResultDetailViewModel;

  @override
  void initState() {
  _biddingResultDetailViewModel = Provider.of<BiddingResultDetailViewModel>(context,listen:false);

  SchedulerBinding.instance.addPostFrameCallback((_) {
    _biddingResultDetailViewModel.fetchBiddingResultDetail(Provider.of<BiddingResultDetailViewModel>(context,listen:false).buddhistId);
  });
    super.initState();
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
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
        elevation: 0.0,
        title: Text("ລາຍລະອຽດຜົນການປະມູນ",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),centerTitle: true,),
      body:
      Consumer<BiddingResultDetailViewModel>(
        builder: (context, brdViewModel, child) {
          if(brdViewModel.isOwner == true){
            return ForOwner();
          }else{
            return Consumer<BiddingResultDetailViewModel>(
                builder: (context, viewModel, child) {
                  if(viewModel.isLoading == true){
                    return Align(
                        alignment: Alignment.center,
                        child: WidgetStatic.buildLoadingCat());
                  }
                  return RefreshIndicator(
                    onRefresh: ()=>viewModel.fetchBiddingResultDetail(Provider.of<BiddingResultDetailViewModel>(context,listen:false).buddhistId),
                    child: ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [

                              Container(

                                child: Text("${viewModel.biddingResultList.text}",
                                  style: TextStyle(color: viewModel.biddingResultList.text == "ທ່ານແພ້ການປະມູນໃນຄັ້ງນີ້"? Colors.red:Colors.blue,fontSize: 16),),
                              ),


                              Column(

                                children: [


                                  Container(
                                    padding: EdgeInsets.only(top:10),
                                    child: viewModel.biddingResultList.buddhistImage[0] != null
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(),
                                        Container(
                                          width: 126,
                                          height: 126,
                                          child:   ClipRRect(
                                            borderRadius: BorderRadius.circular(5),
                                            child: CachedNetworkImage(
                                              cacheManager: customCacheManager,
                                              key: UniqueKey(),
                                              imageUrl:
                                              "${viewModel.biddingResultList.buddhistImage[0]}",
                                              fit: BoxFit.cover,
                                              // maxHeightDiskCache: 75,
                                              placeholder: (context, url) =>
                                                  Container(color: Colors.grey),
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.black12,
                                                child: Icon(Icons.error, color: Colors.red),
                                              ),
                                            ),
                                          ),),

                                        Container(),
                                      ],
                                    )
                                        : Container(
                                        padding: EdgeInsets.all(48),
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                    "asset/gif/loading.gif")))),),
                                  Divider(),
                                  Container(
                                    padding:EdgeInsets.only(left:30),
                                    alignment: Alignment.centerLeft,
                                    child: buildTextTitle("ຜູ້ຊະນະການປະມູນ "),

                                  ),
                                  Container(
                                    padding:EdgeInsets.only(top:10,),
                                    alignment: Alignment.centerLeft,
                                    child: Row(

                                      children: [
                                        buildIcon(Icons.person_outline),
                                        buildSizedBoxWidth(),
                                        buildTextBody("${viewModel.biddingResultList.winnerName} ${viewModel.biddingResultList.winnerSurname}"),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    padding:EdgeInsets.only(left:30),
                                    alignment: Alignment.centerLeft,
                                    child: buildTextTitle("ຊະນະການປະມູນໃນລາຄາ "),
                                  ),
                                  Container(
                                    padding:EdgeInsets.only(top:10),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        buildIcon(Icons.gavel),
                                        buildSizedBoxWidth(),
                                        buildTextBody("${currencyFormat.format(viewModel.biddingResultList.winnerPrice)} Kip"),
                                      ],
                                    ),

                                  ),
                                ],),
                              Divider(),
                              viewModel.biddingResultList.text=="ທ່ານຊະນະການປະມູນໃນຄັ້ງນີ້"? Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top:10),
                                    child: Text("ຊ່ອງທາງການຕິດຕໍ່ຫາຜູ້ປ່ອຍ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                  ),
                                  Column(children: [

                                    Container(
                                      padding: EdgeInsets.only(top:10),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage("${viewModel.biddingResultList.ownerImage}"),),
                                    ),
                                    Divider(),
                                    Container(
                                      padding:EdgeInsets.only(left:30),
                                      alignment: Alignment.centerLeft,
                                      child: buildTextTitle("ຜູ້ປ່ອຍເຄື່ອງ "),
                                    ),
                                    Container(
                                      padding:EdgeInsets.only(top:10),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          buildIcon(Icons.person),
                                          buildSizedBoxWidth(),
                                          buildTextBody("${viewModel.biddingResultList.ownerName} ${viewModel.biddingResultList.ownerName}"),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding:EdgeInsets.only(left:30),
                                      alignment: Alignment.centerLeft,
                                      child:buildTextTitle("ເບີຕິດຕໍ່"),
                                    ),
                                    Container(
                                      padding:EdgeInsets.only(top:10),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          buildIcon(Icons.phone),
                                          buildSizedBoxWidth(),
                                          buildTextBody("${viewModel.biddingResultList.ownerPhone}"),
                                        ],
                                      ),

                                    ),
                                    Divider(),
                                  ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(primary:Colors.green[700], ),
                                        child: Row(

                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(width: 5,),
                                            Text("ໂທເລີຍ !!!",style: TextStyle(fontSize: 14),)

                                          ],),
                                        onPressed: () async {
                                          _callNumber(viewModel.biddingResultList.ownerPhone);
                                        },
                                      ),
                                      Consumer<StoreTokenProvider>(
                                        builder: (context, value, child) =>
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(primary:Colors.yellow[700], ),
                                              child: Row(

                                                children: [
                                                  Icon(Icons.message_outlined,color: Colors.black,),
                                                  SizedBox(width: 5,),
                                                  Text("ສົ່ງຂໍ້ຄວາມ",style: TextStyle(fontSize: 14,color: Colors.black,),)

                                                ],),
                                              onPressed: () async {

                                                ServiceApi.fetchCheckChatRoom(value.tokens, context,"${viewModel.biddingResultList.ownerId}",viewModel.biddingResultList.buddhistId);
                                              },
                                            ),
                                      ),
                                    ],
                                  )
                                ],
                              ) : Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Text('ສິນຄ້າອື່ນໆເຈົ້າໜ້າຈະສົນໃຈ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  BuddhistRecommendForLoser(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

            );
          }
        },
      )

    );
  }

  Icon buildIcon(IconData icon) => Icon(icon,color: Color.fromRGBO(184, 133, 13, 1),);

  SizedBox buildSizedBoxWidth() => SizedBox(width: 8,);

  Text buildTextBody(String body ) => Text(body,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14),);

  Text buildTextTitle(String title) => Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),);

  _callNumber(String phoneNumber) async{
    String number = '$phoneNumber'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}


class BuddhistRecommendForLoser extends StatefulWidget {
  

  @override
  _BuddhistRecommendForLoserState createState() => _BuddhistRecommendForLoserState();
}

class _BuddhistRecommendForLoserState extends State<BuddhistRecommendForLoser> with WidgetsBindingObserver {


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
    if(state == AppLifecycleState.resumed){
      if(mounted){
        _buddhistViewModel = Provider.of<BuddhistViewModel>(context, listen: false);
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _buddhistViewModel.fetchBuddhists(context);

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
            child: Consumer<BuddhistViewModel>(
              builder: (context, viewModel, child) {
                if(viewModel.isLoading == true){
                  return Container(
                      alignment: Alignment.center,
                      child: WidgetStatic.buildLoadingCat() );
                }

                  return Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.buddhistList.length >= 6 ? 6 : viewModel.buddhistList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemOther(cardItem: viewModel.buddhistList, index: index);

                        }),
                  );
              }
            ),
          ),
        ],
      ),
    );
  }
}



class ForOwner extends StatefulWidget {
  @override
  _ForOwnerState createState() => _ForOwnerState();
}

class _ForOwnerState extends State<ForOwner> {




  @override
  Widget build(BuildContext context) {
    return Consumer<BiddingResultDetailViewModel>(
        builder: (context, viewModel, child) {
          if(viewModel.isLoading == true){
            return Align(
                alignment: Alignment.center,
                child: WidgetStatic.buildLoadingCat());
          }
          return RefreshIndicator(
            onRefresh: ()=>viewModel.fetchBiddingResultDetail(Provider.of<BiddingResultDetailViewModel>(context,listen:false).buddhistId),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [

                      Container(
                        padding: EdgeInsets.only(top:10),
                        child: Text("ຊ່ອງທາງການຕິດຕໍ່ຫາຜູ້ຊະນະ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      ),


                      Column(

                        children: [

                          Container(
                            padding: EdgeInsets.only(top:10),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage("${viewModel.biddingResultList.winnerImage}"),),
                          ),

                          Container(
                            padding:EdgeInsets.only(left:30),
                            alignment: Alignment.centerLeft,
                            child: buildTextTitle("ຜູ້ຊະນະການປະມູນ "),

                          ),
                          Container(
                            padding:EdgeInsets.only(top:10,),
                            alignment: Alignment.centerLeft,
                            child: Row(

                              children: [
                                buildIcon(Icons.person_outline),
                                buildSizedBoxWidth(),
                                buildTextBody("${viewModel.biddingResultList.winnerName} ${viewModel.biddingResultList.winnerSurname}"),
                              ],
                            ),
                          ),
                          Divider(),
                          Container(
                            padding:EdgeInsets.only(left:30),
                            alignment: Alignment.centerLeft,
                            child: buildTextTitle("ຊະນະການປະມູນໃນລາຄາ "),
                          ),
                          Container(
                            padding:EdgeInsets.only(top:10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                buildIcon(Icons.gavel),
                                buildSizedBoxWidth(),
                                buildTextBody("${currencyFormat.format(viewModel.biddingResultList.winnerPrice)} Kip"),
                              ],
                            ),

                          ),
                        ],),
                      Divider(),
                      Column(
                        children: [

                          Column(children: [

                            Container(
                              padding:EdgeInsets.only(left:30),
                              alignment: Alignment.centerLeft,
                              child:buildTextTitle("ເບີຕິດຕໍ່"),
                            ),
                            Container(
                              padding:EdgeInsets.only(top:10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  buildIcon(Icons.phone),
                                  buildSizedBoxWidth(),
                                  buildTextBody("${viewModel.biddingResultList.winnerPhone}"),
                                ],
                              ),

                            ),
                            Divider(),
                          ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(primary:Colors.green[700], ),
                                child: Row(

                                  children: [
                                    Icon(Icons.phone),
                                    SizedBox(width: 5,),
                                    Text("ໂທເລີຍ !!!",style: TextStyle(fontSize: 14),)

                                  ],),
                                onPressed: () async {
                                  _callNumber(viewModel.biddingResultList.winnerPhone);
                                },
                              ),
                              Consumer<StoreTokenProvider>(
                                builder: (context, value, child) =>
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary:Colors.yellow[700], ),
                                      child: Row(

                                        children: [
                                          Icon(Icons.message_outlined,color: Colors.black,),
                                          SizedBox(width: 5,),
                                          Text("ສົ່ງຂໍ້ຄວາມ",style: TextStyle(fontSize: 14,color: Colors.black,),)

                                        ],),
                                      onPressed: () async {

                                        ServiceApi.fetchCheckChatRoom(value.tokens, context, "${viewModel.biddingResultList.winnerId}",viewModel.biddingResultList.buddhistId);
                                      },
                                    ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }

    );
  }


  Icon buildIcon(IconData icon) => Icon(icon,color: Color.fromRGBO(184, 133, 13, 1),);

  SizedBox buildSizedBoxWidth() => SizedBox(width: 8,);

  Text buildTextBody(String body ) => Text(body,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14),);

  Text buildTextTitle(String title) => Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),);

  _callNumber(String phoneNumber) async{
    String number = '$phoneNumber'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
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
          Navigator.of(context).pushNamed('/detailpage');
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
                                style: TextStyle(color:  widget.cardItem[widget.index].timeRemain<=3600 ? Colors.redAccent :  Colors.blue),
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