import 'dart:convert';
import 'dart:io';

import '../../Provider/StoreData/store_release_buddhist.dart';
import '../../Provider/StoreData/store_token.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:buddhistauction/const_api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {


  int _value,_value2;
  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pop(context,true);

              }
          ),
          backgroundColor: Color.fromRGBO(255, 196, 39, 1),
          centerTitle: true,
          title: Text("ປ່ອຍເຄື່ອງ",
              style: TextStyle(
                color:Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'boonhome'))),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ເລືອກຂັ້ນຕອນການຈັດສົ່ງ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
                Row(
                  children: [
                    Consumer<StoreReleaseBuddhistProvider>(
                        builder: (context, srb, child) {
                      if (_value != srb.indexDelivery) {
                        // Or check if appState.username != null or what ever your use case is.
                        _value = srb.indexDelivery ?? '';
                      }
                      return ChoiceChip(
                        backgroundColor: Color.fromARGB(255, 253, 200, 200),
                        selectedColor: Color.fromRGBO(255, 196, 39, 1),
                        labelStyle: _value == 1
                            ? TextStyle(color: Colors.black)
                            : TextStyle(color: Colors.black),
                        label: Text('ຈັດເເຈງກັບຜູ້ຂາຍ'),
                        selected: _value == 1,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? 1 : null;
                            srb.setDelivery('ຈັດເເຈງກັບຜູ້ຂາຍ', 1);
                          });
                        },
                        //  selectedColor: isSelected ? Colors.black : Colors.white
                      );
                    }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                Text("ຊ່ອງທາງຊຳລ່ະເງິນ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
                Row(
                  children: [
                    Consumer<StoreReleaseBuddhistProvider>(
                        builder: (context, srb, child) {
                          if (_value2 != srb.indexPayThrough) {
                            // Or check if appState.username != null or what ever your use case is.
                            _value2 = srb.indexPayThrough ?? '';
                          }
                          return ChoiceChip(
                            backgroundColor: Color.fromARGB(255, 253, 200, 200),
                            selectedColor: Color.fromRGBO(255, 196, 39, 1),
                            labelStyle: _value2 == 1
                                ? TextStyle(color: Colors.black)
                                : TextStyle(color: Colors.black),
                            label: Text('ຈັດເເຈງກັບຜູ້ຂາຍ'),
                            selected: _value2 == 1,
                            onSelected: (bool selected) {
                              setState(() {
                                _value2 = selected ? 1 : null;
                                srb.setPayThrough('ຈັດເເຈງກັບຜູ້ຂາຍ', 1);
                              });
                            },
                            //  selectedColor: isSelected ? Colors.black : Colors.white
                          );
                        }),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                submitButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 80.0,
          child: numberPage(),
        ),
      ),
    );
  }

  Widget numberPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("1",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ລົງຮູບ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 253, 200, 200),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("2",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ຂໍ້ມູນ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 253, 200, 200),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("3",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ລາຄາ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 253, 200, 200),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                  child: Text("4",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ຈັດສົ່ງ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'boonhome')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget submitButton() {
    return Container(
      width: double.maxFinite,
      height: 40,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(255, 196, 39, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'ສຳເລັດ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          if (_key.currentState.validate()) {
            _key.currentState.save();

            String delivery = Provider.of<StoreReleaseBuddhistProvider>(context,
                    listen: false)
                .delivery;
            String payThrough = Provider.of<StoreReleaseBuddhistProvider>(context,
                listen: false)
                .payThrough;

            if (delivery == null || delivery == "") {
              Fluttertoast.showToast(
                  msg: "ກະລຸນາເລືອກຂັ້ນຕອນການຈັດສົ່ງ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if(payThrough == null || payThrough == ""){
              Fluttertoast.showToast(
                  msg: "ກະລຸນາເລືອກຊ່ອງທາງຊຳລ່ະເງິນ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
              else {
              if (mounted) {
                List<File> buddhistListImage =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                            listen: false)
                        .listImage;

                String buddhistType = Provider.of<StoreReleaseBuddhistProvider>(
                        context,
                        listen: false)
                    .itemType;
                // String payChoice = Provider.of<StoreReleaseBuddhistProvider>(
                //         context,
                //         listen: false)
                //     .payThrough;
                // print("payThrough $payChoice");
                // String sendingChoice =
                //     Provider.of<StoreReleaseBuddhistProvider>(context,
                //             listen: false)
                //         .delivery;
                // print("delivery $sendingChoice");

                String place = Provider.of<StoreReleaseBuddhistProvider>(
                        context,
                        listen: false)
                    .place;

                String buddhistDateEnd =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                                listen: false)
                            .datetimeAuction +
                        ":00";

                TextEditingController ctrlItemName =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                            listen: false)
                        .ctrlItemName;
                TextEditingController ctrlItemCondition =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                            listen: false)
                        .ctrlItemCondition;
                print(ctrlItemCondition.text);

                TextEditingController ctrlPriceStart =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                            listen: false)
                        .ctrlPriceStart;
                TextEditingController ctrlPriceSmallest =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                            listen: false)
                        .ctrlPriceSmallest;
                TextEditingController ctrlInformation =
                    Provider.of<StoreReleaseBuddhistProvider>(context,
                            listen: false)
                        .ctrlInformation;

                _uploadBuddhist(
                  ctrlItemName,
                  ctrlInformation,
                  buddhistDateEnd,
                  ctrlPriceStart,
                  ctrlPriceSmallest,
                  buddhistListImage,
                  buddhistType,
                  place,
                  ctrlItemCondition,
                );
              }
            }
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _uploadBuddhist(
    TextEditingController ctrlItemName,
    TextEditingController ctrlInformation,
    String endDatetime,
    TextEditingController ctrlPriceStart,
    TextEditingController ctrlPriceSmallest,
    List<File> image,
    String type,
    String place,
    TextEditingController ctrlItemCondition,
  ) async {

    ServiceAlert.alertLoading(context);

    String token = await StoreTokenProvider().getToken();
    String fcmToken =  Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;

    final headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.acceptHeader: "application/json"
    };

    Uri apiUrl = Uri.parse("$API_URL/buddhist");
    // Intilize the multipart request
    final buddhistUploadRequest = http.MultipartRequest('POST', apiUrl);
    print(image.length);

    for (int i = 0; i < image.length; i++) {
      final file = await http.MultipartFile.fromPath('images[]', image[i].path);
      buddhistUploadRequest.files.add(file);
    }

    buddhistUploadRequest.headers.addAll(headers);

    buddhistUploadRequest.fields['name'] = ctrlItemName.text;
    buddhistUploadRequest.fields['detail'] = ctrlInformation.text;
    buddhistUploadRequest.fields['end_datetime'] = endDatetime;
    buddhistUploadRequest.fields['price'] =
        ctrlPriceStart.text.replaceAll(',', '');
    buddhistUploadRequest.fields['price_smallest'] =
        ctrlPriceSmallest.text.replaceAll(',', '');
    buddhistUploadRequest.fields['type_id'] = type;
    buddhistUploadRequest.fields['place'] = place;
    buddhistUploadRequest.fields['status'] = ctrlItemCondition.text;
    buddhistUploadRequest.fields['fcm_token'] = fcmToken;
    try {
      final streamedResponse = await buddhistUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode == 201){
        _resetState();
        final Map<String, dynamic> responseData = json.decode(response.body);

        ServiceAlert.alertSuccess(context,'release');

        return responseData;
      }
      else if (response.statusCode == 422) {
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body}');
        _resetState();
          ServiceAlert.alertError(context, "ເວລາປ່ອຍຕໍ່າກ່ອນປັດຈຸບັນ");
        return null;
      }else if(response.statusCode != 201){
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body}');

        _resetState();
        ServiceAlert.alertError(context, "ກວດສອບຂໍ້ມູນທີ່ປ້ອນຄືນ");
        return null;
      }else{
        print('Response status : ${response.statusCode}');
        print('Response status : ${response.body}');

        _resetState();
        ServiceAlert.alertError(context, "ກະລຸນາລອງອີກຄັ້ງ");
        return null;

      }

    } catch (e) {
      print(e);
      ServiceAlert.alertError(context, "ເກີດຂໍ້ຜິດພາດກະລຸນາລອງອີກຄັ້ງ");

      return null;
    }
  }



  void _resetState() {

      Navigator.pop(context);

    if (mounted) {


      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setListImageClear();
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setImageBig(null);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setImageSmall1(null);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setImageSmall2(null);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setImageSmall3(null);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setImageSmall4(null);

      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setItemName('');
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setItemCondition('');
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setItemType('',-1);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setTimeAuction("");
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setDateAuction("");
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setDateTimeAuction("");
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setPriceStart('');
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setPriceSmallest('');
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setInformation('');
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setPayThrough('',-1);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .setDelivery('',-1);
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlItemName
          .clear();

      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlItemCondition
          .clear();

      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlPriceStart
          .clear();
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlPriceSmallest
          .clear();
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlInformation
          .clear();

      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlDateAuction
          .clear();
      Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
          .ctrlTimeAuction
          .clear();
    }
  }


}
