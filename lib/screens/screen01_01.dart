// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
import 'package:riftplus02/screens/screen_one_route/champion_route_test.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:http/http.dart' as http;
import 'package:riftplus02/screens/screen_one_route/champion_tooltip.dart';
import 'package:riftplus02/screens/test.dart';
import 'dart:async';
import 'dart:convert';

import '../apptheme.dart';
import '../fintness_app_theme.dart';
import 'app.dart';
// import 'homescreen.dart';

class ScreenOneOne extends StatefulWidget {
  const ScreenOneOne({Key key}) : super(key: key);
  //final called1 = false;
  @override
  _ScreenOneOneState createState() => _ScreenOneOneState();
}

class _ScreenOneOneState extends State<ScreenOneOne> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<ScreenOneOne>{
  @override
  bool get wantKeepAlive => true;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  bool multiple = true;
  //Future<Record> futureRecord;
  Future<List<Season>> seasons;
  Dio dio;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;



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
    // championsTabDataList.forEach((ChampionsTabData tab) {
    //   tab.isSelected = false;
    // });
    // championsTabDataList[0].isSelected = true;
    //seasons = fetchSeasons();

    super.initState();
    seasons = fetchSeasons();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  //
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      }
    } on SocketException catch (_) {
    }
    //print(result.toString());
    // switch (result) {
    //   case ConnectivityResult.wifi:
    //   case ConnectivityResult.mobile:
    //   case ConnectivityResult.none:
    //     setState(() => _connectionStatus = result.toString());
    //     if(result.toString() == 'ConnectivityResult.mobile') {
    //       seasons = fetchSeasons();
    //       print('Flore Mobile');
    //     } else if(result.toString() == 'ConnectivityResult.wifi') {
    //       seasons = fetchSeasons();
    //       print('Flore Wifi');
    //     } if(result.toString() == 'ConnectivityResult.none') {
    //       print('Flore None');
    //     }
    //     break;
    //   default:
    //     setState(() => _connectionStatus = 'Failed to get connectivity.');
    //     break;
    // }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<List<Season>> fetchSeasons() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllHeros.php');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject['champions_list'];
      var seasons = list.map((season) => Season.fromJson(season)).toList();
      return seasons;

    } else {
      // print(response.);
      throw Exception('Failed to load album');
    }
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.priBgColor,
      child: FutureBuilder<List<Season>>(
        future: seasons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return GridView.builder(
                padding: const EdgeInsets.only(
                    top: 15, left: 20, right: 20, bottom: 65),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  //return Text("${snapshot.data[index].name}");
                  return AspectRatio(
                    aspectRatio: 1.5,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          // FadeInImage.assetNetwork(
                          //   placeholder: 'assets/images/system/black-square.png',
                          //   fadeInDuration: Duration(milliseconds: 10),
                          //   image: snapshot.data[index].image,
                          //   fit: BoxFit.cover,
                          // ),

                          CachedNetworkImage(
                            imageUrl: snapshot.data[index].image,
                            placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fadeInDuration: Duration(milliseconds: 100),
                            fadeOutDuration: Duration(milliseconds: 10),
                            fadeInCurve: Curves.bounceIn
                          ),
//                          Image(
//                            image: NetworkImage(snapshot.data[index].image),
//                            fit: BoxFit.cover,
//                          ),
                          Tooltip(
                            verticalOffset: -69,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.grey.withOpacity(0.3),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {
                                  Navigator.of(context).push(
                                    // MaterialPageRoute(
                                    //     builder: (context) => ChampionRoute(id: snapshot.data[index].id, image: snapshot.data[index].image, name: snapshot.data[index].name, video: snapshot.data[index].video))
                                      MaterialPageRoute(
                                          builder: (context) => ChampionRoute(id: snapshot.data[index].id, image: snapshot.data[index].image, name: snapshot.data[index].name, video: snapshot.data[index].video))
                                  );
                                },
                              ),
                            ),
                            message: snapshot.data[index].name,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
                            textStyle: TextStyle(
                              fontFamily: 'beaufortforlol',
                              fontSize: 16,
                              height: 1.3,
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
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
          return Stack(
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
          );
        },
      ),
    );
  }
}

class Season {
  final String id;
  final String name;
  final String image;
  final String video;

  Season({this.id, this.name, this.image, this.video});

  factory Season.fromJson(Map<String, dynamic> json){
    return Season(
        id: json['id'],
        name: json['champion_name'],
        image: json['champion_image'],
        video: json['passive_video']
    );
  }
}


//class ScreenOneOne extends StatelessWidget {
//  //const ScreenOneOne({Key key}) : super(key: key);
//
//  List<ChampionsList> championsList = ChampionsList.championsList;
//  List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
//  bool multiple = true;
//  //Future<Record> futureRecord;
//  Future<List<Season>> seasons;
//
//
//  void initState() {
//    championsTabDataList.forEach((ChampionsTabData tab) {
//      tab.isSelected = false;
//    });
//    championsTabDataList[0].isSelected = true;
//    seasons = fetchSeasons();
//    //super.initState();
//  }
//  Future<bool> getData() async {
//    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
//    return true;
//  }
//
//  Future<List<Season>> fetchSeasons() async {
//    final response =
//    await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllHeros.php');
//
//    if (response.statusCode == 200) {
//      print(response.body);
//      Map<String, dynamic> jsonObject = json.decode(response.body);
//      print(jsonObject['champions_list']);
//      Iterable list = jsonObject['champions_list'];
//      var seasons = list.map((season) => Season.fromJson(season)).toList();
//      return seasons;
//
//    } else {
//      throw Exception('Failed to load album');
//    }
//  }
//
//
//
//  @override
//  void dispose() {
//    //super.dispose();
//  }
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Container(
//      color: AppTheme.priBgColor,
//      child: FutureBuilder<List<Season>>(
//        future: seasons,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            return GridView.builder(
//                padding: const EdgeInsets.only(
//                    top: 15, left: 20, right: 20, bottom: 15),
//                physics: const BouncingScrollPhysics(),
//                scrollDirection: Axis.vertical,
//                itemCount: snapshot.data.length,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 4,
//                  mainAxisSpacing: 15.0,
//                  crossAxisSpacing: 15.0,
//                  childAspectRatio: 1.0,
//                ),
//                itemBuilder: (context, index) {
//                  //return Text("${snapshot.data[index].name}");
//                  return AspectRatio(
//                    aspectRatio: 1.5,
//                    child: ClipRRect(
//                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//                      child: Stack(
//                        alignment: AlignmentDirectional.center,
//                        children: <Widget>[
//                          Image(
//                            image: NetworkImage(snapshot.data[index].image),
//                            fit: BoxFit.cover,
//                          ),
//                          Material(
//                            color: Colors.transparent,
//                            child: InkWell(
//                              splashColor: Colors.grey.withOpacity(0.2),
//                              borderRadius:
//                              const BorderRadius.all(Radius.circular(4.0)),
//                              onTap: () {
//                                Navigator.of(context).push(
//                                    MaterialPageRoute(
//                                        builder: (context) => ChampionRoute(id: snapshot.data[index].id, image: snapshot.data[index].image, name: snapshot.data[index].name, video: snapshot.data[index].video))
//                                );
//                              },
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  );
//                }
//            );
//          } else if (snapshot.hasError) {
//            return Text("Error");
//          }
//          return Text("Loading...");
//        },
//      ),
//    );
//  }
//
//  Widget allChampions(BuildContext context, snapshot) {
//    print(snapshot);
//    return SizedBox();
//  }
//
//
//  Widget _buildListItem(BuildContext context, data) {
//    //final record = Record.fromSnapshot(data);
//    return AspectRatio(
//      aspectRatio: 1.5,
//      child: ClipRRect(
//        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//        child: Stack(
//          alignment: AlignmentDirectional.center,
//          children: <Widget>[
//            Image(
//              image: NetworkImage(data.image),
//              fit: BoxFit.cover,
//            ),
//            Material(
//              color: Colors.transparent,
//              child: InkWell(
//                splashColor: Colors.grey.withOpacity(0.2),
//                borderRadius:
//                const BorderRadius.all(Radius.circular(4.0)),
//                onTap: () {
//                  Navigator.of(context).push(
//                      MaterialPageRoute(
//                          builder: (context) => ChampionRoute(id: data.id, image: data.image, name: data.name, video: data.video))
//                  );
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//}
//
//class ChampionsListView extends StatelessWidget {
//  const ChampionsListView(
//      {Key key,
//        this.listData,
//        this.callBack,})
//      : super(key: key);
//
//  final ChampionsList listData;
//  final VoidCallback callBack;
//
//  @override
//  Widget build(BuildContext context) {
//    return AspectRatio(
//      aspectRatio: 1.5,
//      child: ClipRRect(
//        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//        child: Stack(
//          alignment: AlignmentDirectional.center,
//          children: <Widget>[
//            Image.asset(
//              listData.imagePath,
//              fit: BoxFit.cover,
//            ),
//            Material(
//              color: Colors.transparent,
//              child: InkWell(
//                splashColor: Colors.grey.withOpacity(0.2),
//                borderRadius:
//                const BorderRadius.all(Radius.circular(4.0)),
//                onTap: () {
//                  callBack();
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//
//  }
//
//
//}
//
//
//class Record {
//  final int id;
//  final String name;
//  final String image;
//  final String video;
//
//  Record({this.id, this.name, this.image, this.video});
//
//  factory Record.fromJson(Map<String, dynamic> json) {
//    return Record(
//        id: json['id'],
//        name: json['name'],
//        image: json['image'],
//        video: json['video']
//    );
//  }
//}
//
//
//class Season {
//  final String id;
//  final String name;
//  final String image;
//  final String video;
//
//  Season({this.id, this.name, this.image, this.video});
//
//  factory Season.fromJson(Map<String, dynamic> json){
//    return Season(
//        id: json['id'],
//        name: json['champion_name'],
//        image: json['champion_image'],
//        video: json['passive_video']
//    );
//  }
//}