import 'package:buddhistauction/Page/ReleaseBuddhist/fourth_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Provider/StoreData/store_release_buddhist.dart';
import 'package:buddhistauction/TransitionPageRoute/slide_left_right.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  //int _value ;
  var _key = GlobalKey<FormState>();
  TextEditingController _priceStart = new TextEditingController();
  TextEditingController _priceSmallest = new TextEditingController();
  // TextEditingController _bankName = new TextEditingController();
  // TextEditingController _accountName = new TextEditingController();
  // TextEditingController _accountNumber = new TextEditingController();

  @override
  void initState() {
    _priceStart.addListener((){
      // using Ashok's answer to format the text
      final regEX = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      final matchFunc = (Match match) => '${match[1]},';
      final text = _priceStart.text;

      _priceStart.value = _priceStart.value.copyWith(
        // we need to remove all the ',' from the values before reformatting
        // if you use other formatting values, remember to remove them here
        text: text.replaceAll(',', '').replaceAllMapped(regEX, matchFunc),
        // this will keep the cursor on the right as you type in values
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
      );
    });

    _priceSmallest.addListener((){
      // using Ashok's answer to format the text
      final regEX = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      final matchFunc = (Match match) => '${match[1]},';
      final text = _priceSmallest.text;

      _priceSmallest.value = _priceSmallest.value.copyWith(

        text: text.replaceAll(',', '').replaceAllMapped(regEX, matchFunc),

        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
      );
    });
    super.initState();
  }
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
        title: Text("ປ່ອຍເຄື່ອງ",style: TextStyle(color:Colors.black,fontSize: 24,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ລາຄາເລີ່ມຕົ້ນ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(
                  builder: (context, srb, child) {
                    if (_priceStart.text != srb.priceStart) {

                      _priceStart.text = srb.priceStart ?? '';
                    }
                    return TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _priceStart,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onChanged: (value) {
                        srb.setPriceStart(value);
                        srb.setCtrlPriceStart(_priceStart);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ກະລຸນາໃສ່ລາຄາ';
                        }
                        return null;
                      },
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
                Text("ເຄາະຂັ້ນຕໍ່າ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
                SizedBox(
                  height: 10,
                ),
                Consumer<StoreReleaseBuddhistProvider>(
                  builder: (context, srb, child) {
                    if (_priceSmallest.text != srb.priceSmallest) {

                      _priceSmallest.text = srb.priceSmallest ?? '';
                    }
                   return TextFormField(
                     inputFormatters: <TextInputFormatter>[
                       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                     ],
                     keyboardType: TextInputType.number,
                      controller: _priceSmallest,
                      onChanged: (value) {
                        srb.setPriceSmallest(value);
                        srb.setCtrlPriceSmallest(_priceSmallest);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    );



                  }),

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
          child:  numberPage(),
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
                  child: Text("1",style:TextStyle(color:Colors.white,fontSize: 26,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
                ),

                SizedBox(
                  height: 5,
                ),
                Text("ລົງຮູບ",style:TextStyle(color:Color.fromARGB(255, 253, 200, 200),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20,color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),

                  child: Text("2",style:TextStyle(color:Colors.white,fontSize: 26,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ຂໍ້ມູນ",style:TextStyle(color:Color.fromARGB(255, 253, 200, 200),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20,color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(255, 196, 39, 1),

                  child: Text("3",style:TextStyle(color:Colors.white,fontSize: 26,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ລາຄາ",style:TextStyle(color:Colors.black,fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                alignment: Alignment.topCenter,
                child: Text(
                  ". . . .",
                  style: TextStyle(fontSize: 20,color: Colors.grey),
                )),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 253, 200, 200),
                  child: Text("4",style:TextStyle(color:Colors.white,fontSize: 26,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("ຈັດສົ່ງ",style:TextStyle(color:Color.fromARGB(255, 253, 200, 200),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'boonhome')),
              ],
            ),
          ],
        ),
      ],
    );
  }


  Widget submitButton(){
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

        child: Text('ຕໍ່ໄປ',style: TextStyle(
            fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
        onPressed: (){
          if (_key.currentState.validate()) {
            _key.currentState.save();


              Navigator.push(context, SlideRightRoute(page: FourthPage()));


          } else {
            Fluttertoast.showToast(
                msg: "ປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);  }
        },
      ),
    );
  }
}
