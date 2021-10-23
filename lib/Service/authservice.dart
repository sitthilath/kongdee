import 'dart:convert';


import 'package:buddhistauction/Page/Auth/ForgetPassword/forget_password_page.dart';
import 'package:buddhistauction/Service/service_alert.dart';

import '../Page/Auth/Login/loginpage.dart';
import '../Page/Auth/Register/registerpage.dart';

import '../Provider/StoreData/store_token.dart';
import 'package:buddhistauction/const_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

class AuthService extends ChangeNotifier {

  void registerUser(
      String name,
      String surname,
      String phoneNumber,

      String firebaseToken,
      String password,

      BuildContext context,) async{
    var url = Uri.parse("$API_URL/register");
    print('101');

    String fcmTokenPref = Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;

    print('104 $fcmTokenPref');
    await http.post(url, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {

     'name' : name,
    'surname' : surname,
    'phone_number' : phoneNumber,
    'firebase_token' : firebaseToken,
    'password' : password,
    'fcm_token' :  fcmTokenPref,

    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body}');

      var result = json.decode(response.body);
      var token = "${result['access_token']}";
      debugPrint("Token :"+token, wrapWidth: 1024);
      Provider.of<StoreTokenProvider>(context, listen: false).setTokens(token);



      if (response.statusCode == 200 ) {


        String token = "${result['access_token']}";
        debugPrint("Token: $token", wrapWidth: 1024);


        Provider.of<StoreTokenProvider>(context, listen: false).setTokens(token);


        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/success_register", (Route<dynamic> route) => false);
      } else if (response.statusCode == 422 ) {

        Navigator.pop(context);
        ServiceAlert.messageAlertOneButton('ເບີນີ້ຖືກລົງທະບຽນແລ້ວ ', context,1);
        return null;
      }
      else
      {
      Navigator.pop(context);
      ServiceAlert.messageAlertOneButton('ກະລຸນາກວດຂໍ້ມູນທີ່ທ່ານປ້ອນ ', context,1);
      return null;
      }
    }).catchError((e) {
      print("Error: $e");
    });
  }


  // Future<Map<String, dynamic>> registerUser(
  //     String name,
  //     String surname,
  //     String phoneNumber,
  //
  //     String firebaseToken,
  //     String password,
  //
  //     BuildContext context,
  //
  //
  //
  //    ) async {
  //   final headers = {HttpHeaders.acceptHeader: "application/json"};
  //   String fcmToken = Provider.of<StoreTokenProvider>(context, listen: false).fcmTokens;
  //   Uri apiUrl =  Uri.parse("$API_URL/register");
  //   // Intilize the multipart request
  //   final registerRequest = http.MultipartRequest('POST', apiUrl);
  //
  //
  //
  //   registerRequest.headers.addAll(headers);
  //
  //   registerRequest.fields['name'] = name;
  //   registerRequest.fields['surname'] = surname;
  //   registerRequest.fields['phone_number'] = phoneNumber;
  //
  //   registerRequest.fields['firebase_token'] = firebaseToken;
  //   registerRequest.fields['password'] = password;
  //
  //   registerRequest.fields['fcm_token'] =  fcmToken;
  //   try {
  //     final streamedResponse = await registerRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //     if (response.statusCode == 422) {
  //
  //
  //       Navigator.pop(context);
  //
  //       ServiceAlert.messageAlertOneButton('ເບີນີ້ຖືກລົງທະບຽນແລ້ວ ', context,1);
  //       return null;
  //     }else if(response.statusCode != 200){
  //
  //       Navigator.pop(context);
  //
  //       ServiceAlert.messageAlertOneButton('ກະລຸນາກວດຂໍ້ມູນທີ່ທ່ານປ້ອນ ', context,1);
  //       return null;
  //     }
  //       else {
  //       var result = json.decode(response.body);
  //
  //
  //       String token = "${result['access_token']}";
  //       debugPrint("Token: $token", wrapWidth: 1024);
  //       Provider.of<StoreTokenProvider>(context, listen: false)
  //           .setTokens(token);
  //
  //       StoreTokenProvider().setFcmToken(fcmToken);
  //       StoreTokenProvider().setToken(token);
  //
  //       Navigator.pop(context);
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //           "/homepage", (Route<dynamic> route) => false);
  //     }
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     return responseData;
  //   } catch (e) {
  //
  //     throw ("Error: $e");
  //   }
  // }



  ///LoginPushTokenFirebasebToLaravel
  void loginUser(String phoneNumber, String firebaseToken, String password,
      BuildContext context) async{
    var url = Uri.parse("$API_URL/login");
    print('101');

    String fcmTokenPref = Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;

    print('104 $fcmTokenPref');
   await http.post(url, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      'phone_number': phoneNumber,
      'firebase_token': firebaseToken,
      'password': password,
      'fcm_token': fcmTokenPref,
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response status : ${response.body}');

      var result = json.decode(response.body);


      var token = "${result['access_token']}";
      debugPrint("Token :"+token, wrapWidth: 1024);


      Provider.of<StoreTokenProvider>(context, listen: false).setTokens(token);



      if (response.statusCode == 200 ) {

        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/homepage", (Route<dynamic> route) => false);
      } else if (response.statusCode == 404 ) {
        Navigator.pop(context);

        ServiceAlert.messageAlertOneButton('ເບີຂອງທ່ານຍັງບໍ່ທັນລົງທະບຽນ', context,2);

      }
        else
      {

        Navigator.pop(context);
        ServiceAlert.messageAlertOneButton('ກະລຸນາກວດສອບເບີໂທ ແລະ ລະຫັດຜ່ານ ', context,2);


        print("Error: kuynum");
      }
    }).catchError((e) {
      print("Error: $e");
    });
  }

  ///ForgetPassword
  void forgetPassword(String password, String firebaseToken,
      BuildContext context) async{
    var url = Uri.parse("$API_URL/reset");
    print(password);
    print(firebaseToken);
    await http.post(url, headers: {
      'Accept': 'application/json; charset=UTF-8',
    }, body: {
      'password': password,
      'firebase_token': firebaseToken,

    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response Body : ${response.body}');


      if (response.statusCode == 200 ) {

        Navigator.pop(context);
        ServiceAlert.alertSuccess(context, "forget");

      } else if (response.statusCode == 404 ) {

        ServiceAlert.messageAlertOneButton( 'ເບີຂອງທ່ານຍັງບໍ່ທັນລົງທະບຽນ  ', context,3);
        Navigator.pop(context);

      }else{
        ServiceAlert.messageAlertOneButton( 'ກະລຸນາກວດສອບເບີໂທ  ', context,3);
        Navigator.pop(context);
      }
    }).catchError((e) {
      print("Error: $e");
    });
  }


  Future<UserCredential> signIn(AuthCredential authCredential) {
    return FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  Future<String> registerWithOTP(
      smsCode, verId, BuildContext context) async {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {
      OtpArgument args = ModalRoute.of(context).settings.arguments;

      final UserCredential credential = await signIn(authCredential);
      final idToken = await credential.user.getIdToken();


      print("tokenID:" + idToken);



      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      print("GET : ${firebaseMessaging.getToken()}");
      firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print("FCM Token : $token");
        Provider.of<StoreTokenProvider>(context, listen: false)
            .setFcmTokens(token);
        print("FCM Token Provider: ${ Provider.of<StoreTokenProvider>(context, listen: false)
            .fcmTokens}");
        registerUser(
          args.name,
          args.surname,
          args.phoneNoArg,
          idToken,
          args.password,
          args.context,

        );
      });

      return Future.value(idToken);
    } catch (e) {
      Navigator.pop(context);
      //ServiceAlert.messageAlertOneButton('ກະລຸນາກວດສອບລະຫັດ OTP ', 'ຂໍ້ມູນຜິດພາດ', context,4);
      //ServiceAlert.alertError(context,"ກະລຸນາກວດສອບລະຫັດ OTP");
      ServiceAlert.alertError(context,"ເກີດຂໍ້ຜິດພາດ $e");
      print("SignIn Error: $e");
    }
    return Future.value('');
  }

  Future<String> loginWithOTP(
      smsCode, verId, BuildContext context) async {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {
      LoginArgument args = ModalRoute.of(context).settings.arguments;
      print("ProviderID : ${authCredential.providerId}");
      print("Sign In Method : ${authCredential.signInMethod}");
      print("Token Print : ${authCredential.token}");
      final UserCredential credential = await signIn(authCredential);
      print("signIn Success");
      final idToken = await credential.user.getIdToken();

      print("tokenID:" + idToken);
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print("FCM Token : $token");
        Provider.of<StoreTokenProvider>(context, listen: false).setFcmTokens(token);
        print("FCM Token Provider: ${Provider.of<StoreTokenProvider>(context, listen: false).fcmTokens}");
        loginUser(args.phoneNoArg, idToken, args.password, args.context);
      });


      return Future.value(idToken);
    } catch (e) {
      Navigator.pop(context);
      //ServiceAlert.messageAlertOneButton('ກະລຸນາກວດສອບລະຫັດ OTP ', 'ຂໍ້ມູນຜິດພາດ', context,4);
      //ServiceAlert.alertError(context,"ກະລຸນາກວດສອບລະຫັດ OTP");
      ServiceAlert.alertError(context,"ເກີດຂໍ້ຜິດພາດ");
      print("SignIn Error: $e");
    }
    return Future.value('');
  }


  Future<String> forgetPasswordWithOTP(
      smsCode, verId, BuildContext context) async {
    AuthCredential authCredential =
    PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    try {

      final UserCredential credential = await signIn(authCredential);
      final idToken = await credential.user.getIdToken();

      Navigator.pop(context);
      Navigator.pushNamed(context, "/newpasswordpage",arguments: ForgetPasswordArgument(verificationIdArg: idToken));
       return Future.value(idToken);
    } catch (e) {
      Navigator.pop(context);
      //ServiceAlert.messageAlertOneButton('ກະລຸນາກວດສອບລະຫັດ OTP ', 'ຂໍ້ມູນຜິດພາດ', context,4);
      ServiceAlert.alertError(context,"ກະລຸນາກວດສອບລະຫັດ OTP");
      print("SignIn Error: $e");
    }
    return Future.value('');
  }



}
