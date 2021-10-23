import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
final currencyFormat = new NumberFormat("#,###", "en_US");

class ShowCurrentBidding extends StatefulWidget {
  final List<BuddhistDetailData> buddhistDetailList;

  const ShowCurrentBidding({Key key, this.buddhistDetailList}) : super(key: key);
  @override
  _ShowCurrentBiddingState createState() => _ShowCurrentBiddingState();
}

class _ShowCurrentBiddingState extends State<ShowCurrentBidding> {

  int childLength=0;
  var maxPrice;
  @override
  void initState() {

    SchedulerBinding.instance.addPostFrameCallback((_) {




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
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: ServiceStream.priceRealtime(widget.buddhistDetailList[0].id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final snapshotResult = snapshot.data.snapshot as DataSnapshot;
            final Map<dynamic, dynamic> values = snapshotResult.value;
            final List<int> _prices = [];
            values.forEach((key, item) {
              _prices.add(int.parse(item['price']));
            });
            maxPrice = _prices.reduce(math.max);

            print(values.length);
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (childLength == values.length) {
                print("value length is equal");
              } else if (childLength < values.length) {
                if (widget.buddhistDetailList[0].timeRemain <= 180 && widget.buddhistDetailList[0].timeRemain>0) {
                  print("Increase times 3min");
                  widget.buddhistDetailList[0].timeRemain += 60;
                } else {
                  print('Time is not Lower than');
                }
              } else {
                print("None");
              }
            });

            return Column(
              children: [
                Text(
                  '${currencyFormat.format(maxPrice) + " Kip"}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(82, 82, 82, 1),
                      fontSize: 30,
                      fontFamily: 'boonhome'),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
