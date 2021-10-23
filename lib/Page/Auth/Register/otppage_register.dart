import 'package:buddhistauction/Provider/StoreData/store_otp_number.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:flutter/scheduler.dart';

import '../../../Service/authservice.dart';
import 'registerpage.dart';
import '../../../Provider/AuthVerifyPhoneOTP/register_otp.dart';

import '../../../Provider/StoreData/store_text_register.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class OTPPageRegister extends StatefulWidget {
  @override
  _OTPPageRegisterState createState() => _OTPPageRegisterState();
}

class _OTPPageRegisterState extends State<OTPPageRegister> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode pin2FocusNode;

  FocusNode pin3FocusNode;

  FocusNode pin4FocusNode;

  FocusNode pin5FocusNode;

  FocusNode pin6FocusNode;


  String smsCode;



  @override
  void initState() {
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegisterOTPProvider>(context,listen:false).startTimer();
    });


    super.initState();
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        if (Provider
            .of<RegisterOTPProvider>(context, listen: false)
            .timer != null) {
          Provider
              .of<RegisterOTPProvider>(context, listen: false)
              .timer
              .cancel();
        }
      }
    });
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    super.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    OtpArgument args = ModalRoute.of(context).settings.arguments;



    return Scaffold(
      key: _scaffoldKey,
      appBar:  AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text("OTP Verification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Consumer<StoreTextRegisterProvider>(
                    builder: (context, value, child) =>
                     Text("ສົ່ງລະຫັດຢືນຢັນໄປທີ່ເບີ ${value.phoneNo}")),

                buildTimer(),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),

                otpForm(args.verificationIdArg),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Consumer<RegisterOTPProvider>(
                  builder: (context, registerNotify, child) =>
                  TextButton(
                    onPressed: registerNotify.timeRemain !=0 ?null: () {
                      registerNotify.verifyPhone(
                          args.name,
                          args.surname,
                          args.password,
                          args.phoneNoArg,
                          context);
                    },
                    child: Text("ສົ່ງລະຫັດຢືນຢັນອີກຄັ້ງ"),
                  ),
                )
                //  OtpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

   buildTimer() {
    return Consumer<RegisterOTPProvider>(
      builder: (context, value, child) =>
          RichText(text: TextSpan(
              text: 'ລະຫັດຢືນຢັນຈະໝົດເວລາໃນ ',
              style: TextStyle(color:Colors.black),
              children: [
                TextSpan(
                  text: '${value.timeRemain}',
                  style: TextStyle(color: Colors.red),
                ) ,
              ]
          )),
    );
  }

  Form otpForm(String verificationIdArg) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: Consumer<StoreOtpNumber>(
                  builder: (context, store, child) =>

                   TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onChanged: (value) {


                        nextField(value, pin2FocusNode);
                       store.otp1 = value.trim();


                    },
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child:
                Consumer<StoreOtpNumber>(
                  builder: (context, store, child) =>
                      TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: pin2FocusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) {

                      nextField(value, pin3FocusNode);
                      store.otp2 = value.trim();


                  },
                ),
                ),
              ),
              SizedBox(
                width: 40,
                child:
                Consumer<StoreOtpNumber>(
                  builder: (context, store, child) =>
                      TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: pin3FocusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) {

                      nextField(value, pin4FocusNode);
                      store.otp3 = value;


                  },
                ),
                ),
              ),
              SizedBox(
                width: 40,
                child:
                Consumer<StoreOtpNumber>(
                  builder: (context, store, child) =>
                      TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: pin4FocusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) {

                      nextField(value, pin5FocusNode);
                      store.otp4 = value.trim();


                  },
                ),
                ),
              ),
              SizedBox(
                width: 40,
                child:
                Consumer<StoreOtpNumber>(
                  builder: (context, store, child) =>
                      TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: pin5FocusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) {

                      nextField(value, pin6FocusNode);
                      store.otp5 = value.trim();


                  },
                ),
                ),
              ),
              SizedBox(
                width: 40,
                child:
                Consumer<StoreOtpNumber>(
                  builder: (context, store, child) =>
                      TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: pin6FocusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) {

                      pin6FocusNode.unfocus();
                      store.otp6 = value.trim();


                  },
                ),
              ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),

          Container(
            width: double.maxFinite,
            height: 50,
            child:
            Consumer<StoreOtpNumber>(
              builder: (context, store, child) =>
                  ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

              child: Text(
                'ຢືນຢັນ',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {


                // final idToken =
                ServiceAlert.alertLoading(context);
                await AuthService().registerWithOTP("${
                        store.otp1 +
                        store.otp2 +
                        store.otp3 +
                        store.otp4 +
                        store.otp5 +
                        store.otp6
                  }", verificationIdArg,context);
                // debugPrint(idToken, wrapWidth: 1024);
              },
            ),
            ),
          ),


        ],
      ),
    );
  }


}