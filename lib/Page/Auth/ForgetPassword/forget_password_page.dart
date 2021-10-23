import 'package:buddhistauction/Provider/StoreData/store_text_forget_password.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Provider/AuthVerifyPhoneOTP/forget_password_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var _formKey = GlobalKey<FormState>();
  String phoneNo;

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
             Align(
               alignment: Alignment.centerLeft,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("ຕັ້ງລະຫັດຜ່ານໃຫມ່",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                   SizedBox(
                     height: MediaQuery.of(context).size.height * 0.02,
                   ),
                   Text("ປ້ອນເບີທີ່ທ່ານຕ້ອງການ ຕັ້ງລະຫັດຜ່ານໃຫມ່",style: TextStyle(fontSize: 16,)),
                 ],
               ),
             ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              phoneTextField(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneTextField() {
    return Row(

      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
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
        SizedBox(width: 10,),
        Expanded(
          flex: 4,

          child: Consumer<StoreTextForgetPasswordProvider>(
            builder: (context, value, child) =>
             TextFormField(

              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(8),
              ],
              onChanged: (val) {
                value.setPhoneNo("+85620" + val.trim());
                phoneNo = "+85620" + val.trim();
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
                }

                return null;
              },
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.phone),
                hintText: 'ເບີໂທລະສັບ',
                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,

                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget submitButton() {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor:Color.fromRGBO(255, 196, 39, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
            Provider.of<ForgetPasswordOTPProvider>(context, listen: false)
                .verifyPhone( phoneNo, context);
          } else {
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

class ForgetPasswordArgument {
  String verificationIdArg;
  String phoneNoArg;
  BuildContext context;

  ForgetPasswordArgument(
      {this.verificationIdArg,
        this.phoneNoArg,

        this.context,

      });
}
