
import 'package:buddhistauction/Argument/commentID_argrument.dart';
import 'package:buddhistauction/Comment/utils.dart';
import 'package:provider/provider.dart';
import '../Provider/StoreData/store_token.dart';
import 'package:buddhistauction/const_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListReplies extends StatefulWidget {

  @override
  _ListRepliesState createState() => _ListRepliesState();
}

class _ListRepliesState extends State<ListReplies> {

  final TextEditingController _msgTextController = new TextEditingController();



  Stream<Event> repliesRealtime(int idBud,String key) {
    DatabaseReference _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('Comments')
        .child('${idBud.toString()}')
        .child('$key}')
    .child('replies');
    return _databaseReference.onValue;
  }

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final CommentIDArgrument args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text("ຕອບກັບ"),),
      body: StreamBuilder(
        stream: repliesRealtime(args.idBud,args.keys),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snapshotResult = snapshot.data
                .snapshot as DataSnapshot;
            final List<String> _message = [];
            final List<String> _dateTime = [];
            final List<String> _name = [];

            if(snapshotResult.value == "" || snapshotResult.value == null){

            }else{
              final Map<dynamic, dynamic> values = snapshotResult
                  .value;
              //debugPrint("MAP = +${values}");


              values.forEach((key, item) {
                _message.add(item['message']);
                _dateTime.add(item['datetime']);
                _name.add(item['name']);

              });
            }

              return Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Column(

                  children: [
                    Expanded(child:
                snapshotResult.value == "" ? Container() :

                RepliesList(name: _name,message: _message,dateTime: _dateTime, commentID: null,)),
                    _buildTextComposer(args.idBud,args.keys),
                  ],
                ),
              );
          } else {
            return CircularProgressIndicator();
          }

        }
      ),
    );
  }


  Widget _buildTextComposer(int idBud,String key) {
    return new IconTheme(
      data: new IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: new Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
                child: TextField(
                  maxLines: 2,
                  controller: _msgTextController,

                  decoration: InputDecoration.collapsed(
                      hintText: "Write a message"),
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  setState(() {});
                  _handleSubmitted(_msgTextController.text,idBud,key);
                  _msgTextController.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _handleSubmitted( String message,int idBud,String key ) async {
      String token = await StoreTokenProvider().getToken();
      String fcmToken =  Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;

      var url = Uri.parse("$API_URL/buddhist/${idBud.toString()}/comment/$key}/reply");
     await http.post(url,
          headers: {
            'Accept': 'application/json; charset=UTF-8',
            'Authorization' : 'Bearer '+token,
          },
          body:{
            'message': message,
            'fcm_token': fcmToken,

          })
          .then((response) {
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body}');


        if(response.statusCode == 200){

          print("OK");

        }else{
          print("error E Y WA");
        }

      }).catchError((e) {
        print("Error: $e");
      });
    }

}


class RepliesList extends StatefulWidget {
  final List<String> name;
  final List<String> message;
  final List<String> dateTime;
  final List<int> commentID;
  const RepliesList({Key key,@required this.name,@required this.message,@required this.dateTime,@required this.commentID}): super(key:key);

  @override
  _RepliesListState createState() => _RepliesListState();
}

class _RepliesListState extends State<RepliesList> {
  @override
  Widget build(BuildContext context) {
    return
      ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.message.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
                child: Container(
                  width: 48,
                  height: 48,

                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlYq-pm0D3lvOwp8fldTae-fCi2lU3fy7AUQ&usqp=CAU"),
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
                          Text(widget.name[index]),
                          Text(
                            widget.message[index] ,
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Container(
                      width: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(Utils.readTimestamp(DateTime
                              .parse(widget.dateTime[index])
                              .millisecondsSinceEpoch)),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },


      );
  }


}