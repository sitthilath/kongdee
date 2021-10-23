
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';

import 'package:buddhistauction/Service/service_api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:provider/provider.dart';


class BottomProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BottomProfileState();
  }
}

class _BottomProfileState extends State<BottomProfile>
    with AutomaticKeepAliveClientMixin {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("ຍົກເລີກ"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("ຕົກລົງ"),
      onPressed: () {
        ServiceApi.logout(context);

        print("out");

        Navigator.of(context).pop();

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ອອກຈາກລະບົບ"),
      content: Text("ທ່ານຕ້ອງການອອກຈາກລະບົບ ຫຼື ບໍ່?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


 UserViewModel _userViewModel;



  @override
  void initState() {

    _userViewModel = Provider.of<UserViewModel>(context,listen:false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _userViewModel.fetchUser(context);
    });



    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Scaffold(
      appBar: AppBar(

        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if(userViewModel.isLoading){
           return Center(child: WidgetStatic.buildLoadingCat(),);
         }else if( userViewModel.isUser == false ){
            return buildPageNotLogin();
          }

          return  RefreshIndicator(
            onRefresh: () => userViewModel.fetchUser(context),
            child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ຂໍ້ມູນຂອງຂ້ອຍ',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'boonhome'),
                      ),
                      //h20
                      buildSizedBoxHeight(20),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/profile_user");
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(

                                radius: 30,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                CachedNetworkImageProvider(
                                  "${userViewModel.userList
                                      .picture}",
                                  cacheManager: customCacheManager,


                                ),
                              ),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('ປະຫວັດ ແລະ ຂໍ້ມູນສ່ວນຕົວ'),
                                Text(
                                  "${userViewModel.userList.name}",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),

                      //h20
                      buildSizedBoxHeight(20),
                      buildDivider(),
                      //h20
                      buildSizedBoxHeight(20),
                      Text(
                        'ຂໍ້ມູນທີ່ຊື້',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      //h20
                      buildSizedBoxHeight(20),
                      InkWell(
                        onTap: () {Navigator.pushNamed(context, '/item_auctioning');},
                        child: Row(
                          children: [
                            Icon(
                              Icons.gavel,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //W10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ກຳລັງປະມູນ'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),

                      buildDivider(),

                      InkWell(
                        onTap: () {Navigator.pushNamed(context, '/item_follow');},
                        child: Row(
                          children: [
                            Icon(
                              Icons.work_outline,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //W10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ຕິດຕາມ'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),

                      buildDivider(),

                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/win_auction");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_emotions_outlined,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ປະມູນຊະນະ'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),
                      buildDivider(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/lose_auction");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.mood_bad_outlined,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ປະມູນເສຍ'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),
                      buildDivider(),
                      //h20
                      buildSizedBoxHeight(20),
                      Text(
                        'ຂໍ້ມູນທີ່ປ່ອຍ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      //h10
                      buildSizedBoxHeight(10),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Container(
                          height: 55,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),



                            onPressed:
                                () {
                              userViewModel.isUser == false
                                  ? Navigator.pushNamed(
                                  context, "/loginpage")
                                  :     Navigator.pushNamed(
                                  context, "/first_page");
                            },
                            child: FittedBox(
                              child: Text(
                                'ປ່ອຍເຄື່ອງ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //h20
                      buildSizedBoxHeight(20),

                      buildDivider(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/item_releasing");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.wallet_giftcard_sharp,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ປ່ອຍຢູ່ດຽວນີ້'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),
                      buildDivider(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/success_release");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ປ່ອຍໄດ້'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,

                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),
                      buildDivider(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/fail_release");
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.clear,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເຄື່ອງທີ່ປ່ອຍບໍ່ໄດ້'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),
                      buildDivider(),
                      InkWell(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 24,
                              color: Color.fromARGB(255, 184, 133, 13),
                            ),
                            //w10
                            buildSizedBoxWidth(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ອອກຈາກລະບົບ'),
                              ],
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.grey,
                            ),
                            //w20
                            buildSizedBoxWidth(20),
                          ],
                        ),
                      ),
                    ],
                  )

              ),
            ),
          );

        },
      ),
     floatingActionButton: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) =>

              Visibility(
                visible: userViewModel.isLoading ? false : true,
                child: FloatingActionButton(

                  elevation: 0.0,
                  heroTag: "heroTag3",
                  onPressed: () {
                    userViewModel.isUser == false
                        ? Navigator.pushNamed(
                        context, "/loginpage")
                        :     Navigator.pushNamed(
                        context, "/first_page");
                  },
                  child: const Icon(Icons.add,size: 28,),
                  backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                ),
              ),

    ),

    );
  }

  Divider buildDivider() => Divider();

  SizedBox buildSizedBoxHeight(double height) {
    return SizedBox(
                      height: height,
                    );
  }

  SizedBox buildSizedBoxWidth(double width) => SizedBox(width: width);

  Widget buildPageNotLogin(){
    return Container(
      height: MediaQuery.of(context).size.height,

      alignment: Alignment.topCenter,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Text("ທ່ານຍັງບໍ່ໄດ້ເຂົ້າສູ່ລະບົບ",style: TextStyle(fontSize: 20,color: Colors.grey[700]))),
          SizedBox(height: 10,),
          Container(child: Text("ກະລຸນາເຂົ້າສູ່ລະບົບ",style: TextStyle(fontSize: 12,color: Colors.grey[700]))),
          SizedBox(height: 20,),
          ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 196, 39, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.grey)),
              ),
              onPressed: (){
            Navigator.pushNamed(context, "/loginpage");
          }, child: Text("ເຂົ້າສູ່ລະບົບ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),))
        ],
      ),
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
