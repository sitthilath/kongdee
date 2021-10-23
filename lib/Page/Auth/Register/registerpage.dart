
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:flutter/services.dart';

import '../../../Provider/AuthVerifyPhoneOTP/register_otp.dart';
import '../../../Provider/StoreData/store_text_register.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04), // 4%
                Text(
                  'ຕື່ມຂໍ້ມູນສ່ວນຕົວ',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'boonhome'),
                ),


                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                SignUpForm(),

                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = new TextEditingController();

  String name, surname, phoneNo, password;

  bool isName=false,isSurname=false,isPhoneNo=false,isPassword=false;



  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [


          nameTextField(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          surnameTextField(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          phoneTextField(),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          passTextField(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),


          submitButton(),
        ],
      ),
    );
  }



  Widget nameTextField() {
    return Consumer<StoreTextRegisterProvider>(
      builder: (context, str, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ຊື່",style: TextStyle(fontSize: 18,color: Colors.black),),
            Container(



              child: TextFormField(
                onChanged: (value) {
                  str.setName(value.trim());
                  name = value.trim();
                },
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຂໍ້ມູນ';

                  }
                  return null;
                },
                decoration: InputDecoration(
hintText: "ຊື່",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget surnameTextField() {
    return Consumer<StoreTextRegisterProvider>(
      builder: (context, str, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ນາມສະກຸນ",style: TextStyle(fontSize: 18,color: Colors.black),),
            Container(


              child: TextFormField(
                onChanged: (value) {
                  str.setSurname(value.trim());
                  surname = value.trim();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຂໍ້ມູນ';

                  }
                  return null;
                },
                decoration: InputDecoration(

                  hintText: 'ນາມສະກຸນ',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget passTextField() {

    return Consumer<StoreTextRegisterProvider>(
      builder: (context, str, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ລະຫັດຜ່ານ",style: TextStyle(fontSize: 18,color: Colors.black),),
            Container(

              child: TextFormField(
                onChanged: (value) {
                  str.setPassword(value.trim());
                  password = value.trim();
                },
                controller: _pass,
                validator: (value) {
                  if (value.isEmpty) {

                    return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                    //return null;
                  }
                  if (value.length < 8) {
                    return 'ລະຫັດຜ່ານຢ່າງໜ້ອຍ 8';

                  }

                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(

                  hintText: 'ລະຫັດຜ່ານ',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],

                ),
              ),
            ),

          ],
        );
      },
    );
  }



  Widget phoneTextField() {
    return Consumer<StoreTextRegisterProvider>(
      builder: (context, str, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ເບີໂທລະສັບ",style: TextStyle(fontSize: 18,color: Colors.black),),
            SizedBox(

              child: Row(
                children: [
                  Expanded(
                    flex:1,
                    child: Container(


                      child: TextField(
                        enabled: false,
                        textAlign: TextAlign.center,
                        controller: TextEditingController(text: "020"),
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 4,
                    child: Container(

                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(8),
                        ],

                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          str.setPhoneNo("+85620" + val.trim());
                          phoneNo = "+85620" + val.trim();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ກະລຸນາປ້ອນຂໍ້ມູນ';

                          }else if (value.length<8) {
                            return 'ເບີຕ້ອງ 8 ຫຼັກ';

                          }

                          return null;
                        },
                        decoration: InputDecoration(

                          hintText: 'ເບີໂທລະສັບ',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),

        child: Text(
          'ສືບຕໍ່',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            ServiceAlert.alertLoading(context);
            Provider.of<RegisterOTPProvider>(context,listen: false)
                .verifyPhone(name, surname, password, phoneNo, context);
          } else
           {
            Fluttertoast.showToast(
                msg: "ປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
    );
  }
}

class OtpArgument {
  String verificationIdArg;
  String phoneNoArg;
  String name, surname, password;
  BuildContext context;


  OtpArgument(
      {this.verificationIdArg,
      this.phoneNoArg,
      this.name,
      this.surname,
      this.password,
      this.context,
      });
}
