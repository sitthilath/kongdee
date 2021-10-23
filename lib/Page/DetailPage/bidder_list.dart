import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/argument_owner.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
final currencyFormat = new NumberFormat("#,###", "en_US");

class BidderList extends StatefulWidget {
  @override
  _BidderListState createState() => _BidderListState();
}

class _BidderListState extends State<BidderList> {

  ScrollController _scrollController = new ScrollController();
  
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
        title: Text("ຈຳນວນຄົນປະມູນ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
      ),
      body: Consumer<BuddhistDetailViewModel>(
        builder: (context, value, child) =>
            StreamBuilder(
                stream: ServiceStream.bidder(value.buddhistId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final snapshotResult = snapshot.data.snapshot as DataSnapshot ;
                    final Map<dynamic, dynamic> values = snapshotResult.value;

                    final List<int> _bidderId = [];
                    final List<String> _name = [];
                    final List<String> _surname = [];
                    final List<String> _picture = [];
                    final List<String> _price = [];
                    final List<String> _key = [];

                    if (values != null) {
                      values.forEach((key, item) {



                          _key.add(key);

                          _bidderId.add(item['id']);
                          _name.add(item['name']);
                          _surname.add(item['surname']);
                          _picture.add(item['picture']);
                          _price.add(item['price']);
                          print(_bidderId);


                      });

                      _bidderId.removeAt(0);
                      _name.removeAt(0);
                      _surname.removeAt(0);
                      _picture.removeAt(0);
                      _price.removeAt(0);
                    } else {
                      print("br dai");
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,

                              child: Column(
                                children: <Widget>[

                                  _bidderId != null
                                      ? PeopleList(
                                    bidderId: _bidderId,
                                    name: _name,
                                    surname: _surname,
                                    picture: _picture,
                                    price: _price,
                                    keys: _key,
                                  )
                                      : null,
                                ],
                              ),
                            ),
                          ),
                     
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
      )
    );
  }
}

class PeopleList extends StatefulWidget {
  final List<String> keys;
  final List<int> bidderId;
  final List<String> name;
  final List<String> surname;
  final List<String> picture;
  final List<String> price;




  const PeopleList(
      {Key key,
        @required this.keys,
        @required this.bidderId,
        @required this.name,
        @required this.surname,
        @required this.picture,
        @required this.price,
      })
      : super(key: key);

  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {




  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(color: Colors.grey),
      shrinkWrap: true,
      primary: false,
      itemCount: widget.bidderId.length,
      itemBuilder: (context, index) {
        return widget.bidderId.length > 0
            ? GestureDetector(
          onTap: (){
            Provider.of<ArgumentOwner>(context,listen:false).ownerId = widget.bidderId[index];
            Navigator.pushNamed(context, "/profile_owner",);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(

              child: ListTile(

                leading: CircleAvatar(radius: 30,backgroundImage: NetworkImage("${widget.picture[index]}"),),
                title: Align(alignment: Alignment.centerLeft,child: FittedBox(child: Text("${widget.name[index]} ${widget.surname[index]}",style: TextStyle(fontSize: 20),))),
                subtitle: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Align(alignment: Alignment.centerLeft,child: FittedBox(child: Text("ເຄາະ ${currencyFormat.format(int.parse(widget.price[index]))} Kip",style: TextStyle(fontSize: 20),))),
                ),
                trailing: Icon(Icons.arrow_forward_ios,size: 14,),
              ),
            ),
          ),
        )
            : Container();
      },
    );
  }



}
