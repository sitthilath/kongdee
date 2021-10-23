import 'package:buddhistauction/Provider/switch_showbottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// Switch Button Sending//////////////////////////////////////////////////////////

enum SingingCharacter { way1, way2 }

class SelectChoiceSending extends StatefulWidget {

  final place;
  SelectChoiceSending({Key key,@required this.place}) : super(key: key);

  @override
  _SelectChoiceSendingState createState() => _SelectChoiceSendingState();
}

class _SelectChoiceSendingState extends State<SelectChoiceSending> {


  Widget build(BuildContext context) {
    return Consumer<SelectSendingProvider>(
        builder: (context, SelectSendingProvider notifiers, child) {
          if (notifiers.sending_byself == 0) {
            print("zoun");
          } else if (notifiers.sending_byself == 1) {
            print("nueng");
          }
          return Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      'ຂ້ອຍຈະຫາວິທີການຈັດສົ່ງກັບຄົນປ່ອຍ',
                      style: TextStyle(
                          fontFamily: 'boonhome',
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    Spacer(),
                    Radio(
                      value: 0,
                      groupValue: notifiers.sending_byself,
                      onChanged: (value) async {
                        notifiers.Jut_Sg_Eng();

                        print(notifiers.sending_byself);
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              // Container(
              //   child: Row(
              //     children: <Widget>[
              //       Text(
              //         'ຂ້ອຍຈະໄປເອົາເຄື່ອງຢູ່ ${widget.place}',
              //         style: TextStyle(
              //             fontFamily: 'boonhome',
              //             fontSize: 18,
              //             color: Colors.black),
              //       ),
              //       Spacer(),
              //       Radio(
              //         value: 1,
              //         groupValue: notifiers.sending_byself,
              //         onChanged: (value) async {
              //           notifiers.Khoi_Ja_Ao_Bai_Pai_Sg();
              //
              //           print(notifiers.sending_byself);
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Divider(),
            ],
          );
        });
  }
}


