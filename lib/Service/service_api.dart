import 'dart:convert';

import 'package:buddhistauction/Model/bidding_result_detail.dart';
import 'package:buddhistauction/Model/buddhist_bottom_search.dart';
import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Model/buddhist_favorite.dart';
import 'package:buddhistauction/Model/buddhist_notification.dart';
import 'package:buddhistauction/Model/buddhist_recommend.dart';
import 'package:buddhistauction/Model/buddhist_type.dart';
import 'package:buddhistauction/Model/buddhist_type_id.dart';
import 'package:buddhistauction/Model/fail_release.dart';
import 'package:buddhistauction/Model/item_auctioning.dart';
import 'package:buddhistauction/Model/lose_auction.dart';
import 'package:buddhistauction/Model/notification_count.dart';
import 'package:buddhistauction/Model/releasing.dart';
import 'package:buddhistauction/Model/success_release.dart';
import 'package:buddhistauction/Model/user.dart';
import 'package:buddhistauction/Model/win_auction.dart';
import 'package:buddhistauction/Page/inbox_message.dart';
import 'package:buddhistauction/Provider/argument_comment.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import '../Provider/StoreData/store_token.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import '../const_api.dart';



class ServiceApi{

  //Fetch Chat Message
  static Future<void> postChat(BuildContext context,String _sendTo,int _buddhistId,String message) async {
    var url = Uri.parse("$API_URL/chat");
    String token = Provider.of<StoreTokenProvider>(context,listen:false).tokens;
    print(_sendTo);
    print("$_buddhistId");
    final response = await http.post(url, headers: {
      "Accept-Charset": "application/json",
      "Authorization": "Bearer $token"
    },
        body: {
          "chat_room_id":"$_buddhistId", //125
          "send_to":"$_sendTo", //14
          "message":"$message", //
        }
    );

    print("Code=${response.statusCode}");
    print("Body=${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("successfully");
      Provider.of<ArgumentComment>(context,listen:false).scrollControllerChat.animateTo(
        Provider.of<ArgumentComment>(context,listen:false).scrollControllerChat.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } else {

      throw Exception('Failed to load APi');
    }
  }


  //Fetch Check Chat Room
  static Future<void> fetchCheckChatRoom(String token,BuildContext context,String _sendTo,int _buddhistId) async {
    var url = Uri.parse("$API_URL/check_chat_room");
    print(_sendTo);
    // print("$token");
    final response = await http.post(url, headers: {
      "Accept-Charset": "application/json",
      "Authorization": "Bearer $token"
    },
    body: {
      "send_to":"$_sendTo",
      "buddhist_id":"$_buddhistId",
    }
    );

    print("Code=${response.statusCode}");
    print("Body=${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>
          InboxMessage(
          sendTo: _sendTo,
            buddhistId:_buddhistId ,
          )));
    } else {

      throw Exception('Failed to load APi');
    }
  }

  //Fetch Favorite
  static  Future<BuddhistFavorite> fetchFavorite(BuildContext context,int pageKey) async {
    final token = await StoreTokenProvider().getToken();
    var url = Uri.parse("$API_URL/favorite/buddhist?page=$pageKey");
    final response = await http.get(url,headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    print("StatusCode fetchFavorite: ${response.statusCode}");
    print("body fetchFavorite: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BuddhistFavorite.fromJson(data);
    }else if(response.statusCode == 401){
      StoreTokenProvider().clearLocalStorageToken();
      Provider.of<StoreTokenProvider>(context,listen: false).setTokens("");
      throw Exception('UnAuth');
     }
    else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load API');
    }
  }

//Fetch User
 static Future<User> fetchUser(BuildContext context) async {
    String token = await StoreTokenProvider().getToken();
    String fcm =  Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;

    debugPrint("token = $token",wrapWidth: 1024);
    debugPrint("fcm = $fcm",wrapWidth: 1024);

    var url = Uri.parse("$API_URL/user");
    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    print("StatusCode User : ${response.statusCode}");
    print("body User : ${response.body}");
    if (response.statusCode == 200) {

      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      Provider.of<UserViewModel>(context,listen:false).isUser = false;
      StoreTokenProvider().clearLocalStorageToken();
      return null;
    }else {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      return null;
    }
  }

 //Fetch Owner
 static Future<User> fetchOwner(String ownerID) async {
   var url = Uri.parse("$API_URL/user/${ownerID.toString()}");
   final response = await http.get(url, headers: {
     "Accept-Charset": "application/json",
   });

   print("fetchOwner body=${response.body}");
   print("fetchOwner Code=${response.statusCode}");
   if (response.statusCode == 200 || response.statusCode == 201) {
     return User.fromJson(jsonDecode(response.body));
   } else {

     throw Exception('Failed to load album');
   }
 }


  //Fetch Buddhist ListItem Of Type
 static Future<BuddhistDetailListType> fetchBuddhistListType(String id,int pageKey) async {
   var url = Uri.parse("$API_URL/typeBuddhist/$id?page=$pageKey");
   final response = await http.get(url );
   print("StatusCode BuddhistDetailListType: ${response.statusCode}");
   print(json.decode(response.body));
   if (response.statusCode == 200) {
     print("dai");

     final data = json.decode(response.body);

     return BuddhistDetailListType.fromJson(data);
   } else {
     print("br dai");
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }

 //Fetch Buddhist Type
 static  Future<BuddhistType> fetchBuddhistType() async {
   var url = Uri.parse("$API_URL/type");
   final response = await http.get(url);
   print("StatusCode BuddhistType: ${response.statusCode}");
   if (response.statusCode == 200) {
    final data = json.decode(response.body);
     return BuddhistType.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }


  //fetch Buddhist Bottom Search
  static Future<BuddhistBottomSearch> fetchBuddhistForSearching(String input) async {
    var url = Uri.parse("$API_URL/buddhist?search=$input");
    final response = await http.get(url);
    print("StatusCode Search: ${response.statusCode}");
    print(" Search: ${response.body}");


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BuddhistBottomSearch.fromJson(data);
    } else {
      throw Exception('Failed to load API');
    }
  }

 //fetch Buddhist Bottom Search
 static Future<BuddhistBottomSearch> fetchBuddhistBottomSearch(int _pageKey) async {
   var url = Uri.parse("$API_URL/buddhist?page=$_pageKey");
   final response = await http.get(url);
   print("StatusCode BuddhistBottomSearch: ${response.statusCode}");
   print(" BuddhistBottomSearch: ${response.body}");


   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return BuddhistBottomSearch.fromJson(data);
   } else {
     throw Exception('Failed to load API');
   }
 }

  //fetch Buddhist Bottom Search Popular
  static Future<BuddhistBottomSearch> fetchBuddhistBottomSearchPopular(int pageKey) async {
    var url = Uri.parse("$API_URL/most_like?page=$pageKey");
    final response = await http.get(url);
    print("StatusCode BuddhistBottomSearchPopular: ${response.statusCode}");
    print(" BuddhistBottomSearchPopular: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BuddhistBottomSearch.fromJson(data);
    } else {
      throw Exception('Failed to load API');
    }
  }

  //fetch Buddhist Bottom Search Time Lower
  static Future<BuddhistBottomSearch> fetchBuddhistBottomSearchTimeLower(int pageKey) async {
    var url = Uri.parse("$API_URL/nearly_end?page=$pageKey");
    final response = await http.get(url);
    print("StatusCode BuddhistBottomSearchTimeLower: ${response.statusCode}");
    print(" BuddhistBottomSearchTimeLower: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BuddhistBottomSearch.fromJson(data);
    } else {
      throw Exception('Failed to load API');
    }
  }

 //fetch Buddhist Recommend
 static Future<BuddhistRecommend> fetchBuddhistRecommend(
     String idt, String idb) async {

   var url = Uri.parse("$API_URL/recommended/$idt/$idb");
   final response = await http.get(url);
   print("StatusCode BuddhistRecommend: ${response.statusCode}");
   print("body BuddhistRecommend: ${response.body}");
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return BuddhistRecommend.fromJson(data);
   } else {
     throw Exception('Failed to load API');
   }
 }


 // fetch Detail Buddhist/////////////////////////////////////////
 static Future<BuddhistDetail> fetchBuddhistDetail(int id) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/buddhist/${id.toString()}" );
   final response =
   await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token",
   });
   print("StatusCode BuddhistDetail: ${response.statusCode}");
   if (response.statusCode == 200 ) {
     // If the call to the server was successful, parse the JSON

     final data = json.decode(response.body);


     return BuddhistDetail.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }


 // Post favorite/////////////////////////////////////////
 static Future<void> favorite(String id,BuildContext context) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/favorite/buddhist");
   await http.post(url, headers: {
     'Accept': 'application/json; charset=UTF-8',
     'Authorization': 'Bearer $token'
   }, body: {
     'buddhist_id': id,
   }).then((response) {
     print('Response Post favorite Status : ${response.statusCode}');
     print('Response Post favorite body : ${response.body}');

     if (response.statusCode == 200) {
       print("Delete favorite");
     } else if (response.statusCode == 201) {
       print("Save favorite");
     } else {
       StoreTokenProvider().clearLocalStorageToken();
       Navigator.pushNamed(context, "/loginpage");

       print("UnAuth");
     }
   }).catchError((e) {
     print("Error: $e");
   });
 }

 //Fetch Bidding lose
 static  Future<LoseAuction> fetchLoseAuction(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/biddingLose?page=$pageKey");
   final response = await http.get(url,headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });
   print("StatusCode fetchLoseAuction: ${response.statusCode}");
   print("Body fetchLoseAuction: ${response.body}");
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return LoseAuction.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }

 //Fetch Bidding win
 static  Future<WinAuction> fetchWinAuction(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/biddingWin?page=$pageKey");
   final response = await http.get(url,headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });
   print("StatusCode fetchWinAuction: ${response.statusCode}");
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return WinAuction.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }

 //Fetch Release Buddhist Success
 static  Future<SuccessRelease> fetchSuccessRelease(int pageKey) async {
   final token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/mySoldOutBuddhist?page=$pageKey");
   final response = await http.get(url,headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });
   print("StatusCode fetchSuccessRelease: ${response.statusCode}");
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return SuccessRelease.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }

 //Fetch Release Buddhist Failed
 static  Future<FailRelease> fetchFailRelease(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/myNonSoldOutBuddhist?page=$pageKey",

   );
   final response = await http.get(url,headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });
   print("StatusCode fetchFailRelease: ${response.statusCode}");
   print("StatusCode fetchFailRelease: ${response.body}");
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return FailRelease.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }

 //Fetch Releasing Buddhist
 static  Future<Releasing> fetchReleasing(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/myActiveBuddhist?page=$pageKey");
   final response = await http.get(url,
       headers: {
         "Accept": "application/json",
         "Authorization": "Bearer $token"
       });
   print("StatusCode fetchFailRelease: ${response.statusCode}");
   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     return Releasing.fromJson(data);
   } else {
     // If that call was not successful, throw an error.
     throw Exception('Failed to load API');
   }
 }

  //Fetch Releasing Buddhist
  static  Future<ItemAuctioning> fetchItemAuctioning(int pageKey) async {
    String token = await StoreTokenProvider().getToken();
    var url = Uri.parse("$API_URL/participantBidding?page=$pageKey");
    final response = await http.get(url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    print("StatusCode fetchItemAuctioning: ${response.statusCode}");
    print("Body fetchItemAuctioning: ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ItemAuctioning.fromJson(data);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load API');
    }
  }

 // Future Bidding Notification
 static Future<BuddhistNotification> fetchBiddingNotification(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/biddingNotification?page=$pageKey");
   final response = await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });

   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {

     final values = json.decode(response.body);
     return  BuddhistNotification.fromJson(values);

   } else {

     throw Exception('Failed to load API');
   }
 }

 // Future Bidding Result Notification
 static Future<BuddhistNotification> fetchBiddingResultNotification(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/biddingResultNotification?page=$pageKey");
   final response = await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });

   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {

     final values = json.decode(response.body);
     return  BuddhistNotification.fromJson(values);

   } else {

     throw Exception('Failed to load API');
   }
 }

  // Future Bidding Notification
  static Future<BiddingResultDetail> fetchBiddingResultDetail(int buddhistId) async {
    String token = await StoreTokenProvider().getToken();
    var url = Uri.parse("$API_URL/checkBuddhistResult/$buddhistId");
    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {

      final values = json.decode(response.body);
      return  BiddingResultDetail.fromJson(values);

    } else {

      throw Exception('Failed to load API');
    }
  }


  // Future Message Notification
 static Future<BuddhistNotification> fetchMessageNotification(int pageKey) async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/messageNotification?page=$pageKey");
   final response = await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });

   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {

     final values = json.decode(response.body);
     return  BuddhistNotification.fromJson(values);

   } else {

     throw Exception('Failed to load API');
   }
 }


 // Future bidding Notification Count
 static Future<NotificationCount> fetchBiddingNotificationCount() async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/unreadBiddingCount");
   final response = await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });

   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {

     final values = json.decode(response.body);
     return  NotificationCount.fromJson(values);

   } else {

     throw Exception('Failed to load API');
   }
 }

 // Future bidding Result Notification Count
 static Future<NotificationCount> fetchBiddingResultNotificationCount() async {
   final token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/unReadBiddingResult");
   final response = await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });

   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {

     final values = json.decode(response.body);
     return  NotificationCount.fromJson(values);

   } else {

     throw Exception('Failed to load API');
   }
 }

 // Future Messge Notification Count
 static Future<NotificationCount> fetchMessageNotificationCount() async {
   String token = await StoreTokenProvider().getToken();
   var url = Uri.parse("$API_URL/unreadMessageCount");
   final response = await http.get(url, headers: {
     "Accept": "application/json",
     "Authorization": "Bearer $token"
   });

   print(response.statusCode);
   print(response.body);
   if (response.statusCode == 200) {

     final values = json.decode(response.body);
     return  NotificationCount.fromJson(values);

   } else {

     throw Exception('Failed to load API');
   }
 }
 /// Post Data Bidding ////////////////////////////////////////
 static Future<void> insertDataBidding(int price, int id,int remainTime,bool checkAdded,BuildContext context) async {
   String token = await StoreTokenProvider().getToken();
   String fcmToken = Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;
   var url = Uri.parse("$API_URL/bidding");
   await http
       .post(url,
       headers: {
         'Accept': 'application/json; charset=UTF-8',
         'Authorization': "Bearer " + token,
       },
       body: {
         'buddhist_id':"$id",
         'bidding_price': '$price',
         'fcm_token': fcmToken,
       })
       .then((response) {
     print('Response status : ${response.statusCode}');
     print('Response body : ${response.body}');
     if (response.statusCode == 200){

         Navigator.pop(context);
         ServiceAlert.alertSuccessBidding(context);

     }else if(response.statusCode == 400){
       Navigator.pop(context);
       ServiceAlert.alertError(context,'ມີຄົນປະມູນກ່ອນແລ້ວ');
     }
     else if(response.statusCode == 422){
       Navigator.pop(context);
       ServiceAlert.alertError(context,'ຂໍ້ມູນບໍ່ຄົບ');
     }
     else {
       Navigator.pop(context);
       ServiceAlert.alertError(context,'ເກີດຂໍ້ຜິດພາດ');


     }
   });
 }



 ///PostCommentToLaravel
 static Future<void> postComment(String message, int id,BuildContext context) async {
   String token = await StoreTokenProvider().getToken();
   String fcmToken =  Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;
   var url = Uri.parse("$API_URL/buddhist/comment");
   await http.post(url, headers: {
     'Accept': 'application/json; charset=UTF-8',
     'Authorization': 'Bearer $token',
   }, body: {
     'buddhist_id':"$id",
     'message': message,
     'fcm_token': fcmToken,
   }).then((response) {
     print('Response status : ${response.statusCode}');
     print('Response status : ${response.body}');
     print('fcm : $fcmToken');
     if (response.statusCode == 200 || response.statusCode == 201) {
       print("OK");


       Provider.of<ArgumentComment>(context,listen:false).scrollController.animateTo(
         Provider.of<ArgumentComment>(context,listen:false).scrollController.position.maxScrollExtent,
         curve: Curves.easeOut,
         duration: const Duration(milliseconds: 300),
       );

     } else {
       print("error E Y WA");
     }
   }).catchError((e) {
     print("Error: $e");
   });
 }


 /// Logout
 static Future<void> logout(BuildContext context) async {
   String token = await StoreTokenProvider().getToken();
   String fcmToken =  Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;
   var url = Uri.parse("$API_URL/logout");
   await http.post(url, headers: {
     'Accept': 'application/json; charset=UTF-8',
     'Authorization': 'Bearer $token',
   }, body: {

     'fcm_token': fcmToken,
   }).then((response) {
     print('Response status : ${response.statusCode}');
     print('Response status : ${response.body}');
     print('fcm : $fcmToken');
     if (response.statusCode == 200) {
       print("OK");
       StoreTokenProvider().clearLocalStorageToken();
       StoreTokenProvider().clearLocalStorageFcmToken();
       Provider.of<StoreTokenProvider>(context, listen: false).setTokens('');
       Provider.of<StoreTokenProvider>(context, listen: false).setFcmTokens('');
       Navigator.of(context).pushNamedAndRemoveUntil(
           "/landingpage", (Route<dynamic> route) => false);
     } else {
       print("error Logout");
     }
   }).catchError((e) {
     print("Error: $e");
   });
 }


 /// Forget Password
 static Future<void> forgetPassword(String newPassword,BuildContext context) async {
   String token = await StoreTokenProvider().getToken();
   String fcmToken =  Provider.of<StoreTokenProvider>(context,listen:false).fcmTokens;
   var url = Uri.parse("$API_URL/reset");
   await http.post(url, headers: {
     'Accept': 'application/json; charset=UTF-8',
     'Authorization': 'Bearer $token',
   }, body: {

     'fcm_token': fcmToken,
     'password' : newPassword,
   }).then((response) {
     print('Response status : ${response.statusCode}');
     print('Response status : ${response.body}');
     print('fcm : $fcmToken');
     if (response.statusCode == 200 || response.statusCode == 201) {
       print("Reset Password Success");


     } else {
       print("error Reset Password");
     }
   }).catchError((e) {
     print("Error: $e");
   });
 }
}