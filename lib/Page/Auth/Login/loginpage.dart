

import 'package:buddhistauction/Service/service_alert.dart';
import 'package:buddhistauction/TransitionPageRoute/slide_left_right.dart';

import '../Register/registerpage.dart';
import 'package:buddhistauction/LoginBackground/bezierContainer.dart';
import '../../../Provider/AuthVerifyPhoneOTP/login_otp.dart';
import '../../../Provider/StoreData/store_text_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:provider/provider.dart';




class LoginPage extends StatefulWidget {



  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

final TextEditingController phoneController = new TextEditingController();
final TextEditingController passController = new TextEditingController();


bool isPhoneNull=false,isPassNull=false;
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: <Widget>[
                      SizedBox(height: height * .2),
                       _title(),
                      //_logo(),
                      _emailPasswordWidget(),
                      SizedBox(height: 10),
                      _submitButton(),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/forgetpasswordpage");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text('ລືມລະຫັດຜ່ານ ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500,fontFamily: 'boonhome')),
                        ),
                      ),


                      //SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }


  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black,size: 40,),
            ),
            // Text('Back',
            //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }


  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,

      child: Container(
        width: double.maxFinite,
        height: 35,
        child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(255, 196, 39, 1),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),

          child: Text(
            'ເຂົ້າສູ່ລະບົບ',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed:
          isPhoneNull == false || isPassNull == false ? null :
              () {
           ServiceAlert.alertLoading(context);
            print("click");
            Provider.of<LoginOTPProvider>(context, listen: false)
                .verifyPhone(passController.text, "+85620"+phoneController.text, context);

          },
        ),
      ),
    );
  }





  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {


        Navigator.push(context, SlideRightRoute(page: RegisterPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ຍັງບໍ່ມີບັນຊີເທື່ອບໍ ?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,fontFamily: 'boonhome'),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'ລົງທະບຽນ',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,fontFamily: 'boonhome'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'ຂ',
          style: TextStyle(

            fontSize: 60,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ອ',
              style: TextStyle(color: Colors.black, fontSize: 60),
            ),
            TextSpan(
              text: 'ງດີ',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 60),
            ),
          ]),
    );
  }

  // Widget _logo(){
  //   return Container(
  //     width: 128,
  //     height: 128,
  //     child: Image.asset("asset/image/kongdee_logo.png"),
  //   );
  // }

  Widget _emailPasswordWidget() {

    return Container(


      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          Consumer<StoreTextLoginProvider>(
            builder: (context, stl, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("ເບີໂທລະສັບ",style: TextStyle(fontSize: 16),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment. spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                          color:Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: 50,
                          child: TextField(
                            enabled: false,
                            textAlign: TextAlign.center,
                            controller: TextEditingController(text: "020"),
                            decoration: InputDecoration(

                              border: InputBorder.none,

                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 4,
                        child: Container(

                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(8),
                            ],
                            controller: phoneController,
                            onChanged: (value){
                              stl.setPhoneNo("+85620${value.trim()}");
                              if(value.isNotEmpty){
                                setState(() {
                                  isPhoneNull = true;
                                });
                              }else{
                                setState(() {
                                  isPhoneNull = false;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,

                            decoration: InputDecoration(

                              border: InputBorder.none,

                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                              EdgeInsets.only(left:11, bottom: 11, top: 11, right: 15),
                              hintText: 'ເບີໂທລະສັບ',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },

          ),

          SizedBox(height: 20,),
          Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [

              Container(
                child: Text("ລະຫັດຜ່ານ",style: TextStyle(fontSize: 16)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Consumer<StoreTextLoginProvider>(
                  builder: (context, stl, child) {
                    return TextField(
                    controller: passController,
                      onChanged: (value){
                        stl.setPassword(value.trim());
                        if(value.isNotEmpty){
                          setState(() {
                            isPassNull = true;
                          });
                        }else{
                          setState(() {
                            isPassNull = false;
                          });
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left:11, bottom: 11, top: 11, right: 15),
                        hintText: 'ລະຫັດຜ່ານ',
                      ),
                    );
                  },

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class LoginArgument {
  String verificationIdArg;
  String phoneNoArg;
  String password;
  BuildContext context;

  LoginArgument(
      {this.verificationIdArg,
        this.phoneNoArg,
        this.password,
        this.context,
        });
}

