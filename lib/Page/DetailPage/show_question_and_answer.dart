import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/argument_comment.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowQuestionAndAnswer extends StatefulWidget {
  @override
  _ShowQuestionAndAnswerState createState() => _ShowQuestionAndAnswerState();
}

class _ShowQuestionAndAnswerState extends State<ShowQuestionAndAnswer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArgumentComment>(
        builder: (context, value, child) {
          return InkWell(
            onTap: () {
              if( Provider.of<UserViewModel>(context,listen:false).isUser == false ){
                Navigator.pushNamed(context, "/loginpage");
              }else{
                value.setId(Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId);
                print(value.id);

                Navigator.pushNamed(context, '/content_detail',);
              }

            },
            child: Row(
              children: [
                Image.asset("asset/image/question_icon.png"),
                buildSizedBoxWidth(10),
                StreamBuilder(
                    stream:
                    ServiceStream.commentRealtime(Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final snapshotResult =
                        snapshot.data.snapshot as DataSnapshot;
                        // final Map<dynamic,
                        //     dynamic> values = snapshotResult.value;
                        final List<String> _commentCount = [];
                        print(snapshotResult);
                        if (snapshotResult.value != null) {
                          snapshotResult.value.forEach((key, item) {
                            _commentCount.add(item['message']);
                          });
                        } else {
                          print("comment count null");
                        }
                        return Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text('ຄໍາຖາມ ເເລະ ຄໍາຕອບ',style: TextStyle(color:Color.fromRGBO(159, 154, 168, 1)),),
                            Text(
                              '${_commentCount.length} ຄໍາຖາມ',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                buildSpacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey,
                ),
                //W20
                buildSizedBoxWidth(20),
              ],
            ),
          );
        });
  }

  Spacer buildSpacer() => Spacer();

  Divider buildDivider() => Divider();

  SizedBox buildSizedBoxWidth(double width) {
    return SizedBox(
      width: width,
    );
  }


}
