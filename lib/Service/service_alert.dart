
import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/audio_players.dart';
import 'package:buddhistauction/Provider/bidding_result_detail_view_model.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class ServiceAlert{

  static popupWin(BuildContext context,String buddhistId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return new Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      GestureDetector(onTap: (){
                        Provider.of<BiddingResultDetailViewModel>(context,listen: false).buddhistId =int.parse(buddhistId) ;

                        Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistIdRemove = buddhistId.toString();
                        print( "ID TEST = ${ Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistId}");

                        Provider.of<BiddingResultDetailViewModel>(context,listen: false).isOwner = false;
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/bidding_result_detail');
                      },child: Image.asset("asset/gif/cat_winner.gif")),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(

                    child: Card(
                      color: Colors.white,
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),),

                      child: IconButton(
                          icon: Icon(Icons.clear,color:Colors.red,size: 30,),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        });
  }

  static popupLost(BuildContext context,String buddhistId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return new Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      GestureDetector(
                          onTap: (){
                            Provider.of<BiddingResultDetailViewModel>(context,listen: false).buddhistId = int.parse(buddhistId);

                            Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistIdRemove = buddhistId.toString();
                            print( "ID TEST = ${ Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistId}");

                            Provider.of<BiddingResultDetailViewModel>(context,listen: false).isOwner = false;
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed('/bidding_result_detail');
                          },
                          child: Image.asset("asset/gif/cat_crying.gif")),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(

                    child: Card(
                      color: Colors.white,
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),),

                      child: IconButton(
                          icon: Icon(Icons.clear,color:Colors.red,size: 30,),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        });
  }
  static popupNewBuyer(BuildContext context,String buddhistId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return new Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      GestureDetector(
                          onTap: (){
                            Provider.of<BiddingResultDetailViewModel>(context,listen: false).buddhistId = int.parse(buddhistId);
                            Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistIdRemove = buddhistId.toString();
                            print( "ID TEST = ${ Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistId}");



                            Provider.of<BiddingResultDetailViewModel>(context,listen: false).isOwner = true;



                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed('/bidding_result_detail');
                          },
                          child: Image.asset("asset/gif/cat_selled.gif")),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(

                    child: Card(
                      color: Colors.white,
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),),

                      child: IconButton(
                          icon: Icon(Icons.clear,color:Colors.red,size: 30,),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        });
  }

  static popupNoBuyer(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return new Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      GestureDetector(onTap: (){
                        Navigator.of(context).pop();
                        Provider.of<UserViewModel>(context,listen:false).isUser == false
                            ? Navigator.pushNamed(
                            context, "/loginpage")
                            :     Navigator.pushNamed(
                            context, "/first_page");
                      },child: Image.asset("asset/gif/cat_no_one.gif")),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(

                    child: Card(
                      color: Colors.white,
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),),

                      child: IconButton(
                          icon: Icon(Icons.clear,color:Colors.red,size: 30,),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        });
  }

  static  messageAlertOneButton(String msg,  BuildContext context,int checkLogOrReg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return new CupertinoAlertDialog(


            content: Column(
              children: [
                Icon(Icons.warning_rounded,size: 64,color: Colors.red,),
                Column(
                  children: [
                    Text("$msg", style: TextStyle(fontFamily: 'boonhome',fontSize: 18,fontWeight: FontWeight.bold)),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5,top:10),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(

                          backgroundColor: Color.fromARGB(255, 62, 13, 184) ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'ປິດ',
                          style: TextStyle(fontFamily: 'boonhome',fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);

                          if(checkLogOrReg==1){
                            Navigator.of(context).pushNamedAndRemoveUntil(
                            "/landingpage", (Route<dynamic> route) => false);

                          }else if(checkLogOrReg==2){
                            Navigator.popUntil(context, ModalRoute.withName('/loginpage'));

                          }else if(checkLogOrReg==3){
                            Navigator.popUntil(context, ModalRoute.withName('/forgetpasswordpage'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

          );
        });
  }

 static messageAlertTwoButton(String msg, String ttl,BuildContext context,String page) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoButton(
                  child: Text(
                    "ຍົກເລີກ",
                    style: TextStyle(
                      fontFamily: 'boonhome',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }),
              CupertinoButton(
                child: Text("ຕົກລົງ", style: TextStyle(fontFamily: 'boonhome')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if(page == "unauth"){
                    Navigator.pushNamed(context, "/loginpage");
                  }
                },
              )
            ],
          );
        });
  }


  static openDialogBidding(context, String price, int fbPrice, int id,int remainTime,bool checkAdded) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          int priceAuction = int.parse(price) + fbPrice;
          String priceFormat = NumberFormat("#,##0.00", "en_US").format(priceAuction);
          return new CupertinoAlertDialog(
            title:    Image.asset("asset/gif/hammer.gif",width: 100,height: 100,),
            content: Column(
              children: [
                SizedBox(height: 5,),

          Text("ປະມູນ",style: Theme.of(context).textTheme.headline4,),
                SizedBox(height: 10,),
                Text("ທ່ານຕ້ອງການປະມູນ",style: Theme.of(context).textTheme.headline6,),
                Text("ໃນລາຄາ $priceFormat Kip ?",style: Theme.of(context).textTheme.headline6,),
              ],
            ),

            actions: [
              CupertinoButton(
                  child: Text(
                    "ຍົກເລີກ",
                    style: TextStyle(
                      fontFamily: 'boonhome',
                    ),
                  ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },),
              CupertinoButton(
                child: Text("ຕົກລົງ", style: TextStyle(fontFamily: 'boonhome')),
                onPressed: () {
                  int priceAuction = int.parse(price) + fbPrice;
                  Navigator.of(ctx).pop();
                  ServiceApi.insertDataBidding(
                      priceAuction, id, remainTime, checkAdded,  context);


                 alertLoading(context);


                },
              )
            ],
          );
        });
  }


  static  alertSuccessBidding(BuildContext context) {
    Provider.of<AudioPlayers>(context,listen:false).playLocalSound();
    showDialog(

        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {

          return new CupertinoAlertDialog(

            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("asset/gif/hammer.gif"),

                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("ສຳເລັດແລ້ວ", style: TextStyle(fontFamily: 'boonhome',fontSize: 18,fontWeight: FontWeight.bold)),
                ),

                Container(
                  margin: EdgeInsets.only(left: 5,right: 5,top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<AudioPlayers>(
                    builder: (context, value, child) =>
                        ElevatedButton(
                          style: TextButton.styleFrom(

                            backgroundColor: Color.fromARGB(255, 62, 13, 184) ,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            'ປິດ',
                            style: TextStyle(fontFamily: 'boonhome',fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {


                              Navigator.pop(ctx);
                              Navigator.pop(context);



                          },
                        ),
                  ),
                ),
              ],
            ),

          );
        });
  }

  static  alertSuccess(BuildContext context,String path) {
    Provider.of<AudioPlayers>(context,listen:false).playLocalSound();
    showDialog(

        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {

          return new CupertinoAlertDialog(

            content: Column(
              children: [
                Icon(Icons.check_circle_outline,size: 64,color: Colors.teal,),
                Column(
                  children: [
                    Text("ສຳເລັດແລ້ວ", style: TextStyle(fontFamily: 'boonhome',fontSize: 18,fontWeight: FontWeight.bold)),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5,top:10),
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<AudioPlayers>(
                        builder: (context, value, child) =>
                         ElevatedButton(
                          style: TextButton.styleFrom(

                            backgroundColor: Color.fromARGB(255, 62, 13, 184) ,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            'ປິດ',
                            style: TextStyle(fontFamily: 'boonhome',fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {

                            if(path == "release"){
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(context, "/homepage", (route) => false);
                            }else if(path == "forget"){
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(context, "/loginpage", (route) => false);
                            }
                            else{
                              Navigator.pop(ctx);
                              Navigator.pop(context);
                            }


                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          );
        });
  }

  static  alertError(BuildContext context,String errorMessage) {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return new CupertinoAlertDialog(

            content: Column(
              children: [
                Icon(Icons.warning_rounded,size: 64,color: Colors.red,),
                Column(
                  children: [
                    Text("$errorMessage", style: TextStyle(fontFamily: 'boonhome',fontSize: 18,fontWeight: FontWeight.bold)),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5,top:10),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(

backgroundColor: Color.fromARGB(255, 62, 13, 184) ,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'ປິດ',
                          style: TextStyle(fontFamily: 'boonhome',fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

          );
        });
  }

  static alertLoading(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return new CupertinoAlertDialog(
            title: Center(child: Container(width: 25,height: 25,child: CircularProgressIndicator(strokeWidth: 4,)),),
            content: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Center(child: Text("ກະລຸນາລໍຖ້າ...")),
            ),

          );
        });
  }


}