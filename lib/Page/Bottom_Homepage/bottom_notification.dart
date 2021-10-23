

import 'package:buddhistauction/Page/Bottom_Homepage/tabbar_notification/notificaiton_bidding_result.dart';
import 'package:buddhistauction/Page/Bottom_Homepage/tabbar_notification/notification_bidding.dart';
import 'package:buddhistauction/Page/Bottom_Homepage/tabbar_notification/notification_message.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_message_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_result_bidding_view_model.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BottomNotification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BottomNotificationState();
  }
}

class _BottomNotificationState extends State<BottomNotification>
    with AutomaticKeepAliveClientMixin {




  @override
  Widget build(BuildContext context) {
    super.build(context);



    return DefaultTabController(
      length: 3,
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ແຈ້ງເຕືອນ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          bottom: TabBar(
            labelColor: Color.fromARGB(255, 184, 133, 13),
            unselectedLabelColor: Colors.grey,

            tabs: [
              buildTabAuctionNotification(),
              buildTabAuctionWinAndLoseNotification(),
              buildTabMessageNotification(),


            ],
          ),

          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: TabBarView(
            children: [

              NotificationBidding(),
              NotificationBiddingResult(),
              NotificationMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Tab buildTabAuctionNotification() {
    return Tab(
                child: new Stack(
                    children: <Widget>[
                      Center(
                        child: Container(


                            child: FittedBox(child: new Text("ກຳລັງປະມູນ"))),
                      ),


                      Consumer<NotificationBiddingViewModel>(
                        builder: (context, value, child) {

                          if(value.notificationBidShow == true){
                            return   Positioned( // draw a red marble
                              top: 0.0,
                              right: 0.0,
                              child: new Icon(Icons.brightness_1, size: 8.0,
                                  color: Colors.redAccent),
                            );
                          }else{
                            return Container();
                          }

                        },
                      )


                    ]
                ),

               );
  }

  Tab buildTabAuctionWinAndLoseNotification() {
    return Tab(
      child: new Stack(
          children: <Widget>[
            Center(
              child: Container(


                  child: FittedBox(child: new Text("ປະຫວັດປະມູນ"))),
            ),






            Consumer<NotificationResultBiddingViewModel>(
              builder: (context, value, child) {

                if(value.notificationBidResultShow == true){
                  return   Positioned( // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: new Icon(Icons.brightness_1, size: 8.0,
                        color: Colors.redAccent),
                  );
                }else{
                  return Container();
                }

              },
            )
          ]
      ),

    );
  }
  Tab buildTabMessageNotification() {
    return Tab(
      child: new Stack(
          children: <Widget>[
            Center(
              child: Container(


                  child: FittedBox(child: new Text("ຂໍ້ຄວາມ"))),
            ),


            Consumer<NotificationMessageViewModel>(
              builder: (context, value, child) {

                if(value.notificationMessShow ==true ){
                  return   Positioned( // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: new Icon(Icons.brightness_1, size: 8.0,
                        color: Colors.redAccent),
                  );
                }else{
                  return Container();
                }

              },
            )
          ]
      ),

    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
   height: height,
   );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
