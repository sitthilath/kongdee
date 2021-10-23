
import 'package:buddhistauction/Model/user.dart';
import 'package:buddhistauction/Provider/argument_owner.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';


class ProfileOwner extends StatefulWidget {
  @override
  _ProfileOwnerState createState() => _ProfileOwnerState();
}

class _ProfileOwnerState extends State<ProfileOwner> {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));


@override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text("ລາຍລະອຽດຜູ້ປ່ອຍ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
      ),
      body: FutureBuilder<User>(
      future: ServiceApi.fetchOwner("${Provider.of<ArgumentOwner>(context,listen:false).ownerId}"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return Container(
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
                              imageSelected(snapshot.data.data.picture),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data.data.name+" "+snapshot.data.data.surname,
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
                                snapshot.data.data.phoneNumber,
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
            }else{
              return Center(child: CircularProgressIndicator());
            }



          }),
    );
  }

  Widget imageSelected(String imageProfile) {
    return CircleAvatar(
        radius: 90,
        backgroundImage:
        CachedNetworkImageProvider(
          "$imageProfile",
          cacheManager: customCacheManager,


        ),);
  }
}
