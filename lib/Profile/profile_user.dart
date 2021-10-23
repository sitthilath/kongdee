
import 'package:buddhistauction/Profile/edit_profile.dart';
import 'package:buddhistauction/Provider/user_view_model.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

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

   return Scaffold(
     floatingActionButton: FloatingActionButton(
       onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder:(context)=> EditProfile()));
       },
       child:  Icon(Icons.edit_outlined),
       backgroundColor: Color.fromRGBO(255, 196, 39, 1),
     ),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text("ໂປຣຟາຍ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),

      ),
      body:
               Consumer<UserViewModel>(
    builder: (context, userViewModel, child) {
      if(userViewModel.isLoading ==true){
        return Container(
            alignment: Alignment.center,
            child: WidgetStatic.buildLoadingCat());
      }
     return RefreshIndicator(
onRefresh: ()=>userViewModel.fetchUser(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(

                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color.fromRGBO(255, 196, 39, 1),Color.fromRGBO(255, 196, 39, 1)]
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageSelected(userViewModel.userList.picture),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          userViewModel.userList.name+" "+ userViewModel.userList.surname,
                          style:
                          TextStyle(fontFamily: 'boonhome', fontSize: 24,fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(

                      width: double.infinity,
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                      child: Text(
                        "ເບີໂທ:",
                        style:
                        TextStyle(fontFamily: 'boonhome', fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                      width: double.infinity,

                      child: Text(
                        userViewModel.userList.phoneNumber,
                        style: TextStyle(
                            fontFamily: 'boonhome', fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    },

               ),


    );
  }
  Widget imageSelected(String imageProfile) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 90,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 87,
        backgroundImage:
        CachedNetworkImageProvider(
      "$imageProfile",
        cacheManager: customCacheManager,


      ),

      ),
    );
  }

}
