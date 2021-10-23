import 'package:buddhistauction/Model/user.dart';

import 'package:buddhistauction/Provider/argument_owner.dart';
import 'package:buddhistauction/Service/service_api.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class OwnerInfo extends StatefulWidget {

  final int ownerId;

  const OwnerInfo({Key key, this.ownerId}) : super(key: key);
  @override
  _OwnerInfoState createState() => _OwnerInfoState();
}

class _OwnerInfoState extends State<OwnerInfo> {


  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: ServiceApi.fetchOwner("${widget.ownerId}"),
        builder: (context,snapshot) {
          if(snapshot.hasData){
            return InkWell(
              onTap: () {
                Provider.of<ArgumentOwner>(context,listen:false).ownerId = snapshot.data.data.id;
                Navigator.pushNamed(context, "/profile_owner",);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    NetworkImage('${snapshot.data.data.picture}'),
                  ),
                  //W10
                  buildSizedBoxWidth(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${snapshot.data.data.name}'),

                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey,
                  ),
                  //W20
                  buildSizedBoxWidth(20),
                ],
              ),
            );
          }else{
            return CircularProgressIndicator();
          }


        });
  }

SizedBox buildSizedBoxWidth(double width) {
return SizedBox(
width: width,
);
}
}
