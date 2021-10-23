import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_message_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_result_bidding_view_model.dart';
import 'package:buddhistauction/Provider/StoreData/store_token.dart';
import 'package:buddhistauction/Provider/notification_count.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/Service/service_alert.dart';
import 'package:buddhistauction/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Bottom_Homepage/bottom_follow.dart';
import 'Bottom_Homepage/bottom_notification.dart';
import 'Bottom_Homepage/bottom_profile.dart';
import 'Bottom_Homepage/bottom_search.dart';



class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {

  UserViewModel _userViewModel;

  String messageTitle = "";
  String notificationAlert = "";

  String typeNotification = "";
  String resultNotification="";

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> showNotification(
      String messageTitle, String notificationAlert) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'test_notification', 'Common', 'NotificationCommon',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ມີແຈ້ງເຕືອນຈາກ ຂອງດີ',
        showWhen: false,
    icon: '@mipmap/ic_launcher_logo_foreground');

    NotificationDetails platformChannelDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, messageTitle, notificationAlert, platformChannelDetails);
  }

  void initFirebaseMessaging() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("message init = $message");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      final data = message.data;
      print("DATA: $data");
      print("sender: ${data["sender"]}");
      print("sender: ${data["sender"].runtimeType}");
      final notification = message.notification;
      messageTitle = notification.title;
      notificationAlert = notification.body;

      typeNotification = data["type"];
      resultNotification = data["result"];

      print(messageTitle);
      print(notificationAlert);
      print("senderID ="+data["sender"]);

      if(mounted){
        print("UID"+Provider.of<UserViewModel>(context, listen: false).userId.toString());

        if (data["sender"] == Provider.of<UserViewModel>(context, listen: false).userId.toString()) {
          //SenderID == User
          print("SenderID = ${data["sender"]}");
          print("userID: ${Provider.of<UserViewModel>(context, listen: false).userId.toString()}");
        } else {
          print("SenderID = br hu ${data["sender"]}");
          showNotification(messageTitle, notificationAlert);
          //SenderID != User
          if (typeNotification == "bidding") {
            Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationBidShow = true;
            Provider.of<NotificationCountProvider>(context, listen: false)
                .isNotificationShow = true;
            Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationBidBuddhistId = data["buddhist_id"];
            print("notificationBidBuddhistId: ${Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationBidBuddhistId}");
          } else if (typeNotification == "message") {
            Provider.of<NotificationMessageViewModel>(context, listen: false)
                .notificationMessShow = true;
            Provider.of<NotificationCountProvider>(context, listen: false)
                .isNotificationShow = true;
            Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationMessageBuddhistId = data["buddhist_id"];
          } else if (typeNotification == "chat") {

            Provider.of<NotificationMessageViewModel>(context, listen: false)
                .notificationMessShow = true;
            Provider.of<NotificationCountProvider>(context, listen: false)
                .isNotificationShow = true;
            Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationMessageBuddhistId = data["chat_room_id"];
            print(Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationMessageBuddhistId );
          }
          else if (typeNotification == "bidding_result") {
            Provider.of<NotificationResultBiddingViewModel>(context,
                listen: false)
                .notificationBidResultShow = true;
            Provider.of<NotificationCountProvider>(context, listen: false)
                .isNotificationShow = true;
            Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationBidResultBuddhistId = data["buddhist_id"];
            print("notificationBidResultBuddhistId: ${Provider.of<NotificationBiddingViewModel>(context, listen: false)
                .notificationBidResultBuddhistId = data["buddhist_id"]}");
            if(resultNotification == "win"){
              ServiceAlert.popupWin(context,data["buddhist_id"]);
            }else if(resultNotification == "lose"){
              ServiceAlert.popupLost(context,data["buddhist_id"]);
            }



          } else {

            if(resultNotification == "have_participant"){
              Provider.of<NotificationResultBiddingViewModel>(context,
                  listen: false)
                  .notificationBidResultShow = true;
              Provider.of<NotificationCountProvider>(context, listen: false)
                  .isNotificationShow = true;
              Provider.of<NotificationBiddingViewModel>(context, listen: false)
                  .notificationBidResultBuddhistId = data["buddhist_id"];
              print("notificationBidResultBuddhistId: ${Provider.of<NotificationBiddingViewModel>(context, listen: false)
                  .notificationBidResultBuddhistId = data["buddhist_id"]}");
              ServiceAlert.popupNewBuyer(context,data["buddhist_id"]);
            }else if(resultNotification == "no_participant"){
              ServiceAlert.popupNoBuyer(context);
            }
            print("Don't know type notification");
            print("type noti is: $typeNotification");
            print("DATA: $data");
          }
        }
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      final data = message.data;


      typeNotification = data["type"];

      if (typeNotification == "bidding") {
        Provider.of<NotificationBiddingViewModel>(context, listen: false)
            .notificationBidShow = true;
        Provider.of<NotificationCountProvider>(context, listen: false)
            .isNotificationShow = true;
        Provider.of<NotificationBiddingViewModel>(context, listen: false)
            .notificationBidBuddhistId = data["buddhist_id"];
      } else if (typeNotification == "message") {
        Provider.of<NotificationMessageViewModel>(context, listen: false)
            .notificationMessShow = true;
        Provider.of<NotificationCountProvider>(context, listen: false)
            .isNotificationShow = true;
        Provider.of<NotificationBiddingViewModel>(context, listen: false)
            .notificationMessageBuddhistId = data["buddhist_id"];
      }else if (typeNotification == "chat") {

        Provider.of<NotificationMessageViewModel>(context, listen: false)
            .notificationMessShow = true;
        Provider.of<NotificationCountProvider>(context, listen: false)
            .isNotificationShow = true;
        Provider.of<NotificationBiddingViewModel>(context, listen: false)
            .notificationMessageBuddhistId = data["chat_room_id"];
        print(Provider.of<NotificationBiddingViewModel>(context, listen: false)
            .notificationMessageBuddhistId );
      }

      else if (typeNotification == "bidding_result") {
        Provider.of<NotificationResultBiddingViewModel>(context, listen: false)
            .notificationBidResultShow = true;
        Provider.of<NotificationCountProvider>(context, listen: false)
            .isNotificationShow = true;
        Provider.of<NotificationBiddingViewModel>(context, listen: false)
            .notificationBidResultBuddhistId = data["buddhist_id"];

        if(resultNotification == "win"){
          ServiceAlert.popupWin(context,data["buddhist_id"]);
        }else{
          ServiceAlert.popupLost(context,data["buddhist_id"]);
        }
      } else {
        if(resultNotification == "have_participant"){
          Provider.of<NotificationResultBiddingViewModel>(context,
              listen: false)
              .notificationBidResultShow = true;
          Provider.of<NotificationCountProvider>(context, listen: false)
              .isNotificationShow = true;
          Provider.of<NotificationBiddingViewModel>(context, listen: false)
              .notificationBidResultBuddhistId = data["buddhist_id"];
          print("notificationBidResultBuddhistId: ${Provider.of<NotificationBiddingViewModel>(context, listen: false)
              .notificationBidResultBuddhistId = data["buddhist_id"]}");
          ServiceAlert.popupNewBuyer(context,data["buddhist_id"]);
        }else if(resultNotification == "no_participant"){
          ServiceAlert.popupNoBuyer(context);
        }
        print("Don't know type notification");
        print("type noti is: $typeNotification");
        print("DATA: $data");
      }
      Navigator.pushNamed(context, '/homepage');
    });

    // firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    firebaseMessaging.getToken().then((token) {
      assert(token != null);
      print("FCM Token : $token");
      Provider.of<StoreTokenProvider>(context, listen: false).setFcmTokens(token);
      print("FCM Token Provider: ${Provider.of<StoreTokenProvider>(context, listen: false).fcmTokens}");

    });
  }

  PageController _pageController = PageController();
  List<Widget> _screen = [
    BottomSearch(),
    BottomNotification(),
    BottomFollow(),
    BottomProfile(),
  ];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      if (index == 1) {
        Provider.of<NotificationCountProvider>(context, listen: false)
            .isNotificationShow = false;
        print(Provider.of<NotificationCountProvider>(context, listen: false)
            .isNotificationShow);
      }
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  void initState() {

    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    scheduler.SchedulerBinding.instance.addPostFrameCallback((_) {
      _userViewModel.fetchUser(context);

        initFirebaseMessaging();


    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            children: _screen,
            onPageChanged: _onPageChanged,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'ຄົ້ນຫາ',
            ),
            BottomNavigationBarItem(
              icon: new Stack(children: <Widget>[
                new Icon(Icons.notifications),
                Consumer<NotificationCountProvider>(
                    builder: (context, value, child) => Positioned(
                        // draw a red marble
                        top: 0.0,
                        right: 0.0,
                        child: value.isNotificationShow == true
                            ? Icon(Icons.brightness_1,
                                size: 8.0, color: Colors.redAccent)
                            : SizedBox())),
              ]),
              label: 'ແຈ້ງເຕືອນ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'ຕິດຕາມ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'ຂໍ້ມູນສ່ວນໂຕ',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 184, 133, 13),
          onTap: _onItemTapped,
        ));
  }

  @override
  bool get wantKeepAlive => true;

//BottomSearch Method

}
