import 'package:buddhistauction/Comment/content_detail.dart';
import 'package:buddhistauction/Comment/list_replies.dart';
import 'package:buddhistauction/Page/Auth/ForgetPassword/forget_password_page.dart';
import 'package:buddhistauction/Page/Auth/ForgetPassword/new_password_page.dart';
import 'package:buddhistauction/Page/Auth/ForgetPassword/otppage_forget_password.dart';
import 'package:buddhistauction/Page/DetailPage/bidder_list.dart';
import 'package:buddhistauction/Page/FunctionOfPersonal_information/fail_release.dart';
import 'package:buddhistauction/Page/FunctionOfPersonal_information/item_releasing.dart';
import 'package:buddhistauction/Page/FunctionOfPersonal_information/lose_auction.dart';
import 'package:buddhistauction/Page/FunctionOfPersonal_information/win_auction.dart';
import 'package:buddhistauction/Page/ReleaseBuddhist/first_page.dart';
import 'package:buddhistauction/Page/ReleaseBuddhist/fourth_page.dart';
import 'package:buddhistauction/Page/ReleaseBuddhist/second_page.dart';
import 'package:buddhistauction/Page/ReleaseBuddhist/third_page.dart';
import 'package:buddhistauction/Page/bidding_result_detail.dart';
import 'package:buddhistauction/Page/homepage.dart';
import 'package:buddhistauction/Page/landingpage.dart';

import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_recommend_view_model.dart';
import 'package:buddhistauction/Provider/FavoriteViewModel/favorite_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/fail_release_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/item_releasing_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/lose_auction_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/success_release_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/win_auction_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_bidding_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_message_view_model.dart';
import 'package:buddhistauction/Provider/NotificationViewModel/notification_result_bidding_view_model.dart';
import 'package:buddhistauction/Provider/StoreData/store_otp_number.dart';
import 'package:buddhistauction/Provider/StoreData/store_recent_search.dart';
import 'package:buddhistauction/Provider/StreamProvider/price.dart';
import 'package:buddhistauction/Provider/audio_players.dart';
import 'package:buddhistauction/Provider/bidding_result_detail_view_model.dart';
import 'package:buddhistauction/Provider/argument_owner.dart';
import 'package:buddhistauction/Provider/owner_view_model.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';


import 'Page/Auth/Register/success_register.dart';
import 'Page/FunctionOfPersonal_information/item_auctioning.dart';
import 'Provider/BuddhistViewModel/buddhist_type_view_model.dart';
import 'Provider/BuddhistViewModel/buddhist_view_model.dart';
import 'Provider/AuthVerifyPhoneOTP/forget_password_otp.dart';
import 'package:buddhistauction/Provider/notification_count.dart';

import 'Page/Auth/Login/loginpage.dart';
import 'Page/Auth/Login/otppage_login.dart';
import 'Page/Auth/Register/otppage_register.dart';
import 'package:buddhistauction/Page/type_list_item_page.dart';
import 'package:buddhistauction/Profile/profile_owner.dart';
import 'package:buddhistauction/Profile/profile_user.dart';
import 'package:buddhistauction/Provider/argument_comment.dart';
import 'package:buddhistauction/Provider/countdown.dart';
import 'Provider/AuthVerifyPhoneOTP/login_otp.dart';
import 'Provider/AuthVerifyPhoneOTP/register_otp.dart';

import 'Provider/FunctionOfPersonalInfoViewModel/item_auctioning_view_model.dart';
import 'Provider/StoreData/store_release_buddhist.dart';
import 'Provider/StoreData/store_text_forget_password.dart';
import 'Provider/StoreData/store_text_login.dart';
import 'Provider/StoreData/store_text_register.dart';
import 'Provider/StoreData/store_token.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';

import 'Page/FunctionOfPersonal_information/item_follow.dart';
import 'Page/FunctionOfPersonal_information/success_release.dart';
import 'Page/DetailPage/detailpage.dart';
import 'Page/Auth/Register/registerpage.dart';
import 'Provider/switch_showbottom.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//
//   print('Handling a background message ${message.messageId}');
//   print(message.notification.title);
//   print(message.notification.body);
//   print(message.data['sender']);
//
//
// }

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,

  );

  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher_logo_foreground");
  const IOSInitializationSettings iosInitializationSettings =
      IOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => OwnerViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => BuddhistRecommendViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => StoreRecentSearch(),
          ),
          ChangeNotifierProvider(
            create: (_) => Price(),
          ),
          ChangeNotifierProvider(
            create: (_) => StoreOtpNumber(),
          ),
          ChangeNotifierProvider(
            create: (_) => StoreTextForgetPasswordProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ItemAuctioningViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => BiddingResultDetailViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => BuddhistDetailViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => ArgumentOwner(),
          ),
          ChangeNotifierProvider(
            create: (_) => AudioPlayers(),
          ),
          ChangeNotifierProvider(
            create: (_) => FavoriteViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => ItemReleasingViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => SuccessReleaseViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => FailReleaseViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => LoseAuctionViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => WinAuctionViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => NotificationMessageViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => NotificationResultBiddingViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => NotificationBiddingViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => BuddhistViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => BuddhistTypeViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => AutoAuctionProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => SelectSendingProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => NotificationIfHasSomeoneAuctionMoreProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => RegisterOTPProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => StoreTextRegisterProvider(),
          ),
          ChangeNotifierProvider(create: (_) => StoreReleaseBuddhistProvider()),
          ChangeNotifierProvider(create: (_) => StoreTokenProvider()),
          ChangeNotifierProvider(create: (_) => LoginOTPProvider()),
          ChangeNotifierProvider(create: (_) => StoreTextLoginProvider()),
          ChangeNotifierProvider(create: (_) => CountDownProvider()),
          ChangeNotifierProvider(create: (_) => ArgumentComment()),
          ChangeNotifierProvider(create: (_) => ForgetPasswordOTPProvider()),
          ChangeNotifierProvider(create: (_) => NotificationCountProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', "US"),
            const Locale('th', "TH"),
            const Locale('lo', "LA"),
          ],

          theme: ThemeData(fontFamily: 'boonhome'),
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          routes: {

            "/bidder_list":(context)=>BidderList(),
            "/success_register":(context)=>SuccessRegister(),
            "/landingpage": (context) => LandingPage(),
            '/homepage': (context) => HomePage(),
            "/registerpage": (context) => RegisterPage(),
            "/loginpage": (context) => LoginPage(),
            '/detailpage': (context) => DetailPage(),
            '/otppageregister': (context) => OTPPageRegister(),
            '/otppagelogin': (context) => OTPPageLogin(),
            '/typelistitempage': (context) => TypeListItemPage(),
            "/first_page": (context) => FirstPage(),
            "/second_page": (context) => SecondPage(),
            "/third_page": (context) => ThirdPage(),
            "/fourth_page": (context) => FourthPage(),
            "/profile_user": (context) => ProfileUser(),
            "/content_detail": (context) => ContentDetail(),
            "/listreplies": (context) => ListReplies(),
            "/profile_owner": (context) => ProfileOwner(),
            "/item_follow": (context) => ItemFollow(),
            "/forgetpasswordpage": (context) => ForgetPassword(),
            "/otppageforgetpassword": (context) => OTPPageForgetPassword(),
            "/newpasswordpage": (context) => NewPassword(),
            "/win_auction": (context) => WinAuction(),
            "/lose_auction": (context) => LoseAuction(),
            "/success_release": (context) => SuccessRelease(),
            "/fail_release": (context) => FailRelease(),
            "/item_releasing": (context) => ItemReleasing(),
            "/item_auctioning": (context) => ItemAuctioning(),
            "/bidding_result_detail": (context) => BiddingResultDetail(),

          },
        ));
  }

}


