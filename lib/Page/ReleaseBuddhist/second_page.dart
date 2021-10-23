import 'package:buddhistauction/Page/ReleaseBuddhist/third_page.dart';
import '../../Provider/StoreData/store_release_buddhist.dart';

import 'package:buddhistauction/TransitionPageRoute/slide_left_right.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var _key = GlobalKey<FormState>();
  String dropdownValue;
  String dateAuction, timeAuction;

  TextEditingController _info = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _time = new TextEditingController();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();



    var newDate = new DateTime(now.year, now.month + 3, now.day);


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
        title: Text(
          "ປ່ອຍເຄື່ອງ",
          style: TextStyle(
            color:Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'boonhome'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ຂໍ້ມູນ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'boonhome'),
                ),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(builder: (context, srb, child) {
                  if (_info.text != srb.information) {
                    // Or check if appState.username != null or what ever your use case is.
                    _info.text = srb.information ?? '';
                  }
                  return TextFormField(
                    controller: _info,
                    onChanged: (value) {
                      srb.setInformation(value);
                      srb.setCtrlInformation(_info);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                      }

                      return null;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ປະມູນຮອດມື້",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'boonhome'),
                ),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(
                  builder: (context, srb, child) {
                    if (_date.text != srb.dateAuction) {
                      // Or check if appState.username != null or what ever your use case is.
                      _date.text = srb.dateAuction ?? '';
                    }
                    return DateTimePicker(
                      controller: _date,
                      locale: const Locale('lo', 'LA'),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      // initialValue: DateTime.now().toString(),
                      firstDate: DateTime.now(),
                      lastDate: newDate,
                      dateLabelText: 'Date',
                      onChanged: (val) {
                        setState(() {
                          dateAuction = val;
                          srb.setDateAuction(val);
                          srb.setCtrlDateAuction(_date);
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'ກະລຸນາເລືອກວັນທີ';
                        }
                        return null;
                      },
                    );

                  }),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ເວລາ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'boonhome'),
                ),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(
                  builder: (context, srb, child) {
                    if (_time.text != srb.timeAuction) {
                      // Or check if appState.username != null or what ever your use case is.
                      _time.text = srb.timeAuction ?? '';
                    }
                    return DateTimePicker(
                      controller: _time,
                      use24HourFormat: true,
                      locale: const Locale('lo', 'LA'),
                      // initialValue:formattedDate,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),

                      type: DateTimePickerType.time,
                      dateLabelText: 'Time',
                      onChanged: (val) {
                        setState(() {
                          timeAuction = val;
                          srb.setTimeAuction(val);
                          srb.setCtrlTimeAuction(_time);
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'ກະລຸນາເລືອກເວລາ';
                        }
                        return null;
                      },
                    );
                  }),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ສະຖານທີ່",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'boonhome'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        style: BorderStyle.solid,
                        width: 0.80,
                        color: Colors.grey),
                  ),
                  child: Consumer<StoreReleaseBuddhistProvider>(
                    builder: (context, srb, child) {
                      if (dropdownValue != srb.place) {
                        // Or check if appState.username != null or what ever your use case is.
                        dropdownValue = srb.place ?? '';
                      }
                     return DropdownButtonFormField<String>(

                        decoration:
                        InputDecoration(enabledBorder: InputBorder.none),
                        isExpanded: true,
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            srb.setPlace(newValue);
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            Fluttertoast.showToast(
                                msg: "ກະລຸນາເລືອກສະຖານທີ່",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          return null;
                        },
                        items: <String>[
                          'ນະຄອນຫຼວງວຽງຈັນ',
                          'ຜົ້ງສາລີ',
                          'ຫຼວງນ້ຳທາ',
                          'ອຸດົມໄຊ',
                          'ບໍ່ແກ້ວ',
                          'ຫຼວງພະບາງ',
                          'ຫົວພັນ',
                          'ໄຊຍະບູລີ',
                          'ຊຽງຂວາງ',
                          'ວຽງຈັນ',
                          'ບໍລິຄຳໄຊ',
                          'ຄຳມ່ວນ',
                          'ສະຫວັນນະເຂດ',
                          'ສາລະວັນ',
                          'ເຊກອງ',
                          'ຈຳປາສັກ',
                          'ອັດຕະປື',
                          'ໄຊສົມບູນ'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      );

                    }),
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
                  backgroundColor: Color.fromRGBO(255, 196, 39, 1),
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
                        color: Colors.black,
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
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
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
                        color: Color.fromARGB(255, 253, 200, 200),
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
          'ຕໍ່ໄປ',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_key.currentState.validate()) {
            _key.currentState.save();

            // Navigator.pushNamed(context, "/third_page");
            Provider.of<StoreReleaseBuddhistProvider>(context, listen: false)
                .setDateTimeAuction(_date.text + " " + _time.text);
            Navigator.push(context, SlideRightRoute(page: ThirdPage()));
          } else {
            Fluttertoast.showToast(
                msg: "ປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0); }
        },
      ),
    );
  }
}
