import 'dart:convert';
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';
import '../../apptheme.dart';
import '../../fintness_app_theme.dart';
// import '../homescreen.dart';
// import '../testscreen.dart';
import 'itemsdetail_route.dart';


class Item {
  final String id;
  final String item_type;
  final String item_lv;
  final String item_name;
  final String item_name2;
  final String item_price;
  final String item_image;
  final String item_video;

  Item({this.id, this.item_type, this.item_lv, this.item_name, this.item_name2, this.item_price, this.item_image, this.item_video});

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
        id: json['id'],
        item_type: json['item_type'],
        item_lv: json['item_lv'],
        item_name: json['item_name'],
        item_name2: json['item_name2'],
        item_price: json['item_price'],
        item_image: json['item_image'],
        item_video: json['item_video']
    );
  }
}

class SeeAllRoute extends StatefulWidget {
  const SeeAllRoute({Key key, this.id, this.image, this.name, this.item}) : super(key: key);
  final String id;
  final String image;
  final String name;
  final String item;

  @override
  _SeeAllRouteState createState() => _SeeAllRouteState();
}

class _SeeAllRouteState extends State<SeeAllRoute>  with TickerProviderStateMixin{
  Future<List<Item>> items;
  void initState() {
    items = fetchItemResponse(widget.item, widget.id);
    super.initState();
  }

  Future<List<Item>> fetchItemResponse(item, id) async{
    print('shwe shwe' + item);
    Map<String, dynamic> jsonObject = json.decode(item);
    Iterable list = jsonObject[id];
    var its = list.map((items) => Item.fromJson(items)).toList();
    return its;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: AppTheme.secBgColor,
        body: SafeArea(
          top: true,
          child: Stack(
            children: <Widget>[
              appBar(),
              FutureBuilder(
                future: items,
                //stream: Firestore.instance.collection('items').document(widget.id.split('/')[0].trim()).collection(widget.id.split('/')[1].trim()).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  return Padding(
                    padding: const EdgeInsets.only(top: 57.0),
                    child: Container(
                      color: AppTheme.priBgColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top:0.0,left: 10.0, right: 10.0, bottom: 5.0),
//                         child: ListView.builder(
//                           itemCount: snapshot.data.length,
//                           itemBuilder: (context, index) {
//                             ResponsiveGridRow responsiveGridRow = ResponsiveGridRow(children: []);
//                             snapshot.data.documents.map<Widget>((document) {
//                               responsiveGridRow.children.add(
//                                   ResponsiveGridCol(
//                                     xs: 6,
//                                     md: 3,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) => ItemsDetailRoute(id: document['id'],image: document['image'], name: document['name'], desc: document['desc'], price: document['price'], type: document['type']))
//                                         );
//                                       },
//                                       child: Container(
//                                         color: AppTheme.priBgColor,
//                                         child: ResponsiveGridRow(
//                                           children: [
//                                             ResponsiveGridCol(
//                                               xs: 6,
//                                               md: 6,
//                                               child: Container(
//                                                 height: 100,
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(left: 10, right: 20),
//                                                   child: Image(
//                                                     image: NetworkImage(document['image']),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             ResponsiveGridCol(
//                                               xs: 6,
//                                               md: 6,
//                                               child: Container(
//                                                 height: 100,
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
//                                                   child: Column(
//                                                     children: [
//                                                       Expanded(child:
//                                                       Align(
//                                                         alignment: Alignment.topLeft,
//                                                         child: Text(document['name'],
//                                                           textAlign: TextAlign.start,
//                                                           style: TextStyle(
//                                                             fontFamily: 'spiegel',
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 15,
//                                                             letterSpacing: 0.5,
//                                                             color: AppTheme.labTextActive,
//                                                           ),
//                                                         ),
//                                                       )
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Expanded(child:
//                                                           Text(document['price'],
//                                                             style: TextStyle(
//                                                               fontFamily: 'spiegel',
//                                                               fontWeight: FontWeight.w500,
//                                                               fontSize: 15,
//                                                               letterSpacing: 0.5,
//                                                               color: AppTheme.activeIcon,
//                                                             ),
//                                                           )
//                                                           ),
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               Navigator.of(context).push(
//                                                                   MaterialPageRoute(
//                                                                       builder: (context) => ItemsDetailRoute(id: document['id'],image: document['image'], name: document['name'], desc: document['desc'], price: document['price'], type: document['type']))
//                                                               );
//                                                             },
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.only(top:1.0),
//                                                               child: Container(
//                                                                 margin: EdgeInsets.all(0),
//                                                                 padding: EdgeInsets.only(top:4, right:0, left:4, bottom:4),
// //                                decoration: BoxDecoration(
// //                                    borderRadius: BorderRadius.circular(100),
// //                                    border: Border.all(width: 1, color: AppTheme.activeIcon)),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(bottom:0.0, top: 2.0),
// //                                      child: Icon(
// ////                                        RiftPlusIcons.detail_arrow,
// ////                                        color: AppTheme.activeIcon,
// ////                                        size: 15,
// ////                                      ),
//                                                                   child: Image(image: AssetImage('assets/images/system/detail-btn.png'), height: 25, width: 25),
// //                                  child: Text('',
// //                                    style: TextStyle(
// //                                      fontFamily: 'spiegel',
// //                                      fontWeight: FontWeight.w500,
// //                                      fontSize: 12,
// //                                      letterSpacing: 0.5,
// //                                      color: AppTheme.labText,
// //                                    ),
// //                                  ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ));
//                             }).toList();
//                             return responsiveGridRow;
//                           },
//                         ),
                        child: ListView(
                          children: <Widget>[
                            DataGridRow(snapshot),
                            SizedBox(height: 50,)
                          ],

                        ),
                      ),
                    ),
                  );
                },
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Platform.isIOS? AdmobBanner(
              //     adUnitId: getBannerAdUnitId(),
              //     adSize: AdmobBannerSize.SMART_BANNER(context),
              //   ): AdmobBanner(
              //     adUnitId: getBannerAdUnitId(),
              //     adSize: AdmobBannerSize.ADAPTIVE_BANNER(
              //       width: MediaQuery.of(context)
              //           .size
              //           .width
              //           .toInt(), // considering EdgeInsets.all(20.0)
              //     ),
              //   ),
              // )


              Align(
                alignment: Alignment.bottomCenter,
                child: Container(

                  width: MediaQuery.of(context).size.width,
                  child: Platform.isIOS? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 47,
                    // color: AppTheme.thirdBgColor,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      // UnityAds.isReady(placementId: 'video_placement_id');
                      //             child: CustomUnityBanner('Banner_iOS'),
                      child: Transform.translate(
                        offset: Offset(-141, 5),
                        child: Transform.scale(
                          scale: 0.8,
                          child: Container(),
                        ),
                      ),
                    ),
                  ): Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 47,
                    // color: AppTheme.thirdBgColor,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.translate(
                        offset: Offset(0, -7),
                        child: Transform.scale(
                          scale: 1.29,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5851001553018666/2287026456';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5851001553018666/2854836810';
    }
    return null;
  }

  DataGridRow(snapshot) {
    ResponsiveGridRow responsiveGridRow = ResponsiveGridRow(children: []);
    snapshot.data.map<Widget>((document) {
      responsiveGridRow.children.add(
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            //     MaterialPageRoute(
            //         builder: (context) => ItemsDetailRoute(id: document['id'],image: document['image'], name: document['name'], desc: document['desc'], price: document['price'], type: document['type']))
            // );
          },
          child: Container(
            color: AppTheme.priBgColor,
            child: ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  xs: 6,
                  md: 6,
                  child: Container(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      // child: FadeInImage.assetNetwork(
                      //   placeholder: 'assets/images/system/black-square.png',
                      //   fadeInDuration: Duration(milliseconds: 10),
                      //   image: document.item_image,
                      // ),
                      child: CachedNetworkImage(
                          imageUrl: document.item_image,
                          placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 10),
                          fadeInCurve: Curves.bounceIn
                      )
                      // child: Container(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  xs: 6,
                  md: 6,
                  child: Container(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
                      child: Column(
                        children: [
                          Expanded(child:
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(document.item_name,
                              textAlign: TextAlign.start,
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontFamily: 'spiegel',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 0.3,
                                color: AppTheme.labTextActive,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )
                          ),
                          Row(
                            children: [
                              Expanded(child:
                              Text(document.item_price,
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontFamily: 'spiegel',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  letterSpacing: 0.3,
                                  color: AppTheme.activeIcon,
                                ),
                              )
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ItemsDetailRoute(id: document.id,image: document.item_image, name: document.item_name, name2: document.item_name2, price:document.item_price, type: document.item_type, video: document.item_video))
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top:1.0),
                                  child: Container(
                                    margin: EdgeInsets.all(0),
                                    padding: EdgeInsets.only(top:4, right:0, left:4, bottom:4),
//                                decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(100),
//                                    border: Border.all(width: 1, color: AppTheme.activeIcon)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom:0.0, top: 2.0),
//                                      child: Icon(
////                                        RiftPlusIcons.detail_arrow,
////                                        color: AppTheme.activeIcon,
////                                        size: 15,
////                                      ),
                                    child: Image(image: AssetImage('assets/images/system/detail-btn.png'), height: 25, width: 25),
//                                  child: Text('',
//                                    style: TextStyle(
//                                      fontFamily: 'spiegel',
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 12,
//                                      letterSpacing: 0.5,
//                                      color: AppTheme.labText,
//                                    ),
//                                  ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }).toList();
    return responsiveGridRow;
  }


  Widget appBar() {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.secBgColor,
          border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 1.0))
      ),
      child: SizedBox(
        height: AppBar().preferredSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                color: Colors.transparent,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      RiftPlusIcons.back,
                      color: AppTheme.activeIcon,
                      size: 22,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    widget.name.toUpperCase(),
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontFamily: 'beaufortforlol',
                      fontSize: 21,
                      color: AppTheme.lightText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }





}

