
import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_result_bidding_view_model.dart';
import 'package:buddhistauction/Provider/bidding_result_detail_view_model.dart';

import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationBiddingResult extends StatefulWidget {
  @override
  _NotificationBiddingResultState createState() => _NotificationBiddingResultState();
}

class _NotificationBiddingResultState extends State<NotificationBiddingResult> {

  int currentPage=1;
  ScrollController _scrollController =new ScrollController();

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  NotificationResultBiddingViewModel _notificationResultBiddingViewModel;

  @override
  void initState() {

    _notificationResultBiddingViewModel = Provider.of<NotificationResultBiddingViewModel>(context,listen:false);


    SchedulerBinding.instance.addPostFrameCallback((_) {

      _notificationResultBiddingViewModel.fetchBiddingResultNotification(currentPage);
      _notificationResultBiddingViewModel.notificationBidResultShow = false;

    });
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(currentPage>=_notificationResultBiddingViewModel.buddhistListMeta.lastPage){
          print("isLastPage");

          _notificationResultBiddingViewModel.isLastPage=true;
        }else{
          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(mounted){
              _notificationResultBiddingViewModel.fetchBiddingResultNotification(currentPage);
            }
          });
        }
      }
    });

    super.initState();
  }
  @override
  void dispose() {
    _notificationResultBiddingViewModel.notificationResultBiddingList.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<NotificationResultBiddingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Container(
              alignment: Alignment.centerLeft,
              child: Center(child: WidgetStatic.buildLoadingCat()));
        }

       return RefreshIndicator(
          onRefresh: ()async{
          currentPage=1;
          viewModel.notificationResultBiddingList.clear();
          await viewModel.fetchBiddingResultNotification(1);

        },

          child: Stack(
            children: [
              ListView(
                controller: _scrollController,
                children: [

                  viewModel.notificationResultBiddingList.isNotEmpty
                  ?
                           Stack(
                             children: [
                               ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: viewModel.notificationResultBiddingList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:10.0,top:5.0),
                                          child: Align(
                                            alignment:Alignment.topLeft,
                                            child: Text(

                                              '${DateFormat('dd LLLL y','lo-LA').format(DateTime.parse(viewModel.notificationResultBiddingList[index].time))}   ເວລາ ${DateFormat.jm().format(DateFormat("hh:mm:ss").parse("${DateFormat.Hms().format(DateTime.parse(viewModel.notificationResultBiddingList[index].time))}"))}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        //5
                                        buildSizedBoxHeight(5),
                                        Stack(
                                          children: [
                                            Container(

                                              height: 210,
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

                                                      //5
                                                      buildSizedBoxHeight(5),
                                                      Row(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: [

                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                width: 126,
                                                                height: 126,
                                                                child:

                                                                CachedNetworkImage(
                                                                  cacheManager: customCacheManager,
                                                                  key: UniqueKey(),
                                                                  imageUrl:
                                                                  "${viewModel.notificationResultBiddingList[index].image[0]}",
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

                                                            Expanded(

                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                   Text(
                                                                      'ການປະມູນຈົບແລ້ວ',
                                                                      style: TextStyle(
                                                                          color:
                                                                          Colors.black,
                                                                          fontSize: 20,
                                                                      fontWeight: FontWeight.bold),
                                                                    ),
                                                                  SizedBox(height: 10,),
                                                                  Text(
                                                                    '${viewModel.notificationResultBiddingList[index].buddhistName}',
                                                                    style: TextStyle(

                                                                        fontSize: 20),
                                                                    overflow:TextOverflow.ellipsis,
                                                                  ),
                                                                  //5
                                                                  buildSizedBoxHeight(5),


                                                                  Consumer<UserViewModel>(
                                                                    builder: (context, userViewModel, child) =>
                                                                     Text(
                                                                      '${
                                                                          viewModel.notificationResultBiddingList[index].data.toString() == userViewModel.userId.toString()
                                                                              &&
                                                                       viewModel.notificationResultBiddingList[index].notificationType.toString() == "bidding_result"
                                                                              ?
                                                                      "ທ່ານຊະນະການປະມູນ "
                                                                              :
                                                                          viewModel.notificationResultBiddingList[index].data.toString() != userViewModel.userId.toString()
                                                                              &&
                                                                              viewModel.notificationResultBiddingList[index].notificationType.toString() == "bidding_result"
                                                                              ?
                                                                          "ທ່ານເສຍການປະມູນ "
                                                                              :
                                                                          viewModel.notificationResultBiddingList[index].data.toString() == "no_participant"
                                                                              &&
                                                                              viewModel.notificationResultBiddingList[index].notificationType.toString() == "owner_result"
                                                                              ?
                                                                              'ບໍ່ມີຄົນປະມູນ'
                                                                              :
                                                                          viewModel.notificationResultBiddingList[index].data.toString() == "have_participant"
                                                                              &&
                                                                              viewModel.notificationResultBiddingList[index].notificationType.toString() == "owner_result"
                                                                              ?
                                                                              'ຕິດຕໍ່ຫາຜູ້ຊະນະ'
                                                                              :
                                                                              ''
                                                                      }',
                                                                      style: TextStyle(
                                                                          color:
                                                                          viewModel.notificationResultBiddingList[index].data.toString() == userViewModel.userId.toString()
                                                                              &&
                                                                              viewModel.notificationResultBiddingList[index].notificationType == "bidding_result"
                                                                              ?
                                                                          Colors.blue
                                                                              :
                                                                          viewModel.notificationResultBiddingList[index].data.toString() != userViewModel.userId.toString()
                                                                              &&
                                                                              viewModel.notificationResultBiddingList[index].notificationType == "bidding_result"
                                                                              ?
                                                                          Colors.red
                                                                          :
                                                                          Colors.grey,
                                                                          fontSize: 16),
                                                                    ),
                                                                  ),
                                                                  //20
                                                                  buildSizedBoxHeight(20),
                                                                ],
                                                              ),
                                                            ),

                                                          ]),
                                                      Spacer(),

                                                      viewModel.notificationResultBiddingList[index].data.toString() == "no_participant"
                                                          &&
                                                          viewModel.notificationResultBiddingList[index].notificationType == "owner_result"
                                                          ?
                                                          Container()
                                                      :
                                                      Container(
                                                        height:51,
                                                        width: MediaQuery.of(context).size.width-10,
                                                        child: TextButton(

                                                          style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(15.0),
                                                                    bottomRight: Radius.circular(15.0))),
                                                          ),
                                                          onPressed: () {
                                                            Provider.of<BiddingResultDetailViewModel>(context,listen: false).buddhistId = viewModel.notificationResultBiddingList[index].buddhistId;
                                                            // Provider.of<BiddingResultDetailViewModel>(context,listen: false).buddhistTypeId = viewModel.notificationResultBiddingList[index].type;
                                                            Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistIdRemove = viewModel.notificationResultBiddingList[index].buddhistId.toString();
                                                            print( "ID TEST = ${ Provider.of<NotificationBiddingViewModel>(context,listen:false).notificationBidResultBuddhistId}");

                                                            if(viewModel.notificationResultBiddingList[index].data.toString() == "have_participant"
                                                                &&
                                                                viewModel.notificationResultBiddingList[index].notificationType == "owner_result"){
                                                              Provider.of<BiddingResultDetailViewModel>(context,listen: false).isOwner = true;

                                                            }else{
                                                              Provider.of<BiddingResultDetailViewModel>(context,listen: false).isOwner = false;
                                                            }


                                                            Navigator.of(context).pushNamed('/bidding_result_detail');
                                                          },
                                                          child: FittedBox(
                                                            child: Text(
                                                              'ເບິ່ງລາຍລະອຽດ',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
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

                                                  for(int i=0;i<value.notificationBidResultBuddhistId.length;i++){
                                                    print("notificationResultBiddingList:${viewModel
                                                        .notificationResultBiddingList[index].buddhistId.toString()}");
                                                    print("notificationResultBiddingListIndex:${value.notificationBidResultBuddhistId[i]}");
                                                    if(  value.notificationBidResultBuddhistId[i] == viewModel
                                                        .notificationResultBiddingList[index].buddhistId.toString()) {
                                                          print("thao kun");
                                                      return  Positioned( // draw a red marble
                                                        top: 10.0,
                                                        right: 10.0,
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

                                      ],
                                    );


                                  }),

                               viewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
                                   : Container(),
                             ],
                           )
                  :Container()


                ],
              ),

              viewModel.notificationResultBiddingList.isNotEmpty
                  ?
                  Container()
                  :
              Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

            ],
          ),
        );
      },

    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}
