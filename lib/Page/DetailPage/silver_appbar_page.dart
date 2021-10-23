import 'package:buddhistauction/Model/buddhist_detail.dart';
import 'package:buddhistauction/Page/DetailPage/view_image.dart';

import 'package:buddhistauction/Service/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


class SliverAppBarPage extends StatefulWidget {

  final List<BuddhistDetailData> buddhistDetailList;

  const SliverAppBarPage({Key key, this.buddhistDetailList}) : super(key: key);

  @override
  _SliverAppBarPageState createState() => _SliverAppBarPageState();
}

class _SliverAppBarPageState extends State<SliverAppBarPage> {
  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));



  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.deepOrange,
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
          background: Swiper(
            itemCount: widget.buddhistDetailList[0].image.length,
            itemBuilder: (BuildContext ctx, int idx) =>
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ViewImage(
                        image:  widget.buddhistDetailList[0].image,
                      );
                    }));
                  },
                  child: CachedNetworkImage(
                    cacheManager: customCacheManager,
                    key: UniqueKey(),
                    imageUrl:
                    "${widget.buddhistDetailList[0].image[idx]}",
                    fit: BoxFit.cover,
                    // maxHeightDiskCache: 75,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
            autoplay: true,
            pagination: SwiperPagination(),

          )),
      actions: [

        widget.buddhistDetailList[0].favorite != 2? FavoriteButton(
          isFavorite: widget.buddhistDetailList[0].favorite == 1
              ? true
              : false,
          valueChanged: (_isFavorite) {
            if (_isFavorite == true) {
              print("ok");
              ServiceApi.favorite(
                  widget.buddhistDetailList[0].id.toString(), context);
            } else {
              print("not");
              ServiceApi.favorite(
                  widget.buddhistDetailList[0].id.toString(), context);
            }

            print('Is Favorite : $_isFavorite');
          },
        )  : Container(),


      ],
      leading: Card(
        color: Colors.transparent,
        shape: CircleBorder(),
        shadowColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          }
        ),
      ),
    );
  }
}
