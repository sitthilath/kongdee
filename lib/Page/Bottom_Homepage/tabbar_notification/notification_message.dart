

import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_message_view_model.dart';
import 'package:buddhistauction/Provider/argument_comment.dart';

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

import '../../inbox_message.dart';
class NotificationMessage extends StatefulWidget {
  @override
  _NotificationMessageState createState() => _NotificationMessageState();
}

class _NotificationMessageState extends State<NotificationMessage> {

  int currentPage=1;
  ScrollController _scrollController =new ScrollController();

  NotificationMessageViewModel _notificationMessageViewModel;


  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));




  @override
  void initState() {



    _notificationMessageViewModel = Provider.of<NotificationMessageViewModel>(context,listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {

      _notificationMessageViewModel.fetchMessageNotification(currentPage);
      _notificationMessageViewModel.notificationMessShow=false;


    });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(currentPage>=_notificationMessageViewModel.buddhistListMeta.lastPage){
          print("isLastPage");

          _notificationMessageViewModel.isLastPage=true;
        }else{
          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(mounted){
              _notificationMessageViewModel.fetchMessageNotification(currentPage);
            }
          });
        }
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _notificationMessageViewModel.notificationMessageList.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Consumer<NotificationMessageViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Container(
              alignment: Alignment.centerLeft,
              child: Center(child: WidgetStatic.buildLoadingCat()));
        }
       return RefreshIndicator(
          onRefresh: () async{
       currentPage=1;
       viewModel.notificationMessageList.clear();
       await viewModel.fetchMessageNotification(1);

       },
          child: Stack(
            children: [
              ListView(
                controller: _scrollController,
                children: [
                  viewModel.notificationMessageList.isNotEmpty?
                   Stack(
                     children: [
                       ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: viewModel.notificationMessageList.length,
                                  itemBuilder: (context, index) {

                                    return Column(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 5.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(

                                              '${DateFormat('dd LLLL y', 'lo-LA')
                                                  .format(DateTime.parse(
                                                  viewModel.notificationMessageList[index]
                                                      .time))}   ເວລາ ${DateFormat.jm()
                                                  .format(DateFormat("hh:mm:ss").parse(
                                                  "${DateFormat.Hms().format(
                                                      DateTime.parse(
                                                          viewModel.notificationMessageList[index].time))}"))}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        //5
                                        buildSizedBoxHeight(5),
                                        Consumer<ArgumentComment>(
                                          builder: (context, value, child) =>
                                              GestureDetector(
                                                onTap: () {
                                                  value.setId(viewModel.notificationMessageList[index]
                                                      .buddhistId);
                                                  Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationMessageBuddhistIdRemove = viewModel.notificationMessageList[index].buddhistId.toString();
                                                  print( "ID TEST = ${ Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationMessageBuddhistId}");


                                                  viewModel.notificationMessageList[index].notificationType != "result_message"
                                                  ?
                                                  Navigator.pushNamed(
                                                      context, "/content_detail")

                                                      :
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                      InboxMessage(
                                                        sendTo: "${viewModel.notificationMessageList[index].senderId}",
                                                        buddhistId:viewModel.notificationMessageList[index].buddhistId,
                                                      )));
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      // color: viewModel.notificationMessageList[index]
                                                      //     .read == 0
                                                      //     ? Colors.blue.shade100
                                                      //     : Colors.white30,
                                                    color:Colors.white30,
                                                      width:
                                                      MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        children: [


                                                          Row(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [

                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Container(

                                                                    height: 80,
                                                                    child: ClipRRect(


                                                                      child:
                                                                      CachedNetworkImage(
                                                                        cacheManager: customCacheManager,
                                                                        key: UniqueKey(),
                                                                        imageUrl:
                                                                        "${viewModel.notificationMessageList[index]
                                                                            .image[0]}",
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
                                                                ),
                                                                //10
                                                                buildSizedBoxHeight(10),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child:
                                                                  viewModel.notificationMessageList[index].notificationType != "result_message"?
                                                                  Container(
                                                                    padding: EdgeInsets
                                                                        .all(8),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [

                                                                        RichText(
                                                                          text: TextSpan(

                                                                      children: <InlineSpan>[

                                                                    WidgetSpan(
                                                                        alignment: PlaceholderAlignment.middle,
                                                                        child: buildSenderName(viewModel.notificationMessageList[index].buddhistId)),

                                                                        TextSpan(text:' ສະແດງຄວາມຄິດເຫັນຕໍ່ ' ,style: TextStyle(color: Colors.grey[600]),),
                                                                    TextSpan(
                                                                    text:'${viewModel.notificationMessageList[index]
                                                                        .buddhistName}',
                                                                    style: TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(184, 133, 13, 1),
                                                                      fontSize: 16),
                                                                ),
                                                                      ]
                                                                    ),


                                                                        ),


                                                                        //5
                                                                        buildSizedBoxHeight(
                                                                            5),


                                                                        RichText(text: TextSpan(
                                                                          text:'ຄວາມຄິດເຫັນ: ',
                                                                            style: TextStyle(
                                                                                color: Colors.grey[600],
                                                                                fontSize: 14),
                                                                          children: [
                                                                            TextSpan(
                                                                              text:'"${viewModel.notificationMessageList[index]
                                                                                  .data}"',
                                                                              style: TextStyle(
                                                                                  color: Colors.indigo,
                                                                                  fontSize: 16),
                                                                            ),
                                                                          ]
                                                                        ))


                                                                      ],
                                                                    ),
                                                                  )
                                                                      :
                                                                  Container(
                                                                    padding: EdgeInsets
                                                                        .all(8),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [

                                                                        RichText(
                                                                          text: TextSpan(

                                                                              children: <InlineSpan>[


                                                                                WidgetSpan(
                                                                                    alignment: PlaceholderAlignment.middle,
                                                                                    child:  Text(

                                                                                      '${viewModel.notificationMessageList[index].senderName}',
                                                                                      style: TextStyle(
                                                                                          color: Colors.black,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 18),
                                                                                    ),

                                                                                ),
                                                                                TextSpan(text:' ໄດ້ສົ່ງຂໍ້ຄວາມຫາເຈົ້າ' ,style: TextStyle(color: Colors.grey[600]),),

                                                                              ]
                                                                          ),


                                                                        ),


                                                                        //5
                                                                        buildSizedBoxHeight(
                                                                            5),


                                                                        RichText(text: TextSpan(
                                                                            text:'ຂໍ້ຄວາມ: ',
                                                                            style: TextStyle(
                                                                                color: Colors.grey[600],
                                                                                fontSize: 14),
                                                                            children: [
                                                                              TextSpan(
                                                                                text:'"${viewModel.notificationMessageList[index]
                                                                                    .data}"',
                                                                                style: TextStyle(
                                                                                    color: Colors.indigo,
                                                                                    fontSize: 16),
                                                                              ),
                                                                            ]
                                                                        ))

                                                                      ],
                                                                    ),
                                                                  )
                                                                ),

                                                              ]),
                                                        ],
                                                      ),
                                                    ),
                                                    Consumer<NotificationBiddingViewModel>(
                                                        builder: (context, value, child) {

                                                          for(int i=0;i<value.notificationMessageBuddhistId.length;i++){
                                                            if(  value.notificationMessageBuddhistId[i] == viewModel
                                                                .notificationMessageList[index].buddhistId.toString()) {

                                                              return  Positioned( // draw a red marble
                                                                top: 0.0,
                                                                right: 5.0,
                                                                child: Icon(Icons.circle_notifications, size: 20.0,
                                                                    color: Color.fromRGBO(255, 196, 39, 1)),
                                                              );
                                                            }
                                                          }

                                                          return SizedBox();


                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  }),
                       viewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
                           : Container(),
                     ],
                   )
                      :
                      Container()


                ],
              ),
              viewModel.notificationMessageList.isNotEmpty
                  ?
                  Container()
                  :
              Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

            ],
          ),
        );

      });
  }



  buildSenderName(int buddhistId){
    return Consumer<UserViewModel>(
      builder: (context, value, child) =>
       StreamBuilder(
        stream: ServiceStream.commentRealtime(buddhistId),

        builder: (BuildContext context,
            AsyncSnapshot snapshot) {
          print("$snapshot");
          if (snapshot.hasData) {

            final snapshotResult =
            snapshot.data.snapshot as DataSnapshot;

            final Map<dynamic, dynamic> values =
                snapshotResult.value;

            final List<String> _name = [];
            values.forEach((key, item) {
                if(item['user_id'].toString() != value.userId.toString()){
                  _name.add(item['name']);
                }

            });
            int index = _name.length;
            return Text(
              '${_name[index-1]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            );
          } else if (snapshot.hasError) {

            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner

          return Center(
              child: CircularProgressIndicator());
        },
      ),
    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}
