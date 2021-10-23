import 'dart:async';


import 'package:buddhistauction/Model/buddhist_detail.dart' ;

import 'package:buddhistauction/Page/DetailPage/auction_close_date.dart';

import 'package:buddhistauction/Page/DetailPage/buddhist_recomend.dart';
import 'package:buddhistauction/Page/DetailPage/button_show_modal_bottom_sheet.dart';
import 'package:buddhistauction/Page/DetailPage/owner_info.dart';
import 'package:buddhistauction/Page/DetailPage/show_current_bidding.dart';
import 'package:buddhistauction/Page/DetailPage/show_question_and_answer.dart';
import 'package:buddhistauction/Page/DetailPage/silver_appbar_page.dart';

import 'package:buddhistauction/Page/Time/time_convert.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';

import 'package:buddhistauction/Provider/countdown.dart';

import 'package:buddhistauction/Provider/user_view_model.dart';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';


class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin,WidgetsBindingObserver {

@override
  void initState() {
  WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if(state == AppLifecycleState.resumed){

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ServiceApi.fetchBuddhistDetail(Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId);
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
      body:    Container(
              child: FutureBuilder<BuddhistDetail>(
                future: ServiceApi.fetchBuddhistDetail(Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return _CustomScrollView(buddhistDetailList: snapshot.data.data,);
                    }else{
                      return Center(child: WidgetStatic.buildLoadingCat());
                    }
                  },
                 )
          ),

    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _CustomScrollView extends StatefulWidget {

  final List<BuddhistDetailData> buddhistDetailList ;

  const _CustomScrollView({Key key, this.buddhistDetailList}) : super(key: key);


  @override
  __CustomScrollViewState createState() => __CustomScrollViewState();
}

class __CustomScrollViewState extends State<_CustomScrollView> {

  var maxPrice;
  int childLength = 0;
  String _timeUntil = '',
      token,
      idUser;
  Timer _timer;
  int remainTime = 0;
  bool isOwner = true;



  void _startTimer(BuildContext context) {
  Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingDetail=true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        Provider.of<CountDownProvider>(context,listen:false).isTimesLoadingDetail=false;
        _timeUntil = TimeConvert.timeLeft(widget.buddhistDetailList[0].timeRemain);
        if (widget.buddhistDetailList[0].timeRemain <= 0) {
          Provider.of<CountDownProvider>(context, listen: false)
              .setIsTimesUp(true);

          timer.cancel();
        } else {
          Provider.of<CountDownProvider>(context, listen: false)
              .setIsTimesUp(false);
          widget.buddhistDetailList[0].timeRemain--;
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
          .child(Provider
          .of<BuddhistDetailViewModel>(context, listen: false)
          .buddhistId
          .toString())
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
    return CustomScrollView(
      slivers: [
        SliverAppBarPage(buddhistDetailList: widget.buddhistDetailList,),

         buildSliverList(context),
      ],
    );
  }



  Widget buildSliverList(BuildContext context) {

        return SliverList(
          delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [

                  buildSizedBoxHeight(20),

                  Container(


                      child: Text(
                         widget.buddhistDetailList[0].name,
                        style: TextStyle(
                          fontFamily: 'boonhome',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),

                  ),

                  buildSizedBoxHeight(10),

                  Consumer<CountDownProvider>(builder: (context, value, child) {
                    return
                      value.isTimesLoadingDetail == true ?
                      CircularProgressIndicator():
                      FittedBox(
                        child: Text(
                          "ປິດ : $_timeUntil" ,
                          style: TextStyle(
                              color: widget.buddhistDetailList[0].timeRemain <=3600 ? Colors.redAccent : Colors.blue,
                              fontFamily: 'boonhome',
                              fontSize: 24),
                        ),
                      );
                  }),



                  buildSizedBoxHeight(20),

                  ShowCurrentBidding(buddhistDetailList: widget.buddhistDetailList,),

                  buildSizedBoxHeight(20),



                  Consumer<UserViewModel>(
                    builder: (context, userViewModel, child) {
                      if(  widget.buddhistDetailList[0].ownerId != userViewModel.userId){
                        return ButtonShowModalBottomSheet(buddhistDetailList: widget.buddhistDetailList,);
                      }

                      return Container();
                    },

                  ),

                  //H20
                  buildSizedBoxHeight(20),

                  AuctionCloseDate(buddhistDetailList: widget.buddhistDetailList,),

                  buildSizedBoxHeight(20),

                  buildAlign('ລາຍລະອຽດ', FontWeight.bold, 20, Colors.black),

                  buildSizedBoxHeight(10),

                  buildAlign('ສະພາບ', FontWeight.normal, 16,  Color.fromRGBO(159, 154, 168, 1),),

                  buildSizedBoxHeight(10),


                     buildAlign('${widget.buddhistDetailList[0].status}', FontWeight.normal,
                        16, Colors.black),

                  buildDivider(),

                  buildAlign('ລາຍລະອຽດ', FontWeight.normal, 16,Color.fromRGBO(159, 154, 168, 1),),

                  buildSizedBoxHeight(10),


                     buildAlign('${widget.buddhistDetailList[0].detail}', FontWeight.normal,
                        16, Colors.black),

                  buildDivider(),

                  buildAlign('ຈັດສົ່ງ', FontWeight.normal, 16, Color.fromRGBO(159, 154, 168, 1),),

                  buildSizedBoxHeight(10),

                  buildAlign('ຈັດເເຈງກັບຜູ້ຂາຍ',
                      FontWeight.normal, 16, Colors.black),

                  buildSizedBoxHeight(10),

                  buildDivider(),

                  buildAlign('ຊຳລ່ະຜ່ານທາງ', FontWeight.normal, 16, Color.fromRGBO(159, 154, 168, 1),),

                  buildSizedBoxHeight(10),

                  buildAlign('ຈັດເເຈງກັບຜູ້ຂາຍ',
                      FontWeight.normal, 16, Colors.black),

                  buildSizedBoxHeight(10),


                  buildDivider(),

                  ShowQuestionAndAnswer(),

                  buildDivider(),

                  buildAlign('ກ່ຽວກັບຜູ້ປ່ອຍ', FontWeight.bold, 20, Colors.black),

                  buildSizedBoxHeight(20),

                  OwnerInfo(ownerId: widget.buddhistDetailList[0].ownerId,),

                  buildDivider(),


                  buildAlign('ສີນຄ້າອື່ນໆເຈົ້າໜ້າຈະສົນໃຈ', FontWeight.bold, 20,
                      Colors.black),

                  buildSizedBoxHeight(20),

                  BuddhistRecommend(buddhistDetailList: widget.buddhistDetailList,),
                ],
              ),
            ),
          ]),
        );

  }


  Align buildAlign(
      String text, FontWeight fontWeight, double size, Color color) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$text',
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: size,
            color: color,
          ),
        ));
  }

  Spacer buildSpacer() => Spacer();

  Divider buildDivider() => Divider();

  SizedBox buildSizedBoxWidth(double width) {
    return SizedBox(
      width: width,
    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}

