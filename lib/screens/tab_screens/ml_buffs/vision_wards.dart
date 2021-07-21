import 'dart:convert';
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/screen_one_route/report_detail_page.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';
import '../../../apptheme.dart';
import '../../../fintness_app_theme.dart';
// import '../../homescreen.dart';
// import '../../testscreen.dart';
import '../../app.dart';
import '../../titleView.dart';


class Infos {
  final String intro;
  final String intro_en;

  final String wards;
  final String wards_en;

  final String lens;
  final String lens_en;

  Infos({
    this.intro,
    this.intro_en,
    this.wards,
    this.wards_en,
    this.lens,
    this.lens_en,
  });

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
        intro: json['intro'],
        intro_en: json['intro_en'],
        wards: json['wards'],
        wards_en: json['wards_en'],
        lens: json['lens'],
        lens_en: json['lens_en'],
    );
  }
}

class Ads {
  final String type;

  Ads({this.type});

  factory Ads.fromJson(Map<String, dynamic> json){
    return Ads(
      type: json['type'],
    );
  }
}


class VisionWards extends StatefulWidget {

  @override
  _VisionWardsState createState() => _VisionWardsState();
}

class _VisionWardsState extends State<VisionWards>  with TickerProviderStateMixin{
  List<Widget> listViews = <Widget>[];
  Future<Ads> ads;
  Future languages;
  Future<Infos> infos;
  bool infosLoaded = false;


  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  Dio dio;
  void initState() {
    AppState().increaseGloAdsInt(2);
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );

    WidgetsFlutterBinding.ensureInitialized();
    // Initialize without device test ids.
    // Admob.initialize();
    ads = fetchAds();
    languages = _getLanguage();
    infos = fetchDetInfos();
    super.initState();
  }

  _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getString('language');
    print(index);
    if(index == null) {
      return '_en';
    } else if(index == 'EN') {
      return '_en';
    } else if(index == 'MM') {
      return '';
    }
  }

  Future<Infos> fetchDetInfos() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getDetWardsNLensInfos.php');

    // Use the compute function to run parsePhotos in a separate isolate.
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        infosLoaded = true;
      });
      return Infos.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Ads> fetchAds() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/mapBotAds.php');

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
              Padding(
                padding: const EdgeInsets.only(top: 57.0),
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: Future.wait([infos, languages]),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                color: AppTheme.priBgColor,
                                child: ListView(
                                  children: [
                                    Image(image: AssetImage('assets/images/system/ability-wards.png')),
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 20.0),
                                            child: ReadMoreText(
                                              snapshot.data[1]=='_en'?snapshot.data[0].intro_en.toString():snapshot.data[0].intro.toString()
                                              ,
                                              trimLines: 5,
                                              textScaleFactor: 1,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'spiegel',
                                                  color: AppTheme.labTextActive,
                                                  height: 1.3
                                              ),
                                              colorClickableText: AppTheme.borderColor,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: '... more',
                                              trimExpandedText: '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                                    //   child: FacebookBannerAd(
                                    //     //bannerplacementId:
                                    //     //"708437736767412_710375839906935", //testid
                                    //     placementId: Platform.isAndroid? '708437736767412_710375839906935': '708437736767412_710426626568523',
                                    //     bannerSize: BannerSize.STANDARD,
                                    //     listener: (result, value) {
                                    //       print("Banner Ad: $result -->  $value");
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                            ),
                                          ),
                                        )
                                    ),
                                    TitleView(
                                      titleTxt: 'Wards',
                                      subTxt: '',
                                      id: '',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0,left: 20.0, right: 20.0),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                          child: Image(image: AssetImage('assets/images/system/wards.png'))
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 20.0),
                                            child: ReadMoreText(
                                              snapshot.data[1]=='_en'?snapshot.data[0].wards_en.toString():snapshot.data[0].wards.toString()
                                              ,
                                              trimLines: 2,
                                              textScaleFactor: 1,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'spiegel',
                                                  color: AppTheme.labTextActive,
                                                  height: 1.3
                                              ),
                                              colorClickableText: AppTheme.borderColor,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: '... more',
                                              trimExpandedText: '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                                    //   child: FacebookBannerAd(
                                    //     //bannerplacementId:
                                    //     //"708437736767412_710375839906935", //testid
                                    //     placementId: Platform.isAndroid? '708437736767412_710375839906935': '708437736767412_710426626568523',
                                    //     bannerSize: BannerSize.STANDARD,
                                    //     listener: (result, value) {
                                    //       print("Banner Ad: $result -->  $value");
                                    //     },
                                    //   ),
                                    // ),
                                    SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                            ),
                                          ),
                                        )
                                    ),
                                    TitleView(
                                      titleTxt: 'Sweeping Lens',
                                      subTxt: '',
                                      id: '',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0,left: 20.0, right: 20.0),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                          child: Image(image: AssetImage('assets/images/system/dewards.png'))
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 20.0),
                                            child: ReadMoreText(
                                              snapshot.data[1]=='_en'?snapshot.data[0].lens_en.toString():snapshot.data[0].lens.toString()
                                              ,
                                              trimLines: 2,
                                              textScaleFactor: 1,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'spiegel',
                                                  color: AppTheme.labTextActive,
                                                  height: 1.3
                                              ),
                                              colorClickableText: AppTheme.borderColor,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: '... more',
                                              trimExpandedText: '',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 50,)
                                  ],
                                ),
                              ),
                              FutureBuilder<Ads>(
                                future: ads,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData && snapshot.data.type.contains('bannerAndroid') && Platform.isAndroid) {
                                    return Container();
                                  } else if (snapshot.hasData && snapshot.data.type.contains('bannerIOS') && !Platform.isAndroid) {
                                    // return Platform.isIOS? AdmobBanner(
                                    //   adUnitId: getBannerAdUnitId(),
                                    //   adSize: AdmobBannerSize.SMART_BANNER(context),
                                    // ): AdmobBanner(
                                    //   adUnitId: getBannerAdUnitId(),
                                    //   adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                                    //     width: MediaQuery.of(context)
                                    //         .size
                                    //         .width
                                    //         .toInt(), // considering EdgeInsets.all(20.0)
                                    //   ),
                                    // );


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
                                    );
                                  }
                                  return Container();
                                },
                              )
                            ],
                          );
                        }
                        return Container();
                      }
                    ),
                    !infosLoaded?Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            color: AppTheme.priBgColor,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                  child: CupertinoActivityIndicator(radius: 12,)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text('Loading Data',
                              textScaleFactor: 1,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'spiegel',
                                  color: Colors.white54,
                                  height: 1.3,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                        )
                      ],
                    ):Container()
                  ],
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
                    'WARDS & SWEEPING LENS',
                    textScaleFactor: 1,
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
              padding: const EdgeInsets.only(top: 13, right: 8),
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
                        FadeRoute(page: ReportDetailPage(name: 'Wards'),),
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



}
