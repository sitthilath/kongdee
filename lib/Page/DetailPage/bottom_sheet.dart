

import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Page/PartOfDetail/autopamoon.dart';
import 'package:buddhistauction/Page/PartOfDetail/switch_button_sending.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/switch_showbottom.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:buddhistauction/Service/service_stream.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
final currencyFormat = new NumberFormat("#,###", "en_US");

class BottomSheetItem extends StatefulWidget {
  final List<BuddhistDetailData> buddhistDetailList;

  const BottomSheetItem({Key key, this.buddhistDetailList}) : super(key: key);
  @override
  _BottomSheetItemState createState() => _BottomSheetItemState();
}

class _BottomSheetItemState extends State<BottomSheetItem> {
  final priceController = TextEditingController();


  var maxPrice;
  bool checkAdded = false;


  @override
  void initState() {
    super.initState();
    if (mounted) {
      priceController.addListener(() {
        final regEX = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        final matchFunc = (Match match) => '${match[1]},';
        final text = priceController.text;

        priceController.value = priceController.value.copyWith(
          text: text.replaceAll(',', '').replaceAllMapped(regEX, matchFunc),
          selection: TextSelection(
            baseOffset: text.length,
            extentOffset: text.length,
          ),
        );
      });


    }

    SchedulerBinding.instance.addPostFrameCallback((_) {

      Provider.of<AutoAuctionProvider>(context,listen:false).setPriceController(priceController);
    }
    );
  }

  @override
  void dispose() {

    priceController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0))),
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<BuddhistDetailViewModel>(
              builder: (context, viewModel, child) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'ຍົກເລີກ',
                          style: TextStyle(
                              fontFamily: 'boonhome',
                              color: Color.fromRGBO(184, 133, 13, 1),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'ລາຍການປະມູນ',
                        style: TextStyle(
                            fontFamily: 'boonhome',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Consumer<AutoAuctionProvider>(
                        builder: (context, aap, child) => TextButton(
                          child: Text(
                            'ປະມູນ',
                            style: TextStyle(
                                fontFamily: 'boonhome',
                                fontSize: 20.0,
                                color:Color.fromRGBO(184, 133, 13, 1),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            String price;
                            if (aap.autoAuction == true) {
                              price =
                              "${widget.buddhistDetailList[0].priceSmallest}";
                            } else {
                              price = priceController.text.replaceAll(',', '');
                            }

                            print(price);
                            if (price == "" || price == null) {
                              Fluttertoast.showToast(
                                  msg: "ກະລຸນາປ້ອນລາຄາປະມູນ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (int.parse(price) <
                                widget.buddhistDetailList[0].priceSmallest) {
                              Fluttertoast.showToast(
                                  msg: "ລາຄາທີ່ປະມູນຕໍ່າເກີນໄປ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {

                              ServiceAlert.openDialogBidding(context, price, maxPrice,widget.buddhistDetailList[0].id,widget.buddhistDetailList[0].timeRemain,checkAdded);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
            ),
            buildDivider(),
            //H10
            buildSizedBoxHeight(10),
            Consumer<BuddhistDetailViewModel>(
              builder: (context, viewModel, child) =>
                  Center(
                    child: Text(
                      widget.buddhistDetailList[0].name,
                      style: TextStyle(
                        color: Color.fromARGB(255, 23, 23, 23),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'boonhome',
                      ),
                    ),
                  ),
            ),
            //H10
            buildSizedBoxHeight(10),
            Container(
              child: Text(
                'ປະມູນ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'boonhome',
                ),
              ),
            ),
            //H10
            buildSizedBoxHeight(10),
            Text(
              'ສ່ອງທາງການຈ່າຍເງີນ:ເງີນສົດ,ເງີນໂອນ,Bcel one ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: 'boonhome',
              ),
            ),
            //H10
            buildSizedBoxHeight(10),
            buildDivider(),
            //H10
            buildSizedBoxHeight(10),

            Row(
              children: [
                Text(
                  'ລາຄາສະເໜີດຽວນີ້ ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'boonhome',
                  ),
                ),
                buildSpacer(),
                Consumer<BuddhistDetailViewModel>(
                  builder: (context, viewModel, child) =>
                      StreamBuilder(
                        stream: ServiceStream.priceRealtime(viewModel.buddhistId),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            final snapshotResult =
                            snapshot.data.snapshot as DataSnapshot;
                            final Map<dynamic, dynamic> values = snapshotResult.value;
                            final List<int> _prices = [];
                            values.forEach((key, item) {
                              _prices.add(int.parse(item['price']));
                            });
                            maxPrice = _prices.reduce(math.max);





                            return Column(
                              children: [
                                Text(
                                  '${currencyFormat.format(maxPrice) + " Kip"}',
                                  style: TextStyle(
                                      fontFamily: 'boonhome',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 134, 139, 128)),
                                ),
                              ],
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
                  Icons.outlined_flag,
                  color: Colors.orange,
                )
              ],
            ),
            //H10
            buildSizedBoxHeight(10),
            buildDivider(),
            AutoPaMoon(),
            buildDivider(),
            Row(children: [
              Text(
                'ເຄາະຂັ້ນຕໍ່າ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'boonhome',
                ),
              ),
              buildSpacer(),
              Consumer<BuddhistDetailViewModel>(
                builder: (context, viewModel, child) =>
                    Text(
                        ' ${currencyFormat.format(widget.buddhistDetailList[0].priceSmallest) + " Kip"}',
                        style: TextStyle(
                            fontFamily: 'boonhome',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 134, 139, 128))),
              ),
            ]),
            buildDivider(),
            Container(
              child: Consumer<AutoAuctionProvider>(
                  builder: (context, aap, child) {

                    return Consumer<BuddhistDetailViewModel>(
                      builder: (context, viewModel, child) =>
                          TextField(
                            enabled: aap.autoAuction == true ? false : true,
                            onChanged: (val) {

                              if(  aap.autoAuction == true  ){

                                val = "${widget.buddhistDetailList[0].priceSmallest}";
                              }else{
                                val = val;
                              }


                            },

                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            controller: priceController,
                            decoration: InputDecoration(
                                hintText: aap.autoAuction == true
                                    ? "${NumberFormat('#,###,000').format(widget.buddhistDetailList[0].priceSmallest)}"
                                    : 'ລາຄາປະມູນທີ່ເຈົ້າໃສ່'),
                            keyboardType: TextInputType.number,
                          ),
                    );
                  }
              ),
            ),
            buildDivider(),
            Container(
              child: Text(
                'ເລືອກວິທີການຈັດສົ່ງ',
                style: TextStyle(
                    fontFamily: 'boonhome',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
            Consumer<BuddhistDetailViewModel>(
              builder: (context, viewModel, child) =>
                  SelectChoiceSending(
                    place: widget.buddhistDetailList[0].place,
                  ),
            ),


            Consumer<AutoAuctionProvider>(
              builder: (context, aap, child) => Container(
                height: 53.0,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.13,
                  width: double.maxFinite,
                  child: Consumer<BuddhistDetailViewModel>(
                    builder: (context, viewModel, child) =>
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            String price;
                            if (aap.autoAuction == true) {
                              price =
                              "${widget.buddhistDetailList[0].priceSmallest}";
                            } else {
                              price = priceController.text.replaceAll(',', '');
                            }

                            print(price);
                            if (price == "" || price == null) {
                              Fluttertoast.showToast(
                                  msg: "ກະລຸນາປ້ອນລາຄາປະມູນ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (int.parse(price) <
                                widget.buddhistDetailList[0].priceSmallest) {
                              Fluttertoast.showToast(
                                  msg: "ລາຄາທີ່ປະມູນຕໍ່າເກີນໄປ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              ServiceAlert.openDialogBidding(context, price, maxPrice,widget.buddhistDetailList[0].id,widget.buddhistDetailList[0].timeRemain,checkAdded);
                            }
                          },
                          child: Text(
                            'ປະມູນ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28.0,
                                fontFamily: 'lao',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }

  Spacer buildSpacer() => Spacer();

  Divider buildDivider() => Divider();
}

