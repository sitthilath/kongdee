import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Page/DetailPage/bottom_sheet.dart';
import 'package:buddhistauction/Provider/countdown.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonShowModalBottomSheet extends StatefulWidget {
  final List<BuddhistDetailData> buddhistDetailList;

  const ButtonShowModalBottomSheet({Key key, this.buddhistDetailList}) : super(key: key);
  @override
  _ButtonShowModalBottomSheetState createState() => _ButtonShowModalBottomSheetState();
}

class _ButtonShowModalBottomSheetState extends State<ButtonShowModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CountDownProvider>(
        builder: (context, value, child) =>
        value.isTimesUp == true
            ? Container()
            : Container(
          height: MediaQuery.of(context).size.width *
              0.15,
          width: double.maxFinite,
          child: Consumer<UserViewModel>(
            builder: (context, userViewModel, child) =>
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                    Color.fromRGBO(255, 196, 39, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed:
                      () {
                    userViewModel.isUser == false ?
                    Navigator.pushNamed(context, "/loginpage")
                        :
                    //_showModalBottomSheet(context);
                    /// ShowModalBottomSheet----------------------------------------------------------------------
                    showModalBottomSheet<void>(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheetItem(buddhistDetailList: widget.buddhistDetailList,);
                      },
                    );

                    /// ShowModalBottomSheet----------------------------------------------------------------------
                  },
                  child: FittedBox(
                    child: Text(
                      'ປະມູນ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
