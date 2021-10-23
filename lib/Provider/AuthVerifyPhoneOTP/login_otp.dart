import 'dart:async';

import 'package:buddhistauction/Service/service_alert.dart';

import '../../Service/authservice.dart';
import '../../Page/Auth/Login/loginpage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginOTPProvider extends ChangeNotifier {

  String verificationId;
  int reSend;
  bool codeSent = false;

  Future<void> verifyPhone(String password,String phoneNo, BuildContext context) async {

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print("PhoneCodeAutoRetrievalTimeout der");
      this.verificationId = verId;
      this.codeSent = true;
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
          print("PhoneVerificationCompleted der");
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
          if (authException.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            Navigator.pop(context);
            //ServiceAlert.messageAlertOneButton("ເບີບໍ່ຖືກຕ້ອງ", "ເກີດຂໍ້ຜິດພາດ", context,4);
            ServiceAlert.alertError(context,"ເບີບໍ່ຖືກຕ້ອງ");
          }else if(authException.code =='missing-client-identifier'){
            Navigator.pop(context);
            ServiceAlert.alertError(context,"ເບີຂອງທ່ານຍັງບໍ່ທັນລົງທະບຽນ");
          }else if(authException.code=='too-many-requests'){
            Navigator.pop(context);
            ServiceAlert.alertError(context,"ທ່ານທຳການຮ້ອງຂໍຫຼາຍເກີນໄປ ເບີໂທຂອງທ່ານຖືກລະງັບການໃຊ້ງານຊົ່ວຄາວ ");
          }
          else{

            Navigator.pop(context);
            ServiceAlert.alertError(context,"ຂໍ້ມູນບໍ່ຖືກຕ້ອງ");
          }

          print('message:${authException.message}');
          print('code:${authException.code}');
          print('phone:${authException.phoneNumber}');
          print('email:${authException.email}');
          print('tenantId:${authException.tenantId}');
          print('plugin:${authException.plugin}');
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      print("smsCodeSent der");
      Navigator.pop(context);
      this.verificationId = verId;
      this.reSend = forceCodeResend;
      print(verificationId);
      Navigator.of(context).pushNamed('/otppagelogin',
          arguments: LoginArgument(
              verificationIdArg: verificationId, phoneNoArg: phoneNo,password: password,context: context)

      );
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        forceResendingToken: codeSent ? reSend : null,
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve,

    );
  }

  Timer _timer;
  get timer=>_timer;

  int _timeRemain;
  get timeRemain => _timeRemain;
  set timeRemain(val){
    _timeRemain = val;
    notifyListeners();
}
  void startTimer() {
    timeRemain=120;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if (timeRemain <= 0) {
        timer.cancel();
      } else {
        timeRemain--;
      }

    });
    notifyListeners();
  }

}
