import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/screens/screen_one_route/champion_route.dart';
import 'package:riftplus02/screens/screen_one_route/runesdetail_route.dart';
import 'package:riftplus02/screens/screen_one_route/seeall_runes_route.dart';
import 'package:riftplus02/screens/titleView.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:http/http.dart' as http;

import '../apptheme.dart';
import '../fintness_app_theme.dart';
// import 'homescreen.dart';

class Rune {
  final String id;
  final String rune_type;
  final String rune_name;
  final String rune_name2;
  final String rune_pros;
  final String rune_video;
  final String rune_image;

  Rune({this.id, this.rune_type, this.rune_name, this.rune_name2, this.rune_pros, this.rune_image, this.rune_video});

  factory Rune.fromJson(Map<String, dynamic> json){
    return Rune(
        id: json['id'],
        rune_type: json['rune_type'],
        rune_name: json['rune_name'],
        rune_name2: json['rune_name2'],
        rune_pros: json['rune_pros'],
        rune_video: json['rune_video'],
        rune_image: json['rune_image']
    );
  }
}

class RNSRunesApi extends StatefulWidget {
  const RNSRunesApi({Key key}) : super(key: key);

  @override
  _RNSRunesApiState createState() => _RNSRunesApiState();
}

class _RNSRunesApiState extends State<RNSRunesApi>  with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<RNSRunesApi>{
  @override
  bool get wantKeepAlive => true;
  Dio dio;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  bool multiple = true;
  List<Widget> listViews = <Widget>[];
  Future<List<Rune>> runesKeyStone;
  Future<List<Rune>> runesDomination;
  Future<List<Rune>> runesResolve;
  Future<List<Rune>> runesInspiration;
  bool runesKeyStoneLoaded = false;
  bool runesDominationLoaded = false;
  bool runesResolveLoaded = false;
  bool runesInspirationLoaded = false;
  String runeKeyStoneResponse;
  String runeDominationResponse;
  String runeResolveResponse;
  String runeInspirationResponse;

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
    addAllListData();
    super.initState();
    runesKeyStone = fetchRuneKeyStones();
    runesDomination = fetchRuneDomination();
    runesResolve = fetchRuneResolve();
    runesInspiration = fetchRuneInspiration();
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<List<Rune>> fetchRuneKeyStones() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllKeyStoneRunes.php');
    //print(response.body);

    if (response.statusCode == 200) {
      runeKeyStoneResponse = response.toString();
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject["flore"];
      var runes = list.map((runeKeyStones) => Rune.fromJson(runeKeyStones)).toList();
      setState(() {
        runesKeyStoneLoaded = true;
      });
      return runes;

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Rune>> fetchRuneDomination() async {
    final response =
    await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllDominationRunes.php');
    //print(response.body);
    if (response.statusCode == 200) {
      runeDominationResponse = response.body;
      Map<String, dynamic> jsonObject = json.decode(response.body);
      Iterable list = jsonObject["flore"];
      var runes = list.map((runeKeyStones) => Rune.fromJson(runeKeyStones)).toList();
      setState(() {
        runesDominationLoaded = true;
      });
      return runes;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Rune>> fetchRuneResolve() async {
    final response =
    await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllResolveRunes.php');
    //print(response.body);
    if (response.statusCode == 200) {
      runeResolveResponse = response.body;
      Map<String, dynamic> jsonObject = json.decode(response.body);
      Iterable list = jsonObject["flore"];
      var runes = list.map((runeKeyStones) => Rune.fromJson(runeKeyStones)).toList();
      setState(() {
        runesResolveLoaded = true;
      });
      return runes;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Rune>> fetchRuneInspiration() async {
    final response =
    await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllInspirationRunes.php');
    //print(response.body);
    if (response.statusCode == 200) {
      runeInspirationResponse = response.body;
      Map<String, dynamic> jsonObject = json.decode(response.body);
      Iterable list = jsonObject["flore"];
      var runes = list.map((runeKeyStones) => Rune.fromJson(runeKeyStones)).toList();
      setState(() {
        runesInspirationLoaded = true;
      });
      return runes;

    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.priBgColor,
      child: Stack(
        children: [
          ListView(
            children: [
              FutureBuilder<List<Rune>>(
                  future: runesKeyStone,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 2.9;
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'KEYSTONE RUNES',
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'beaufortforlol',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      letterSpacing: 0.3,
                                      color: AppTheme.labTextActive,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SeeAllRunesRoute(rune: runeKeyStoneResponse, id: 'flore', name: 'KEYSTONE RUNES'))
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'See all',
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'spiegel',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.3,
                                            color: AppTheme.borderColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: containerHeight,
                            child: GridView.builder(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 15),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Tooltip(
                                  verticalOffset: -69,
                                  message: snapshot.data[index].rune_name,
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
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                              imageUrl: snapshot.data[index].rune_image,
                                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              fadeInDuration: Duration(milliseconds: 100),
                                              fadeOutDuration: Duration(milliseconds: 10),
                                              fadeInCurve: Curves.bounceIn
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(4.0)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].rune_image, name: snapshot.data[index].rune_name, name2: snapshot.data[index].rune_name2, pros: snapshot.data[index].rune_pros,  video: snapshot.data[index].rune_video))
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 20.0,
                                childAspectRatio: 1,
                              ),
                            )
                        )
                      ],
                    );
                  }
              ),
              SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                      ),
                    ),
                  )
              ),
              FutureBuilder<List<Rune>>(
                  future: runesDomination,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 3.7;
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'DOMINATION RUNES',
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'beaufortforlol',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      letterSpacing: 0.3,
                                      color: AppTheme.labTextActive,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SeeAllRunesRoute(rune: runeDominationResponse, id: 'flore', name:'DOMINATION RUNES'))
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'See all',
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'spiegel',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.3,
                                            color: AppTheme.borderColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: containerHeight,
                            child: GridView.builder(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 15),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Tooltip(
                                  verticalOffset: -69,
                                  message: snapshot.data[index].rune_name,
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
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                              imageUrl: snapshot.data[index].rune_image,
                                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              fadeInDuration: Duration(milliseconds: 100),
                                              fadeOutDuration: Duration(milliseconds: 10),
                                              fadeInCurve: Curves.bounceIn
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(4.0)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].rune_image, name: snapshot.data[index].rune_name, name2: snapshot.data[index].rune_name2, pros: snapshot.data[index].rune_pros,  video: snapshot.data[index].rune_video))
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 20.0,
                                childAspectRatio: 1,
                              ),
                            )
                        )
                      ],
                    );
                  }
              ),
              SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                      ),
                    ),
                  )
              ),
              FutureBuilder<List<Rune>>(
                  future: runesResolve,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 3.7;
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'RESOLVE RUNES',
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'beaufortforlol',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      letterSpacing: 0.3,
                                      color: AppTheme.labTextActive,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SeeAllRunesRoute(rune: runeResolveResponse, id: 'flore', name: 'RESOLVE RUNES'))
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'See all',
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'spiegel',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.3,
                                            color: AppTheme.borderColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: containerHeight,
                            child: GridView.builder(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 15),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Tooltip(
                                  verticalOffset: -69,
                                  message: snapshot.data[index].rune_name,
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
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                              imageUrl: snapshot.data[index].rune_image,
                                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              fadeInDuration: Duration(milliseconds: 100),
                                              fadeOutDuration: Duration(milliseconds: 10),
                                              fadeInCurve: Curves.bounceIn
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(4.0)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].rune_image, name: snapshot.data[index].rune_name, name2: snapshot.data[index].rune_name2, pros: snapshot.data[index].rune_pros, video: snapshot.data[index].rune_video))
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 20.0,
                                childAspectRatio: 1,
                              ),
                            )
                        )
                      ],
                    );
                  }
              ),
              SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                      ),
                    ),
                  )
              ),
              FutureBuilder<List<Rune>>(
                  future: runesInspiration,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 3.7;
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    return Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'INSPIRATION RUNES',
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      fontFamily: 'beaufortforlol',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 19,
                                      letterSpacing: 0.3,
                                      color: AppTheme.labTextActive,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SeeAllRunesRoute(rune: runeInspirationResponse, id: 'flore', name: 'INSPIRATION RUNES'))
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'See all',
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'spiegel',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.3,
                                            color: AppTheme.borderColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: containerHeight,
                            child: GridView.builder(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 15),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Tooltip(
                                  verticalOffset: -69,
                                  message: snapshot.data[index].rune_name,
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
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                              imageUrl: snapshot.data[index].rune_image,
                                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              fadeInDuration: Duration(milliseconds: 100),
                                              fadeOutDuration: Duration(milliseconds: 10),
                                              fadeInCurve: Curves.bounceIn
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(4.0)),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].rune_image, name: snapshot.data[index].rune_name, name2: snapshot.data[index].rune_name2, pros: snapshot.data[index].rune_pros, video: snapshot.data[index].rune_video))
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 20.0,
                                crossAxisSpacing: 20.0,
                                childAspectRatio: 1,
                              ),
                            )
                        ),
                        SizedBox(height: 60)
                      ],
                    );
                  }
              ),

            ],
          ),
          runesKeyStoneLoaded && runesDominationLoaded && runesResolveLoaded && runesInspirationLoaded ? Container():Stack(
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
          ),
        ],
      ),
    );
  }

  Widget allChampions(BuildContext context, snapshot) {
    print(snapshot);
    return SizedBox();
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
  }


  void addAllListData() {



  }

}

// class ChampionsListView extends StatelessWidget {
//   const ChampionsListView(
//       {Key key,
//         this.listData,
//         this.callBack,})
//       : super(key: key);
//
//   final ChampionsList listData;
//   final VoidCallback callBack;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.5,
//       child: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//         child: Stack(
//           alignment: AlignmentDirectional.center,
//           children: <Widget>[
//             Image.asset(
//               listData.imagePath,
//               fit: BoxFit.cover,
//             ),
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 splashColor: Colors.grey.withOpacity(0.2),
//                 borderRadius:
//                 const BorderRadius.all(Radius.circular(4.0)),
//                 onTap: () {
//                   callBack();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
//
//
// }
