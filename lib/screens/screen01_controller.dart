import 'dart:async';
import 'dart:convert';


// import 'package:connectivity/connectivity.dart';
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

import '../apptheme.dart';
import '../fintness_app_theme.dart';
import 'app.dart';
// import 'homescreen.dart';

class ScreenOneController extends StatefulWidget {
  const ScreenOneController({Key key}) : super(key: key);

  @override
  _ScreenOneControllerState createState() => _ScreenOneControllerState();
}

class _ScreenOneControllerState extends State<ScreenOneController>  with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<ScreenOneController>{
  @override
  bool get wantKeepAlive => true;
  Dio dio;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  bool multiple = true;
  //Future<Record> futureRecord;
  Future<List<Season>> seasons;

  String _connectionStatus = 'Unknown';
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;



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
    // initConnectivity();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Future<void> initConnectivity() async {
  //   ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //
  //   return _updateConnectionStatus(result);
  // }
  //
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //       print('wifi');
  //       seasons = fetchSeasons();
  //       setState(() => _connectionStatus = 'connected');
  //       //initConnectivity();
  //       //_showCupertinoDialog();
  //       break;
  //     case ConnectivityResult.mobile:
  //       print('mobile');
  //       seasons = fetchSeasons();
  //       setState(() => _connectionStatus = 'connected');
  //
  //       //initConnectivity();
  //       //_showCupertinoDialog();
  //       break;
  //     case ConnectivityResult.none:
  //       print('none');
  //       setState(() => _connectionStatus = result.toString());
  //       //_showCupertinoDialog();
  //       break;
  //     default:
  //       print('failed');
  //       setState(() => _connectionStatus = 'Failed to get connectivity.');
  //       //_showCupertinoDialog();
  //       break;
  //   }
  // }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<List<Season>> fetchSeasons() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllSupports.php');

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
          print(snapshot.hasData);
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