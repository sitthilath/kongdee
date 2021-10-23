import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuctionCloseDate extends StatefulWidget {

  final List<BuddhistDetailData> buddhistDetailList;

  const AuctionCloseDate({Key key, this.buddhistDetailList}) : super(key: key);
  @override
  _AuctionCloseDateState createState() => _AuctionCloseDateState();
}

class _AuctionCloseDateState extends State<AuctionCloseDate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'ປິດປະມູນ:',
              style: TextStyle(
                color:Color.fromRGBO(159, 154, 168, 1),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 2,

            child:  Text(
              'ວັນທີ ${widget.buddhistDetailList[0].endTime.day} ເດືອນ ${widget.buddhistDetailList[0].endTime.month} ເວລາ ${widget.buddhistDetailList[0].endTime.hour} : ${widget.buddhistDetailList[0].endTime.minute == 0 ? '00' : widget.buddhistDetailList[0].endTime.minute}ນາທີ ມີ ${00 + widget.buddhistDetailList[0].favoriteCount} ຄົນທີ່ຕິດຕາມສິນຄ້າ',
              style: TextStyle(
                color:Color.fromRGBO(159, 154, 168, 1),
                fontWeight: FontWeight.normal,
              ),
            ),

          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    child: StreamBuilder(
                      stream: ServiceStream.priceRealtime(widget.buddhistDetailList[0].id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          final snapshotResult =
                          snapshot.data.snapshot as DataSnapshot;
                          final Map<dynamic, dynamic> values =
                              snapshotResult.value;
                          final List<String> _users = [];

                          values.forEach((key, item) {

                              _users.add(item['uid']);
                              print(_users.toList());

                          });

                          return GestureDetector(
                            onTap: ()=> Navigator.pushNamed(context, "/bidder_list"),
                            child: Column(
                              children: [
                                Text(
                                  '${_users.length - 1}' + ' ຄົນປະມູນ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(184, 133, 13, 1),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: Color.fromRGBO(184, 133, 13, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
