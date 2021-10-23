

import 'package:buddhistauction/Service/service_api.dart';
import 'package:buddhistauction/Service/service_stream.dart';

import 'package:buddhistauction/Argument/commentID_argrument.dart';

import 'package:buddhistauction/Comment/utils.dart';


import 'package:buddhistauction/Provider/argument_comment.dart';


import 'package:firebase_database/firebase_database.dart';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';



import 'package:provider/provider.dart';

import 'package:readmore/readmore.dart';

class ContentDetail extends StatefulWidget {
  @override
  _ContentDetailState createState() => _ContentDetailState();
}

class _ContentDetailState extends State<ContentDetail> {
  final TextEditingController _msgTextController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  _scrollToEnd() async{
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void initState() {
    print("first");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(

          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
            title: Text(
              'ຖາມຕອບ',
              style: TextStyle(
                color: Colors.black,
                  fontFamily: 'boonhome',
                  fontWeight: FontWeight.bold,
                  ),
            ),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(255, 196, 39, 1),
          ),
          body: Consumer<ArgumentComment>(
            builder: (context, value, child) =>
             StreamBuilder(
                stream: ServiceStream.orderComment(value.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final snapshotResult = snapshot.data.snapshot as DataSnapshot ;
                    final Map<dynamic, dynamic> values = snapshotResult.value;

                    final List<String> _messages = [];
                    final List<String> _dateTime = [];
                    final List<String> _name = [];
                    final List<int> _commentID = [];
                    final List<String> _picture = [];
                    final List<String> _key = [];

                    if (values != null) {
                      values.forEach((key, item) {
                        _key.add(key);

                        _messages.add(item['message']);
                        _dateTime.add(item['datetime']);
                        _name.add(item['name']);
                        _commentID.add(item['comment_id']);
                        _picture.add(item['picture']);

                        print(_messages);
                      });
                    } else {
                      print("br dai");
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              controller: _scrollController,
                              children: [
                                Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    _messages != null
                                        ? CommentList(
                                      idBuddhist: value.id,
                                      name: _name,
                                      dateTime: _dateTime,
                                      message: _messages,
                                      picture: _picture,
                                      scrollController:_scrollController,
                                      keys: _key,
                                    )
                                        : null,
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _buildTextComposer(),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          )),
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
                    value.scrollController = _scrollController;
                    ServiceApi.postComment(_msgTextController.text, value.id,context);
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


}

class RepliesCount extends StatefulWidget {
  final String keys;
  final int idBuddhist;

  RepliesCount({Key key, @required this.keys, @required this.idBuddhist})
      : super(key: key);

  @override
  _RepliesCountState createState() => _RepliesCountState();
}

class _RepliesCountState extends State<RepliesCount> {
  Stream<Event> repliesRealtime() {
    DatabaseReference _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Comments')
        .child('${widget.idBuddhist}')
        .child('${widget.keys}')
        .child('replies');
    return _databaseReference.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: repliesRealtime(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snapshotResult = snapshot.data.snapshot as DataSnapshot;
            final List<String> _repliesCount = [];
            if (snapshotResult.value == "") {
            } else {
              final Map<dynamic, dynamic> values = snapshotResult.value;

              print("Value.length = ${values.length}");
              print("Value.mess = ${values.values.toString()}");
              if (values != null) {
                values.forEach((key, item) {
                  if (item['message'] == "") {
                  } else {
                    _repliesCount.add(item['message']);
                  }
                });
              } else {
                print("replies br dai ");
              }
            }
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/listreplies",
                        arguments: CommentIDArgrument(
                            idBud: widget.idBuddhist, keys: widget.keys));
                  },
                  child: _repliesCount != null && _repliesCount.length >= 1
                      ? Text(
                          "ຕອບກັບ (${_repliesCount.length})",
                          style: TextStyle(
                              fontFamily: 'boonhome',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        )
                      : Text(
                          "ຕອບກັບ (0)",
                          style: TextStyle(
                              fontFamily: 'boonhome',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                ),
              ],
            );
          } else {
            print("test");
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class CommentList extends StatefulWidget {
  final List<String> picture;
  final List<String> name;
  final List<String> message;
  final List<String> dateTime;
  final List<String> keys;
  final int idBuddhist;
  final ScrollController scrollController;


  const CommentList(
      {Key key,
      @required this.picture,
      @required this.idBuddhist,
      @required this.name,
      @required this.message,
      @required this.dateTime,
      @required this.scrollController,
      @required this.keys,

    })
      : super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {




  @override
  void initState() {
    print("second");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(

      shrinkWrap: true,
      primary: false,
      physics: ClampingScrollPhysics(),
      itemCount: widget.message.length,
      itemBuilder: (context, index) {
        return widget.message.length > 0
            ? Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
                child: Container(
                  width: 48,
                  height: 48,
                  child: CircleAvatar(
                    backgroundImage:
                    NetworkImage("${widget.picture[index]}"),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.name[index],
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ReadMoreText(

                            widget.message[index],
                            trimLines: 2,
                            colorClickableText: Colors.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'ເພີ່ມເຕີມ',
                            trimExpandedText: 'ຫຍໍ້',
                            style: TextStyle(

                                color: Colors.black ,
                                fontSize: 16,
                               ),
                            lessStyle: TextStyle(

                                color: Colors.blue[800] ,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            moreStyle: TextStyle(

                                color: Colors.blue[800] ,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Container(
                      width: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(Utils.readTimestamp(
                              DateTime
                                  .parse(widget.dateTime[index])
                                  .millisecondsSinceEpoch)),
                          //RepliesCount(keys: widget.keys[index],idBuddhist: widget.idBuddhist,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
            : Container();
      },
    );
  }



}
