import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riftplus02/icon_fonts/rift_plus_icons_icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/items_physical_api.dart';
import 'package:riftplus02/screens/screen01_01.dart';
import 'package:riftplus02/screens/screen_one_route/championRouteTab1.dart';

import '../apptheme.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.id, this.video, this.image, this.name}) : super(key: key);
  final String id;
  final String video;
  final String image;
  final String name;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    Tab(text: 'auto short'),
    Tab(text: 'auto long'),
    Tab(text: 'fixed'),
  ];
  TabController _tabController;
  ScrollController _scrollController;
  bool fixedScroll = false;

  Widget _buildCarousel() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 21.5, bottom: 10, left: 20, right: 10),
          child: Center(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.borderColor, width: 1),
                      top: BorderSide(color: AppTheme.borderColor, width: 1),
                      left: BorderSide(color: AppTheme.borderColor, width: 1),
                      right: BorderSide(color: AppTheme.borderColor, width: 1),
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image(
                    image: NetworkImage(widget.image),
                    width: 120,
                    height: 120,
                  ),
                ),
              )
          ),
        ),
        Expanded(
          child: FutureBuilder<Infos>(
              future: infos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 20, right: 10),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  child: RichText(
                                    textScaleFactor: 1.0,
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.body1,
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 5.0, bottom: 1),
                                            child: Icon(
                                              RiftPlusIcons.artboard___36,
                                              color: AppTheme.blueAccent,
                                              size: 17,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: snapshot.data.blue_motes.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'spiegel',
                                            fontSize: 19,
                                            color: AppTheme
                                                .labTextActive,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0, right: 5.0, bottom: 1),
                                            child: Icon(
                                              RiftPlusIcons.wild_cores,
                                              color: AppTheme.wildCores,
                                              size: 17,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: snapshot.data.wild_cores,
                                          style: TextStyle(
                                            fontFamily: 'spiegel',
                                            fontSize: 19,
                                            color: AppTheme
                                                .labTextActive,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 10),
                            child: Container(
                              child: Row(
                                children: [
                                  snapshot.data.main_role.contains('fighter')?
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      RiftPlusIcons.fighter,
                                      size: 22,
                                      color: AppTheme.activeIcon,
                                    ),
                                  ):SizedBox(),
                                  snapshot.data.main_role.contains('tank')?
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      RiftPlusIcons.tank,
                                      size: 22,
                                      color: AppTheme.activeIcon,
                                    ),
                                  ):SizedBox(),
                                  snapshot.data.main_role.contains('mage')?
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      RiftPlusIcons.mage,
                                      size: 22,
                                      color: AppTheme.activeIcon,
                                    ),
                                  ):SizedBox(),
                                  snapshot.data.main_role.contains('assassin')?
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      RiftPlusIcons.assasin,
                                      size: 22,
                                      color: AppTheme.activeIcon,
                                    ),
                                  ):SizedBox(),
                                  snapshot.data.main_role.contains('support')?
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      RiftPlusIcons.support,
                                      size: 22,
                                      color: AppTheme.activeIcon,
                                    ),
                                  ):SizedBox(),
                                  snapshot.data.main_role.contains('marksman')?
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      RiftPlusIcons.marksman,
                                      size: 22,
                                      color: AppTheme.activeIcon,
                                    ),
                                  ):SizedBox(),
//                                                CircleAvatar(
//                                                  radius: 12,
//                                                  backgroundColor: Color(0xffFDCF09),
//                                                  child: CircleAvatar(
//                                                    radius: 11,
//                                                    child: Icon(RiftPlusIcons.items, size: 17, color: AppTheme.activeIcon,),
//                                                  ),
//                                                )
//                                              Image.asset(
//                                                'assets/images/system/back_icon.png',
//                                                height: 45,
//                                              ),
//                                              Image.asset(
//                                                'assets/images/system/back_icon.png',
//                                                height: 45,
//                                              ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 6.0),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Utility',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 12,
                                                color: AppTheme
                                                    .labTextActive,
                                                letterSpacing: 0,
                                              ),
                                              textAlign: TextAlign
                                                  .left,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0,
                                                    right: 5.0),
                                                child: Container(
                                                  color: int.parse(snapshot.data.utility) >= 1? AppTheme
                                                      .blueAccent: AppTheme.tranWhite,
                                                  height: 4.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0,
                                                    right: 5.0),
                                                child: Container(
                                                  color: int.parse(snapshot.data.utility) >= 2? AppTheme
                                                      .blueAccent: AppTheme.tranWhite,
                                                  height: 4.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0,
                                                    right: 5.0),
                                                child: Container(
                                                  color: int.parse(snapshot.data.utility) >= 3? AppTheme
                                                      .blueAccent: AppTheme.tranWhite,
                                                  height: 4.5,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Toughness',
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  fontFamily: 'spiegel',
                                                  fontSize: 12,
                                                  color: AppTheme
                                                      .labTextActive,
                                                  letterSpacing: 0,
                                                ),
                                                textAlign: TextAlign
                                                    .left,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8.0,
                                                      right: 5.0),
                                                  child: Container(
                                                    color: int.parse(snapshot.data.toughness) >= 1? AppTheme
                                                        .blueAccent: AppTheme.tranWhite,
                                                    height: 4.5,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8.0,
                                                      right: 5.0),
                                                  child: Container(
                                                    color: int.parse(snapshot.data.toughness) >= 2? AppTheme
                                                        .blueAccent: AppTheme.tranWhite,
                                                    height: 4.5,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8.0,
                                                      right: 5.0),
                                                  child: Container(
                                                    color: int.parse(snapshot.data.toughness) >= 3? AppTheme
                                                        .blueAccent: AppTheme.tranWhite,
                                                    height: 4.5,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 6.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Damage',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 12,
                                                color: AppTheme
                                                    .labTextActive,
                                                letterSpacing: 0,
                                              ),
                                              textAlign: TextAlign
                                                  .left,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0,
                                                    right: 5.0),
                                                child: Container(
                                                  color: int.parse(snapshot.data.damage) >= 1? AppTheme
                                                      .blueAccent: AppTheme.tranWhite,
                                                  height: 4.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0,
                                                    right: 5.0),
                                                child: Container(
                                                  color: int.parse(snapshot.data.damage) >= 2? AppTheme
                                                      .blueAccent: AppTheme.tranWhite,
                                                  height: 4.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0,
                                                    right: 5.0),
                                                child: Container(
                                                  color: int.parse(snapshot.data.damage) >= 3? AppTheme
                                                      .blueAccent: AppTheme.tranWhite,
                                                  height: 4.5,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Difficulity',
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  fontFamily: 'spiegel',
                                                  fontSize: 12,
                                                  color: AppTheme
                                                      .labTextActive,
                                                  letterSpacing: 0,
                                                ),
                                                textAlign: TextAlign
                                                    .left,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8.0,
                                                      right: 5.0),
                                                  child: Container(
                                                    color: int.parse(snapshot.data.difficulty) >= 1? AppTheme
                                                        .yellowAccent: AppTheme.tranWhite,
                                                    height: 4.5,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8.0,
                                                      right: 5.0),
                                                  child: Container(
                                                    color: int.parse(snapshot.data.difficulty) >= 2? AppTheme
                                                        .yellowAccent: AppTheme.tranWhite,
                                                    height: 4.5,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8.0,
                                                      right: 5.0),
                                                  child: Container(
                                                    color: int.parse(snapshot.data.difficulty) >= 3? AppTheme
                                                        .yellowAccent: AppTheme.tranWhite,
                                                    height: 4.5,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                    child: CupertinoActivityIndicator(radius: 12,));
              }
          ),
        )
      ],
    );
  }

  Future<Infos> infos;
  Dio dio;
  @override
  void initState() {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    infos = fetchInfos(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      fixedScroll = _tabController.index == 2;
    });
  }

  _buildTabContext(int lineCount) => Container(
    child: ListView.builder(
      // physics: const ClampingScrollPhysics(),
      physics: const BouncingScrollPhysics(),
      itemCount: lineCount,
      itemBuilder: (BuildContext context, int index) {
        return Text('some content');
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secBgColor,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 58.0),
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(child: Container(color: AppTheme.priBgColor, child: _buildCarousel())),
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                            minHeight: 50.0,
                            maxHeight: 50.0,
                            child: Container(
                                color: AppTheme.priBgColor,
                                child: TabBar(
                                  labelColor: AppTheme.borderColor,
                                  unselectedLabelColor: AppTheme.labText,
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.lightText,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500
                                  ),
                                  indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(width: 1.0, color: AppTheme.borderColor),

                                  ),

                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'ABILITIES',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            fontFamily: 'roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        'PLAY STYLE',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            fontFamily: 'roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        'BUILDS',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            fontFamily: 'roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
//                              Tab(
//                                text: 'Builds',
//                              )
                                  ],
                                  controller: _tabController,
                                )
                            )
                        )
                    ),


                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [ChampionRouteTabOne(id: widget.id, video: widget.video), ChampionRouteTabOne(id: widget.id, video: widget.video), ChampionRouteTabOne(id: widget.id, video: widget.video)],
                ),
              ),
            ),
            appBar(),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
//    print(st);
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
                    //_connectionStatus,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontFamily: 'beaufortforlol',
                      fontSize: 21,
                      color: AppTheme.lightText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
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

  Future<Infos> fetchInfos(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getHeroDetailsById.php?id='+id);

    // Use the compute function to run parsePhotos in a separate isolate.
    print('HERE ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Infos.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }


}
class Infos {
  final String blue_motes;
  final String wild_cores;
  final String main_role;
  final String utility;
  final String toughness;
  final String damage;
  final String difficulty;

  Infos({this.blue_motes, this.wild_cores, this.main_role, this.utility, this.toughness, this.damage, this.difficulty});

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
        blue_motes: json['blue_motes'],
        wild_cores: json['wild_cores'],
        main_role: json['main_role'],
        utility: json['utility'],
        toughness: json['toughness'],
        damage: json['damage'],
        difficulty: json['difficulty']
    );
  }
}