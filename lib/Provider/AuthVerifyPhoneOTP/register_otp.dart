import 'dart:async';

import 'package:buddhistauction/Service/service_alert.dart';

import '../../Service/authservice.dart';
import '../../Page/Auth/Register/registerpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterOTPProvider extends ChangeNotifier {

  String verificationId;
  int reSend;
  bool codeSent = false;

  Future<void> verifyPhone(
      String name,
      String surname,
      String password,
      String phoneNo,

      BuildContext context) async {

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
      this.codeSent = true;
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
      if (authException.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
        Navigator.pop(context);
        ServiceAlert.alertError(context,"ເບີບໍ່ຖືກຕ້ອງ");
      }else if(authException.code=='too-many-requests'){
        Navigator.pop(context);
        ServiceAlert.alertError(context,"ທ່ານທຳການຮ້ອງຂໍຫຼາຍເກີນໄປ ໄອດີຂອງທ່ານຖືກລະງັບການໃຊ້ງານຊົ່ວຄາວ ");
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
      Navigator.pop(context);
      this.verificationId = verId;
      this.reSend = forceCodeResend;
      print(verificationId);



      Navigator.of(context).pushNamed('/otppageregister',
          arguments: OtpArgument(
              verificationIdArg: verificationId,
              phoneNoArg: phoneNo,
              name: name,
              surname: surname,
              password: password,
              context: context));
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        forceResendingToken: codeSent ? reSend : null,
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
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
