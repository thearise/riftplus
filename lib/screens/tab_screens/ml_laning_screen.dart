import 'dart:convert';
import 'dart:io';
import 'dart:math';

//import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/mapLanes.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
import 'package:riftplus02/screens/screen_one_route/baron_lane.dart';
// import 'package:riftplus02/screens/screen_one_route/champion_route.dart';
import 'package:riftplus02/screens/screen_one_route/dragon_lane.dart';
import 'package:riftplus02/screens/screen_one_route/duo_lane.dart';
import 'package:riftplus02/screens/screen_one_route/itemsdetail_route.dart';
import 'package:riftplus02/screens/screen_one_route/jungle-lane.dart';
import 'package:riftplus02/screens/screen_one_route/mid-lane.dart';
import 'package:riftplus02/screens/titleView.dart';
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
// import 'package:riftplus02/views/championsbarview.dart';

import '../../apptheme.dart';
import '../../main.dart';

class Infos {
  final String intro;
  final String intro_en;
  final String baron;
  final String dragon;
  final String mid;
  final String jungle;
  final String baron_en;
  final String dragon_en;
  final String mid_en;
  final String jungle_en;
  final String duo;
  final String duo_en;

  Infos({this.intro, this.intro_en, this.baron, this.dragon, this.mid, this.jungle, this.baron_en, this.dragon_en, this.mid_en, this.jungle_en, this.duo, this.duo_en});

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
      intro: json['intro'],
      intro_en: json['intro_en'],
      baron: json['baron'],
      dragon: json['dragon'],
      mid: json['mid'],
      jungle: json['jungle'],
      baron_en: json['baron_en'],
      dragon_en: json['dragon_en'],
      mid_en: json['mid_en'],
      jungle_en: json['jungle_en'],
      duo: json['duo'],
      duo_en: json['duo_en'],
    );
  }
}

class MLLaningScreen extends StatefulWidget {
  // final String globLang;
  // MLLaningScreen(this.globLang);
  // final ValueListenable<String> number;

  @override
  _MLLaningScreenState createState() => _MLLaningScreenState();
}



class _MLLaningScreenState extends State<MLLaningScreen>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MLLaningScreen>{
  @override
  bool get wantKeepAlive => true;

  AppValueNotifier appValueNotifier = AppValueNotifier();
  bool multiple = true;
  List<Widget> listViews = <Widget>[];
  StreamingSharedPreferences preferences;
  Preference<String> langsStream;

  Future<Infos> infos;
  bool infosLoaded = false;



  String langsState;

  var globLang;
  _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getString('language');
    if(index == null) {
      return '_en';
    } else if(index == 'EN') {
      return '_en';
    } else if(index == 'MM') {
      return '';
    }
  }




  Future languages;

  Dio dio;
  void initState() {
    languages = _getLanguage();


    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    //_initStreamPref();


    // FacebookAudienceNetwork.init(
    //     //testingId: "6025b2d7-87e0-493b-a97e-66d8a2cefadb"
    // );
    // championsTabDataList.forEach((ChampionsTabData tab) {
    //   tab.isSelected = false;
    // });
    // championsTabDataList[0].isSelected = true;
    infos = fetchLaneInfos();
    super.initState();
  }

  Future<Infos> fetchLaneInfos() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getLaneInfos2.php');

    // Use the compute function to run parsePhotos in a separate isolate.
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Future.delayed(const Duration(milliseconds: 2500), () {

// Here you can write your code

        setState(() {
          infosLoaded = true;
        });

      });

      return Infos.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initStreamPref() async {
    WidgetsFlutterBinding.ensureInitialized();
    preferences = await StreamingSharedPreferences.instance;

    langsStream = preferences.getString('language', defaultValue: 'EN');
    langsStream.listen((value) {
    });
  }





  @override
  Widget build(BuildContext context) {
    // var globLang = widget.globLang;
    return Container(
      color: AppTheme.priBgColor,
      child: Stack(
        children: [
          !infosLoaded?Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: AppTheme.priBgColor,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                        child: CupertinoActivityIndicator(radius: 12,)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
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
          ):Container(),
          FutureBuilder<Infos>(
            future: infos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder(
                  stream: _getLanguageStream,
                  builder: (context, snapshot2) {
                    return infosLoaded?ListView(
                      children: [
                        TitleView(
                          titleTxt: 'LANES & ROLES OVERVIEW',
                          subTxt: '',
                          id: '',
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 5.0),
                                child: ReadMoreText(
                                  snapshot2.data == 1 ? snapshot.data.intro: snapshot.data.intro_en,
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
                        Padding(
                          padding: const EdgeInsets.only(left:20,right: 20, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => BaronLane(desc: snapshot2.data == 1? snapshot.data.baron: snapshot.data.baron_en))
                              );
                            },
                            child: Container(
                              //color: AppTheme.secBgColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.secBgColor,
                              ),
                              child: ResponsiveGridRow(children: [
                                ResponsiveGridCol(
                                    xs: 3,
                                    md: 3,
                                    child: Container(
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 00.0, top: 0.0),
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 14.0),
                                              child: Image(image: AssetImage('assets/images/system/solo-img.png',)),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                                ResponsiveGridCol(
                                  xs: 9,
                                  md: 9,
                                  child: Container(
                                    height: 115,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, left: 0.0, right: 0.0),
                                            child: Text(
                                              'Solo Position',
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 16,
                                                color: AppTheme.lightText,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
//                  Expanded(
//                      child: Padding(
//                        padding: const EdgeInsets.all(15.0),
//                        child: Text("This is a sample long text line we are using in our example. This is a sample long text line we are using in our example. This is a sample long text line we are using in our example.",
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                            fontFamily: 'spiegel',
//                            color: AppTheme.labTextActive,
//                          ),
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 2,
//                  ),
//                      ))
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              snapshot2.data == 1 ? snapshot.data.baron: snapshot.data.baron_en,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.labTextActive,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              "Fighter | Tank | Assassin",
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.activeIcon,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:20,right: 20, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => JungleLane(desc: snapshot2.data == 1? snapshot.data.jungle: snapshot.data.jungle_en))
                              );
                            },
                            child: Container(
                              //color: AppTheme.secBgColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.secBgColor,
                              ),
                              child: ResponsiveGridRow(children: [
                                ResponsiveGridCol(
                                    xs: 3,
                                    md: 3,
                                    child: Container(
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 00.0, top: 0.0),
                                          child: Container(
//                      decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            top: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            left: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            right: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                          )
//                      ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 13.0),
                                              child: Image(image: AssetImage('assets/images/system/jungle-img.png')),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                                ResponsiveGridCol(
                                  xs: 9,
                                  md: 9,
                                  child: Container(
                                    height: 115,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, left: 0.0, right: 0.0),
                                            child: Text(
                                              'Jungle Position',
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 16,
                                                color: AppTheme.lightText,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              snapshot2.data == 1 ? snapshot.data.jungle: snapshot.data.jungle_en,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.labTextActive,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              "Fighter | Tank | Assassin",
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.activeIcon,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:20,right: 20, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => MidLane(desc: snapshot2.data == 1? snapshot.data.mid: snapshot.data.mid_en))
                              );
                            },
                            child: Container(
                              //color: AppTheme.secBgColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.secBgColor,
                              ),
                              child: ResponsiveGridRow(children: [
                                ResponsiveGridCol(
                                    xs: 3,
                                    md: 3,
                                    child: Container(
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 00.0, top: 0.0),
                                          child: Container(
//                      decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            top: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            left: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            right: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                          )
//                      ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 14.0),
                                              child: Image(image: AssetImage('assets/images/system/mid-img.png')),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                                ResponsiveGridCol(
                                  xs: 9,
                                  md: 9,
                                  child: Container(
                                    height: 115,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, left: 0.0, right: 0.0),
                                            child: Text(
                                              'Mid Position',
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 16,
                                                color: AppTheme.lightText,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                        ),
//                  Expanded(
//                      child: Padding(
//                        padding: const EdgeInsets.all(15.0),
//                        child: Text("This is a sample long text line we are using in our example. This is a sample long text line we are using in our example. This is a sample long text line we are using in our example.",
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                            fontFamily: 'spiegel',
//                            color: AppTheme.labTextActive,
//                          ),
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 2,
//                  ),
//                      ))
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              snapshot2.data == 1 ? snapshot.data.mid: snapshot.data.mid_en,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.labTextActive,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              "Mage | Assassin",
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.activeIcon,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:20,right: 20, top: 20, bottom: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => DuoLane(desc: snapshot2.data == 1? snapshot.data.duo: snapshot.data.duo_en))
                              );
                            },
                            child: Container(
                              //color: AppTheme.secBgColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.secBgColor,
                              ),
                              child: ResponsiveGridRow(children: [
                                ResponsiveGridCol(
                                    xs: 3,
                                    md: 3,
                                    child: Container(
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 00.0, top: 0.0),
                                          child: Container(
//                      decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            top: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            left: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            right: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                          )
//                      ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 22.0, right: 15.0),
                                              child: Image(image: AssetImage('assets/images/system/duo-img.png')),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                                ResponsiveGridCol(
                                  xs: 9,
                                  md: 9,
                                  child: Container(
                                    height: 115,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, left: 0.0, right: 0.0),
                                            child: Text(
                                              'Duo Position',
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 16,
                                                color: AppTheme.lightText,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
//                  Expanded(
//                      child: Padding(
//                        padding: const EdgeInsets.all(15.0),
//                        child: Text("This is a sample long text line we are using in our example. This is a sample long text line we are using in our example. This is a sample long text line we are using in our example.",
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                            fontFamily: 'spiegel',
//                            color: AppTheme.labTextActive,
//                          ),
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 2,
//                  ),
//                      ))
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              snapshot2.data == 1 ? snapshot.data.duo: snapshot.data.duo_en,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.labTextActive,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              "Marksman",
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.activeIcon,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:20,right: 20, top: 0, bottom: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => DragonLane(desc: snapshot2.data == 1? snapshot.data.dragon: snapshot.data.dragon_en))
                              );
                            },
                            child: Container(
                              //color: AppTheme.secBgColor,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppTheme.secBgColor,
                              ),
                              child: ResponsiveGridRow(children: [
                                ResponsiveGridCol(
                                    xs: 3,
                                    md: 3,
                                    child: Container(
                                        height: 115,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 00.0, top: 0.0),
                                          child: Container(
//                      decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            top: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            left: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            right: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                          )
//                      ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 22.0, right: 15.0),
                                              child: Image(image: AssetImage('assets/images/system/support-img.png')),
                                            ),
                                          ),
                                        )
                                    )
                                ),
                                ResponsiveGridCol(
                                  xs: 9,
                                  md: 9,
                                  child: Container(
                                    height: 115,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, left: 0.0, right: 0.0),
                                            child: Text(
                                              'Support Position',
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontSize: 16,
                                                color: AppTheme.lightText,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
//                  Expanded(
//                      child: Padding(
//                        padding: const EdgeInsets.all(15.0),
//                        child: Text("This is a sample long text line we are using in our example. This is a sample long text line we are using in our example. This is a sample long text line we are using in our example.",
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                            fontFamily: 'spiegel',
//                            color: AppTheme.labTextActive,
//                          ),
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 2,
//                  ),
//                      ))
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              snapshot2.data == 1 ? snapshot.data.dragon: snapshot.data.dragon_en,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.labTextActive,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                            child: Text(
                                              "Tank | Support",
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                height: 1.2,
                                                fontSize: 13,
                                                fontFamily: 'spiegel',
                                                color: AppTheme.activeIcon,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
//            padding: EdgeInse
                    ):Container();
                  }

                );
              }
              return Container();
            }
          ),
        ],
      )
    );
  }

  Widget allChampions(BuildContext context, snapshot) {
    return SizedBox();
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
  }

  Stream<int> _getLanguageStream = (() async* {
    //
    // yield 1;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      // localLang = _getLanguage();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var index = prefs.getString('language');
      if(index.toString().contains('EN')) {
        yield 0;
      } else if (index.toString().contains('MM')){
        yield 1;
      }
      //yield random.nextInt(10);
    }
  })();


  Stream<double> _getLanguageStream2() async* {
    var random = Random(2);
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextDouble();
    }
  }


}



class ExpandableText extends StatefulWidget {
  const ExpandableText(
      this.text, {
        Key key,
        this.trimLines = 2,
      })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}
class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... more" : " less",
        style: TextStyle(
          color: colorClickableText,
          fontFamily: 'spiegel',
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: TextStyle(
              fontFamily: 'spiegel',
              color: AppTheme.labTextActive,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}