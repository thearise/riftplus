import 'dart:convert';
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/screen_one_route/report_detail_page.dart';
import 'package:riftplus02/screens/screen_one_route/runesdetail_route.dart';
import 'package:riftplus02/screens/screen_one_route/spellsdetail_route.dart';
import 'package:toast/toast.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';
import '../../apptheme.dart';
import '../../fintness_app_theme.dart';
// import '../homescreen.dart';
// import '../testscreen.dart';
import '../app.dart';
import '../titleView.dart';
import 'itemsdetail_route.dart';

class Ads {
  final String type;

  Ads({this.type});

  factory Ads.fromJson(Map<String, dynamic> json){
    return Ads(
      type: json['type'],
    );
  }
}

class BaronLane extends StatefulWidget {
  const BaronLane({Key key, this.desc}) : super(key: key);
  final String desc;

  @override
  _BaronLaneState createState() => _BaronLaneState();
}

class _BaronLaneState extends State<BaronLane>  with TickerProviderStateMixin{

  Future<Ads> ads;
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  Dio dio;
  void initState() {

    AppState().increaseGloAdsInt(2);
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize without device test ids.
    // Admob.initialize();

    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    ads = fetchAds();
    super.initState();

    showVideo();
  }

  showVideo() async {
    var isReady = await Appodeal.isReadyForShow(AdType.NON_SKIPPABLE);
    var isReady1 = await Appodeal.isReadyForShow(AdType.INTERSTITIAL);
    var isReady2 = await Appodeal.isReadyForShow(AdType.REWARD);


    Toast.show(isReady1 ? 'INTERSTITIAL ad is ready' : 'INTERSTITIAL ad is NOT ready', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    Toast.show(isReady ? 'NON_SKIPPABLE ad is ready' : 'NON_SKIPPABLE ad is NOT ready', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);


    await Appodeal.show(AdType.NON_SKIPPABLE);
  }


  Future<Ads> fetchAds() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/mapLaneAds.php');

    // Use the compute function to run parsePhotos in a separate isolate.
    print('HERE ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Ads.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 57.0),
                    child: Container(
                      color: AppTheme.priBgColor,
//                   child: ListView.builder(
// //            padding: EdgeInsets.only(
// //              top: AppBar().preferredSize.height +
// //                  MediaQuery.of(context).padding.top +
// //                  24,
// //              bottom: 62 + MediaQuery.of(context).padding.bottom,
// //            ),
//                     itemCount: listViews.length,
//                     scrollDirection: Axis.vertical,
//                     itemBuilder: (BuildContext context, int index) {
//                       return listViews[index];
//                     },
//                   ),
                      child: ListView(
                        children: [
                          Image(image: AssetImage('assets/images/system/solo-pos-screen.png')),
                          TitleView(
                            titleTxt: 'Lanes and Roles Guide',
                            subTxt: '',
                            id: '',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 90.0, top: 15.0),
                            child: Text(
                              widget.desc,
                              textScaleFactor: 1,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'spiegel',
                                  color: AppTheme.labTextActive,
                                  height: 1.3
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder<Ads>(
                    future: ads,
                    builder: (context, snapshot) {
                      if(snapshot.hasData && snapshot.data.type.contains('bannerAndroid') && Platform.isAndroid) {
                        // return FacebookBannerAd(
                        //   placementId: Platform.isAndroid? '708437736767412_710375839906935': 'IMG_16_9_APP_INSTALL#258023022488835_261443095480161',
                        //   bannerSize: BannerSize.STANDARD,
                        //   listener: (result, value) {
                        //     print("Banner Ad: $result -->  $value");
                        //   },
                        // );
                        return Container();
                      } else if (snapshot.hasData && snapshot.data.type.contains('bannerIOS') && !Platform.isAndroid) {
                        return Align(
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
                                      child: Container()
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
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
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
                    'SOLO POSITION',
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
              padding: const EdgeInsets.only(top: 15, right: 8),
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
                      Icons.feedback,
                      color: AppTheme.activeIcon,
                      size: 23,
                    ),
                    onTap: () {
                      // reportDialog(context);
                      Navigator.of(context, rootNavigator:true).push(
                        FadeRoute(page: ReportDetailPage(name: 'solo position'),),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  modifyDesc(String abilityData) {
    TextSpan textSpan = TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: [
        ]
    );
    //final String answer = (faq['answer'] as String).replaceAll("\\n", "\n");
    //String abilityData = 'Ahri<phydmg>in the target<attspe>and<[txtye>fires projectiles to up to 3 visible targets<]txtye>.<phydmg>She can recast Spirit Rush twice within 10<phydmg>seconds at no additional cost.';
    //String abilityData = 'Ahri<phydmg>in the target and fires projectiles to up to 3 visible targets . She can recast Spirit Rush twice within 10 seconds at no additional cost.';
    //String abilityData = 'Ahri <phydmg> in the target direction and fires <attspd> projectiles to up to 3 visible targets. She can recast Spirit Rush twice within 10 seconds at no additional cost.';
    //String abilityData = 'Dashes forward and deals <[txtmd>60 magic damage<]txtmd> (60 + <[txtap> 35%<]txtap> <abipwr>) to 3 nearby enemies.\n\nCan be cast up to 3 times within 10 seconds before going on cooldown.\n\nDash distance increases with rank. Bolts priortize champions.';
    //    '\n\nCan be cast up to 3 times within 10 seconds before going on cooldown. '
    //    '\n\nDash distance increases with rank. Bolts priortize champions.';
    while(abilityData.indexOf('<') >=0) {
      var indexOfDef = abilityData.indexOf('<');
//      st += abilityData.substring(0, indexOfDef);
      textSpan.children.add(
        TextSpan(
          text: abilityData.substring(0, indexOfDef),
          style: TextStyle(
            fontFamily: 'spiegel',
            fontSize: 15,
            height: 1.4,
            color: AppTheme
                .labTextActive,
            letterSpacing: 0,
          ),
        ),
      );
      //print(abilityData.substring(abilityData.indexOf('<') + 8));
      if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<phydmg>') {
//        st += '(phydmg)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.physicaldamage,
                  color: AppTheme.physicalDamage,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<attspd>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.attackspeed,
                  color: AppTheme.attackSpeed,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<shdbrk>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.shieldbreak,
                  color: AppTheme.shieldBreak,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<speedy>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.speed,
                  color: AppTheme.speed,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<crtstk>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.criticalstrike,
                  color: AppTheme.criticalStrike,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<mgcpen>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.magicpenetration,
                  color: AppTheme.magicPenetration,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<shield>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.shield,
                  color: AppTheme.shield,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<mgcdmg>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.magicdamage,
                  color: AppTheme.magicDamage,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<abipwr>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.abilitypower,
                  color: AppTheme.abilityPower,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<health>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.health,
                  color: AppTheme.health,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<hthpls>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.healthplus,
                  color: AppTheme.healthPlus,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<mana01>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.mana_1,
                  color: AppTheme.mana,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<clddwn>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.cooldown,
                  color: AppTheme.coolDown,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<hthpls>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.shield,
                  color: AppTheme.shield,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<levlup>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.levelup,
                  color: AppTheme.speed,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<phyvmp>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.physicalvamp,
                  color: AppTheme.physicalvamp,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<mgcvmp>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.magicalvamp,
                  color: AppTheme.magicalvamp,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<energy>') {
//        st += '(someth)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Icon(
                  RiftPlusIcons.energy,
                  color: AppTheme.energy,
                  size: 15,
                ),
              ),
            )
        );
        abilityData = abilityData.substring(indexOfDef + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtsb>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtsb>') + 8, abilityData.indexOf('<]txtsb>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.shieldBreak,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtsb>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtsp>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtsp>') + 8, abilityData.indexOf('<]txtsp>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.speed,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtsp>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtcs>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtcs>') + 8, abilityData.indexOf('<]txtcs>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.criticalStrike,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtcs>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtmp>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtmp>') + 8, abilityData.indexOf('<]txtmp>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.magicPenetration,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtmp>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtsh>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtsh>') + 8, abilityData.indexOf('<]txtsh>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.shield,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtsh>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtmd>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtmd>') + 8, abilityData.indexOf('<]txtmd>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.magicDamage,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtmd>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtap>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtap>') + 8, abilityData.indexOf('<]txtap>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.abilityPower,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtap>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtht>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtht>') + 8, abilityData.indexOf('<]txtht>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.health,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtht>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtpd>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtpd>') + 8, abilityData.indexOf('<]txtpd>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.physicalDamage,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtpd>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtdd>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtdd>') + 8, abilityData.indexOf('<]txtdd>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.damageDamage,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtdd>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtmn>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtmn>') + 8, abilityData.indexOf('<]txtmn>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.mana,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtmn>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtcd>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtcd>') + 8, abilityData.indexOf('<]txtcd>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.coolDown,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtcd>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtas>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtas>') + 8, abilityData.indexOf('<]txtas>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.attackSpeed,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtas>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtwc>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtwc>') + 8, abilityData.indexOf('<]txtwc>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.wildCores,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtwc>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtmm>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtmm>') + 8, abilityData.indexOf('<]txtmm>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              height: 1.4,
              fontSize: 12,
              color: AppTheme.labText,
              letterSpacing: 0,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtmm>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtpv>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtpv>') + 8, abilityData.indexOf('<]txtpv>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.physicalvamp,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtpv>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtmv>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtmv>') + 8, abilityData.indexOf('<]txtmv>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.magicalvamp,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtmv>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txteg>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txteg>') + 8, abilityData.indexOf('<]txteg>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.energy,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txteg>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtiv>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtiv>') + 8, abilityData.indexOf('<]txtiv>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.4,
              color: AppTheme.invisibility,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtiv>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txth1>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txth1>') + 8, abilityData.indexOf('<]txth1>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 16,
              color: AppTheme.blueAccent,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txth1>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txthr>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txthr>') + 8, abilityData.indexOf('<]txthr>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              height: 0.5,
              fontSize: 16,
              color: AppTheme.blueAccent,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txthr>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtit>') {
        var inner = '';
        Future<Items> itemDetail1;
        inner += abilityData.substring(abilityData.indexOf('<[txtit>') + 8, abilityData.indexOf('<]txtit>'));
        itemDetail1 = fetchItemDetailsByName(inner, 'inside');
        // String image = 'https://hninsunyein.me/rift_plus/items/' + inner.split('~')[5] + '/' + inner.split('~')[1];
        textSpan.children.add(
            WidgetSpan(
                child: FutureBuilder(
                    future: itemDetail1,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ItemsDetailRoute(id: snapshot.data.id,image: snapshot.data.item_image, name: snapshot.data.item_name, name2: snapshot.data.item_other1, price: snapshot.data.item_other2, type: snapshot.data.item_other3, video: snapshot.data.item_video))
                            );
                          },
                          child: Tooltip(
                            verticalOffset: -69,
                            message: snapshot.data.item_name,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
                            textStyle: TextStyle(
                              fontFamily: 'beaufortforlol',
                              fontSize: 16,
                              height: 1.4,
                              color: AppTheme
                                  .coolDown,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border(
                                  bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                )
                            ),
                            child: CachedNetworkImage(
                              // imageUrl: 'https://hninsunyein.me/rift_plus/allinone/' + inner + '.png',
                              imageUrl: snapshot.data.item_image,
                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fadeInDuration: Duration(milliseconds: 100),
                              fadeOutDuration: Duration(milliseconds: 10),
                              fadeInCurve: Curves.bounceIn,
                              width: 19,
                              height: 19,
                            ),
                            //child: Text(inner, style: TextStyle(color: Colors.white))
                          ),
                        );
                      }
                      return Container();
                    }
                )
            )
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtit>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtsl>') {
        var inner = '';
        Future<Items> itemDetail1;
        inner += abilityData.substring(abilityData.indexOf('<[txtsl>') + 8, abilityData.indexOf('<]txtsl>'));
        itemDetail1 = fetchSpellDetailsByName(inner);
        // String image = 'https://hninsunyein.me/rift_plus/items/' + inner.split('~')[5] + '/' + inner.split('~')[1];
        textSpan.children.add(
            WidgetSpan(
                child: FutureBuilder(
                    future: itemDetail1,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SpellsDetailRoute(id: snapshot.data.id, image: snapshot.data.item_image, name: snapshot.data.item_name, cooldown: snapshot.data.item_other2, sugg: snapshot.data.item_other1, video: snapshot.data.item_video))
                            );
                          },
                          child: Tooltip(
                            verticalOffset: -69,
                            message: snapshot.data.item_name,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
                            textStyle: TextStyle(
                              fontFamily: 'beaufortforlol',
                              fontSize: 16,
                              height: 1.4,
                              color: AppTheme
                                  .coolDown,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border(
                                  bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                )
                            ),
                            child: CachedNetworkImage(
                              // imageUrl: 'https://hninsunyein.me/rift_plus/allinone/' + inner + '.png',
                              imageUrl: snapshot.data.item_image,
                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fadeInDuration: Duration(milliseconds: 100),
                              fadeOutDuration: Duration(milliseconds: 10),
                              fadeInCurve: Curves.bounceIn,
                              width: 19,
                              height: 19,
                            ),
                            //child: Text(inner, style: TextStyle(color: Colors.white))
                          ),
                        );
                      }
                      return Container();
                    }
                )
            )
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtsl>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtrn>') {
        var inner = '';
        Future<Items> itemDetail1;
        inner += abilityData.substring(abilityData.indexOf('<[txtrn>') + 8, abilityData.indexOf('<]txtrn>'));
        itemDetail1 = fetchRuneDetailsByName(inner);
        // String image = 'https://hninsunyein.me/rift_plus/items/' + inner.split('~')[5] + '/' + inner.split('~')[1];
        textSpan.children.add(
            WidgetSpan(
                child: FutureBuilder(
                    future: itemDetail1,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => RunesDetailRoute(id: snapshot.data.id, image: snapshot.data.item_image, name: snapshot.data.item_name, name2: snapshot.data.item_other1, pros: snapshot.data.item_other2, video: snapshot.data.item_video))
                            );
                          },
                          child: Tooltip(
                            verticalOffset: -69,
                            message: snapshot.data.item_name,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
                            textStyle: TextStyle(
                              fontFamily: 'beaufortforlol',
                              fontSize: 16,
                              height: 1.4,
                              color: AppTheme
                                  .coolDown,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border(
                                  bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                )
                            ),
                            child: CachedNetworkImage(
                              // imageUrl: 'https://hninsunyein.me/rift_plus/allinone/' + inner + '.png',
                              imageUrl: snapshot.data.item_image,
                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fadeInDuration: Duration(milliseconds: 100),
                              fadeOutDuration: Duration(milliseconds: 10),
                              fadeInCurve: Curves.bounceIn,
                              width: 19,
                              height: 19,
                            ),
                            //child: Text(inner, style: TextStyle(color: Colors.white))
                          ),
                        );
                      }
                      return Container();
                    }
                )
            )
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtrn>') + 8);
      }


    }
    textSpan.children.add(
      TextSpan(
        text: abilityData,
        style: TextStyle(
          fontFamily: 'spiegel',
          height: 1.4,
          fontSize: 15,
          color: AppTheme
              .labTextActive,
          letterSpacing: 0,
        ),
      ),
    );
    return textSpan;

  }

  Future<Items> fetchItemDetailsByName(name, type) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getItemDetailsByName.php?name='+name);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Items.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Items> fetchSpellDetailsByName(name) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getSpellDetailsByName.php?name='+name);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Items.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<Items> fetchRuneDetailsByName(name) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getRuneDetailsByName.php?name='+name);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Items.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  psAbiImg(String inner, data, type) {
    if(type == 'image') {
      if(inner=='skill1') {
        return data.skill1_image;
      } else if(inner=='skill2') {
        return data.skill2_image;
      } else if(inner=='skill3') {
        return data.skill3_image;
      } else if(inner=='skill4') {
        return data.skill4_image;
      } else {
        return data.skillp_image;
      }
    } else {
      if(inner=='skill1') {
        return data.skill1_name;
      } else if(inner=='skill2') {
        return data.skill2_name;
      } else if(inner=='skill3') {
        return data.skill3_name;
      } else if(inner=='skill4') {
        return data.skill4_name;
      } else {
        return data.skillp_name;
      }
    }

  }






}



class Items {
  final String name;
  final String item_name;
  final String item_image;
  final String id;
  final String item_other1;
  final String item_other2;
  final String item_other3;
  final String item_video;

  Items({this.name, this.item_name, this.item_image, this.id, this.item_other1, this.item_other2, this.item_other3, this.item_video});

  factory Items.fromJson(Map<String, dynamic> json){
    return Items(
        name: json['name'],
        item_name: json['item_name'],
        item_image: json['item_image'],
        id: json['id'],
        item_other1: json['item_other1'],
        item_other2: json['item_other2'],
        item_other3: json['item_other3'],
        item_video: json['item_video']
    );
  }
}
