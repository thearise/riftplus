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
import 'package:riftplus02/screens/screen_one_route/runesdetail_route.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';

import '../../apptheme.dart';
import '../../fintness_app_theme.dart';
// import '../homescreen.dart';
// import '../testscreen.dart';
import 'itemsdetail_route.dart';


class Rune {
  final String id;
  final String rune_type;
  final String rune_name;
  final String rune_name2;
  final String rune_pros;
  final String rune_image;
  final String rune_video;

  Rune({this.id, this.rune_type, this.rune_name, this.rune_name2, this.rune_pros, this.rune_image, this.rune_video});

  factory Rune.fromJson(Map<String, dynamic> json){
    return Rune(
        id: json['id'],
        rune_type: json['rune_type'],
        rune_name: json['rune_name'],
        rune_name2: json['rune_name2'],
        rune_pros: json['rune_pros'],
        rune_image: json['rune_image'],
        rune_video: json['rune_video']
    );
  }
}

class SeeAllRunesRoute extends StatefulWidget {
  const SeeAllRunesRoute({Key key, this.id, this.image, this.name, this.rune}) : super(key: key);
  final String id;
  final String image;
  final String name;
  final String rune;
  @override
  _SeeAllRunesRouteState createState() => _SeeAllRunesRouteState();
}

class _SeeAllRunesRouteState extends State<SeeAllRunesRoute>  with TickerProviderStateMixin{
  Future<List<Rune>> runes;
  void initState() {
    runes = fetchRuneResponse(widget.rune, widget.id);
    super.initState();
  }

  Future<List<Rune>> fetchRuneResponse(item, id) async{
    print('shwe shwe' + item);
    Map<String, dynamic> jsonObject = json.decode(item);
    Iterable list = jsonObject[id];
    var its = list.map((runes) => Rune.fromJson(runes)).toList();
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
                //stream: Firestore.instance.collection(widget.id.split('/')[0].trim()).document('1Nm0CocGp3Sm1wopTqP1').collection(widget.id.split('/')[1].trim()).snapshots(),
                future: runes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  return Padding(
                    padding: const EdgeInsets.only(top: 57.0),
                    child: Container(
                      color: AppTheme.priBgColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top:0.0,left: 10.0, right: 10.0, bottom: 5.0),
                        child: ListView(
                          children: <Widget>[
                            DataGridRow(snapshot),
                            SizedBox(height: 50,)
//                            ResponsiveGridRow(
//                              //children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
////                              children: snapshot.data.documents.map<Widget>((document) {
//////                                return new Text(document['name']);
//////                              }).toList(),
//
//                            ),
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
                          child: Padding(
                            padding: const EdgeInsets.only(right: 28.0),
                            child: Container(),
                          ),
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
                            child: CachedNetworkImage(
                                imageUrl: document.rune_image,
                                placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fadeInDuration: Duration(milliseconds: 100),
                                fadeOutDuration: Duration(milliseconds: 10),
                                fadeInCurve: Curves.bounceIn
                            )
                        ),
                      ),
                    ),
                    ResponsiveGridCol(
                      xs: 6,
                      md: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
//                          decoration: BoxDecoration(
//                              border: Border(
//                                  bottom: BorderSide(width: 1.0, color: AppTheme.lineColor)
//                              )),
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
                            child: Column(
                              children: [
                                Expanded(child:
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(document.rune_name,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(child:
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: Container(
                                          child: Text(document.rune_pros,
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: 0.3,
                                              color: AppTheme.activeIcon,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                      ),
                                    )
                                    ),
                                    Container(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: GestureDetector(
                                          onTap: () {
                                             Navigator.of(context).push(
                                                 MaterialPageRoute(
                                                     builder: (context) => RunesDetailRoute(id: document.id, image: document.rune_image, name: document.rune_name, name2: document.rune_name2, pros: document.rune_pros, video: document.rune_video))
                                             );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:1.0),
                                            child: Container(
                                              margin: EdgeInsets.all(0),
                                              padding: EdgeInsets.only(top:4, right:0, left:4, bottom:2),
//                                decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(100),
//                                    border: Border.all(width: 1, color: AppTheme.activeIcon)),
                                              child: Image(image: AssetImage('assets/images/system/detail-btn.png'), height: 25, width: 25),
//                                              child: Padding(
//                                                padding: const EdgeInsets.only(bottom:0.0),
//                                                child: Icon(
//                                                  RiftPlusIcons.detail_arrow,
//                                                  color: AppTheme.activeIcon,
//                                                  size: 15,
//                                                ),
////                                  child: Text('',
////                                    style: TextStyle(
////                                      fontFamily: 'spiegel',
////                                      fontWeight: FontWeight.w500,
////                                      fontSize: 12,
////                                      letterSpacing: 0.5,
////                                      color: AppTheme.labText,
////                                    ),
////                                  ),
//                                              ),
                                            ),
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
                      letterSpacing: 0,
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
