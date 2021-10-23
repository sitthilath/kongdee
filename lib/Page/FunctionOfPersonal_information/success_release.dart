
import 'package:buddhistauction/Model/success_release.dart';
import 'package:buddhistauction/Provider/BuddhistViewModel/buddhist_detail_view_model.dart';
import 'package:buddhistauction/Provider/FunctionOfPersonalInfoViewModel/success_release_view_model.dart';
import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final currencyFormat = new NumberFormat("#,###", "en_US");

class SuccessRelease extends StatefulWidget {
  @override
  _SuccessReleaseState createState() => _SuccessReleaseState();
}

class _SuccessReleaseState extends State<SuccessRelease> {

  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));

  SuccessReleaseViewModel _successReleaseViewModel;
  int currentPage=1;
  ScrollController _scrollController =new ScrollController();


  @override
  void initState() {

    _successReleaseViewModel = Provider.of<SuccessReleaseViewModel>(context,listen:false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _successReleaseViewModel.fetchSuccessRelease(currentPage);
    });

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(currentPage>=_successReleaseViewModel.buddhistListMeta.lastPage){
          print("isLastPage");

          _successReleaseViewModel.isLastPage=true;
        }else{
          currentPage++;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(mounted){
              _successReleaseViewModel.fetchSuccessRelease(currentPage);
            }
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _successReleaseViewModel.successReleaseList.clear();
    _scrollController.dispose();
    super.dispose();
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
        centerTitle: true,
        title: Text("ເຄື່ອງທີ່ປ່ອຍໄດ້", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromRGBO(255, 196, 39, 1),
      ),
      body: Consumer<SuccessReleaseViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Container(
                alignment: Alignment.centerLeft,
                child: Center(child: WidgetStatic.buildLoadingCat()));
          }

          return  RefreshIndicator(

            onRefresh: () async{
              currentPage=1;
              viewModel.successReleaseList.clear();
              await viewModel.fetchSuccessRelease(1);
            },
            child: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  children: [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Text("${viewModel.successReleaseList.length} ລາຍການ"),
                            ),
                            Spacer(),
                            Container(
                                child: IconButton(onPressed: (){
                                  viewModel.setIsGrid();
                                }, icon: Icon(viewModel.isGrid ?Icons.view_headline : Icons.apps))
                            ),
                          ],
                        ),

                      ),
                    ),
                    Divider(),
                    viewModel.successReleaseList.isNotEmpty
                        ?
                    buildFutureBuilder(viewModel)
                        :
                        Container()

                  ],
                ),
                viewModel.successReleaseList.isNotEmpty
                    ?
                Container()
                    :
                Container(child: Center(child: Text("ບໍ່ມີຂໍ້ມູນ",style: Theme.of(context).textTheme.headline6,)))

              ],
            ),
          );
        },

      ),
    );
  }

  Widget buildFutureBuilder(SuccessReleaseViewModel viewModel) {


       return Stack(
         children: [
           viewModel.isGrid == false?
           ListView.builder(
             physics: ClampingScrollPhysics(),
             shrinkWrap: true,
             itemCount: viewModel.successReleaseList.length,
             itemBuilder: (context, index) {
               return GestureDetector(
                 onTap: (){
                   Provider.of<BuddhistDetailViewModel>(context,listen:false).buddhistId=viewModel
                       .successReleaseList[index]
                       .id;
                   Navigator.of(context).pushNamed('/detailpage');
                 },
                 child: Container(
                   decoration: BoxDecoration(
                     border: Border(
                       top:  BorderSide(
                         width:index == 0 ? 0.5 : 0,
                         color:index == 0 ? Colors.grey:Colors.transparent,
                       ),
                       bottom: BorderSide(
                         width: 0.5,
                         color: Colors.grey,
                       ),
                     ),
                   ),
                   height: 100,
                   child: Row(
                     children: [
                       Container(
                         height: 100,
                         width: 100,
                         child:
                         CachedNetworkImage(
                           cacheManager: customCacheManager,
                           key: UniqueKey(),
                           imageUrl:
                           "${viewModel.successReleaseList[index].image[0]}",
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
                       Container(
                         padding: EdgeInsets.only(left:8.0,right:8.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(child: Text("${viewModel.successReleaseList[index].place}",style: TextStyle(color: Colors.grey,fontSize: 14),),),
                                 SizedBox(height: 10,),
                                 Container( width: MediaQuery.of(context).size.width-140,child: Text("${viewModel.successReleaseList[index].name}",style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis,),),

                               ],
                             ),
                             Spacer(),
                             Column(
                               children: [
                                 Container(child: Text("${currencyFormat.format(viewModel.successReleaseList[index].price)} Kip",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),),

                               ],
                             )
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               );
             },

           )
           :    GridView.builder(
             padding: EdgeInsets.only(left:12,right: 12),
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                 crossAxisSpacing: 12,
                 mainAxisSpacing: 12,
                 mainAxisExtent: 284,
                 crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
             shrinkWrap: true,
             physics: ClampingScrollPhysics(),
             itemCount:viewModel.successReleaseList.length,
             itemBuilder: (context, index) {
               return CardItemGrid(cardItem:viewModel.successReleaseList,index: index,);
             },
           ),
           viewModel.isLoadingPage ? Positioned(bottom:0,child: Container(width: MediaQuery.of(context).size.width,child: Center(child: WidgetStatic.buildLoadingCatSmall())))
               : Container(),
         ],
       );


  }
}

/// Class _CardItem ///////////////////////////////////////////////////////////////////////////
class CardItemGrid extends StatefulWidget {
  final List<SuccessReleaseData> cardItem;
  final int index;

  const CardItemGrid({Key key, @required this.cardItem, @required this.index})
      : super(key: key);

  @override
  _CardItemGridState createState() => _CardItemGridState();
}

class _CardItemGridState extends State<CardItemGrid> {


  static final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 15),
  ));




  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap:() {
          Provider.of<BuddhistDetailViewModel>(context, listen: false)
              .buddhistId = widget.cardItem[widget.index].id;
          print(
              "${Provider.of<BuddhistDetailViewModel>(context, listen: false).buddhistId}");
          print("${widget.index}");
          Navigator.of(context).pushNamed('/detailpage');
        },
        child:Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              border: Border.all(
                  color: Colors.grey.withOpacity(0.5)
              )
          ),
          width: 162,
          height: 284,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 137,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: CachedNetworkImage(
                        cacheManager: customCacheManager,
                        key: UniqueKey(),
                        imageUrl:
                        "${widget.cardItem[widget.index].image[0]}",
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
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FittedBox(
                            child: Text(
                              '${widget.cardItem[widget.index].place == "ນະຄອນຫຼວງວຽງຈັນ" ? "ນວຈ" : widget.cardItem[widget.index].place}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.cardItem[widget.index].name,
                        style: TextStyle(fontSize: 18),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Container( padding: EdgeInsets.only(left:8.0,bottom: 8.0),child: Text('${currencyFormat.format(widget.cardItem[widget.index].price)} Kip',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
            ],
          ),
        )

      ),
    );
  }
}