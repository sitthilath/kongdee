
import 'package:buddhistauction/Provider/argument_comment.dart';
import 'package:buddhistauction/Provider/owner_view_model.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';



class InboxMessage extends StatefulWidget {

  final String sendTo;
  final int buddhistId;

  const InboxMessage({Key key,this.sendTo,this.buddhistId}) : super(key: key);
  @override
  _InboxMessageState createState() => _InboxMessageState();
}

class _InboxMessageState extends State<InboxMessage> {

  final TextEditingController _msgTextController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String datetimeCheck="";

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  _scrollToEnd() async{
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  OwnerViewModel _ownerVieWModel;
  @override
  void initState() {
    print('init');
  _ownerVieWModel = Provider.of<OwnerViewModel>(context,listen:false);

  SchedulerBinding.instance.addPostFrameCallback((_) {
    _ownerVieWModel.fetchOwner(context, "${widget.sendTo}");
  });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pop(context);
              }
          ),
          backgroundColor: Color.fromRGBO(255, 196, 39, 1),
          elevation: 0.0,

          title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer<OwnerViewModel>(
                  builder: (context, ownerViewModel, child) {

                    if(ownerViewModel.isLoading){
                      return CircularProgressIndicator();
                    }
                    return Container(
                      height: 45,
                      width: 45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000.0),
                        child:
                        CachedNetworkImage(
                          cacheManager: customCacheManager,
                          key: UniqueKey(),
                          imageUrl:
                          "${ownerViewModel.ownerList.picture}",
                          fit: BoxFit.cover,
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
                    );

                  }
              ),
              SizedBox(width:5),
              Consumer<OwnerViewModel>(
                  builder: (context, ownerViewModel, child) {
                    if(ownerViewModel.isLoading){
                      return CircularProgressIndicator();
                    }
                    return FittedBox(child: Text(
                      "${ownerViewModel.ownerList.phoneNumber}", style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),));
                  }
                    ),
            ],
          ),

        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Consumer<OwnerViewModel>(
                builder: (context, ownerViewModel, child) {
                  if(ownerViewModel.isLoading){
                    return CircularProgressIndicator();
                  }
               return   GestureDetector(
                    onTap: () {
                      _callNumber(ownerViewModel.ownerList.phoneNumber);
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TestMessage()));
                    },
                    child: Icon(
                      Icons.phone,
                      size: 26.0,
                    ),
                  );
                }
              )
          ),
        ],
        ),
body: Column(

  children: [



         Expanded(child: StreamBuilder(
           stream: ServiceStream.inboxRealtime(widget.buddhistId),
           builder: (context, snapshot) {
             if (snapshot.hasData && snapshot.data.snapshot.value.runtimeType != String) {
               print(snapshot);


                 final snapshotResult = snapshot.data.snapshot as DataSnapshot;

                final Map<dynamic, dynamic> values = snapshotResult.value;

                final List<int> _read = [];
                final List<String> _messages = [];
                final List<String> _dateTime = [];
                final List<int> _sendBy = [];
                final List<String> _key =[];
                final List<String> dateList=[];
                if (values != null) {
                  values.forEach((key, item) {
                    _sendBy.add(item['send_by']);
                    _messages.add(item['message']);
                    _dateTime.add(item['time']);
                    _read.add(item['read']);
                    _key.add(key);

                    print(key);
                    print(_messages);
                    print(_read);
                  });


                } else {
                  print("br dai");
                }

               return

                 ListView.builder(

                 shrinkWrap: true,

                 controller: _scrollController,
                 padding: EdgeInsets.only(top: 10, bottom: 10),
                 itemCount: _messages.length,
                 itemBuilder: (context, index) {
                   final bool isMe = _sendBy[index] == Provider.of<UserViewModel>(context,listen:false).userId;
                   print("listView: ${_messages[index]}");
                   print(isMe);
                   ServiceStream.updateInboxReadRealtime(widget.buddhistId,_sendBy[index],_key[index],isMe);


                  var dateFormat= DateFormat('yyyy-dd-MM').format(DateTime.parse(_dateTime[index]));

                  var timeFormat = DateFormat('kk:mm').format(DateTime.parse(_dateTime[index]));



                   if(dateList.contains(dateFormat)){
                     datetimeCheck="";
                   }else{
                     dateList.add(dateFormat);
                     print("dateList: $dateList");
                     datetimeCheck="${dateFormat.toString()}";
                   }

                   return _messages.isNotEmpty
                       ? _chat(_messages[index],datetimeCheck,timeFormat,_read[index], isMe,index)
                       : Container();
                 },);
             }else {
              // return Center(child: CircularProgressIndicator());
               return Container();
             }
           }
         )

        ),



      _buildTextComposer(),

  ],

),

      ),
    );
  }
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(

        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey[100],
                width: 1.0,
              ),
            )
        ),
        child: Row(
crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _msgTextController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.grey[200],
                        filled: true,
                        hintText: "ປ້ອນຂໍ້ຄວາມ"),
                  ),
                )),
            Consumer<ArgumentComment>(
              builder: (context, value, child) =>
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    child: IconButton(

                      color: Color.fromRGBO(255, 196, 39, 1),

                      icon: Icon(Icons.send),
                      onPressed: () {
                        value.scrollControllerChat = _scrollController;
                        ServiceApi.postChat(context,widget.sendTo,widget.buddhistId,_msgTextController.text,);
                        _msgTextController.clear();
                        _scrollToEnd();
                      },
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _chat(String message,String date,String time,int read,bool isMe,int index){






   return  Column(
     children: [
       date == ""?Container(): Row(
         children: [
           Expanded(child: Container(margin: const EdgeInsets.only(left: 10.0, right: 15.0),child: Divider()),),
           Text("$date",style: TextStyle(color: Colors.grey,fontSize: 14),),
           Expanded(child: Container(margin: const EdgeInsets.only(left: 10.0, right: 15.0),child: Divider()),),
         ],
       ) ,
       Container(

          padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 0),
          child: Align(
            alignment: (isMe == false?Alignment.topLeft:Alignment.topRight),
            child: Container(
              constraints: BoxConstraints(
                maxWidth:  MediaQuery.of(context).size.width* 0.80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: (isMe == false ? Colors.white:Colors.yellow[600]),
              ),
              padding: EdgeInsets.all(16),
              child: Text(message, style: TextStyle(fontSize: 14),),
            ),
          ),
        ),
       Container(
           padding: EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 0),
           alignment: (isMe == false?Alignment.topLeft:Alignment.topRight),
           child: RichText(
             text:
             TextSpan(
               children: [
                 TextSpan(text:"$time",style: TextStyle(fontSize: 14,color: Colors.grey)),
                  WidgetSpan(child: SizedBox(width: 5,)),
                  isMe == false?WidgetSpan(child: Container()) :WidgetSpan(child: read ==0 ? Icon(Icons.check_circle_outline,color: Colors.grey,size: 16,):Icon(Icons.check_circle,color: Colors.lightBlueAccent,size: 16,)),

               ],
             )


    )),

     ],
   );
  }

  _callNumber(String phoneNumber) async{
    String number = '$phoneNumber'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
