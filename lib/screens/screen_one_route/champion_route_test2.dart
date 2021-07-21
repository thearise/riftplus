import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
// import 'package:connectivity/connectivity.dart';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/tab_screens/ml_laning_screen.dart';
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';
import '../../apptheme.dart';
import '../../fintness_app_theme.dart';
import '../screen01_01.dart';
import '../screen01_fighter.dart';
import '../screen01_tank.dart';
import 'championRouteTab1.dart';
// import '../homescreen.dart';
// import '../testscreen.dart';


class Item {
  final String id;
  final String item_type;
  final String item_lv;
  final String item_name;
  final String item_name2;
  final String item_price;
  final String item_image;

  Item({this.id, this.item_type, this.item_lv, this.item_name, this.item_name2, this.item_price, this.item_image});

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
        id: json['id'],
        item_type: json['item_type'],
        item_lv: json['item_lv'],
        item_name: json['item_name'],
        item_name2: json['item_name2'],
        item_price: json['item_price'],
        item_image: json['item_image']
    );
  }
}

class Combos {
  final String id;
  final String ps_name;
  final String ps_desc;
  final String ps_skill1;
  final String ps_skill2;
  final String ps_skill3;
  final String ps_skill4;
  final String ps_skill5;
  final String ps_skill6;

  Combos({this.id, this.ps_name, this.ps_desc, this.ps_skill1, this.ps_skill2, this.ps_skill3, this.ps_skill4, this.ps_skill5, this.ps_skill6});

  factory Combos.fromJson(Map<String, dynamic> json){
    return Combos(
      id: json['id'],
      ps_name: json['ps_name'],
      ps_desc: json['ps_desc'],
      ps_skill1: json['ps_skill1'],
      ps_skill2: json['ps_skill2'],
      ps_skill3: json['ps_skill3'],
      ps_skill4: json['ps_skill4'],
      ps_skill5: json['ps_skill5'],
      ps_skill6: json['ps_skill6'],
    );
  }
}


class Counters {
  final String id;
  final String name;
  final String image;

  Counters({this.id, this.name, this.image});

  factory Counters.fromJson(Map<String, dynamic> json){
    return Counters(
      id: json['id'],
      name: json['name'],
      image: json['image'],
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

class Items {
  final String name;
  final String item_name;
  final String item_image;

  Items({this.name, this.item_name, this.item_image});

  factory Items.fromJson(Map<String, dynamic> json){
    return Items(
      name: json['name'],
      item_name: json['item_name'],
      item_image: json['item_image'],
    );
  }
}

class Abilities {
  final String skillp_cooldown;
  final String skillp_desc;
  final String skillp_image;
  final String skillp_mana;
  final String skillp_name;
  final String skillp_name2;
  final String skillp_video;
  final String skill1_cooldown;
  final String skill1_desc;
  final String skill1_image;
  final String skill1_mana;
  final String skill1_name;
  final String skill1_name2;
  final String skill1_video;
  final String skill2_cooldown;
  final String skill2_desc;
  final String skill2_image;
  final String skill2_mana;
  final String skill2_name;
  final String skill2_name2;
  final String skill2_video;
  final String skill3_cooldown;
  final String skill3_desc;
  final String skill3_image;
  final String skill3_mana;
  final String skill3_name;
  final String skill3_name2;
  final String skill3_video;
  final String skill4_cooldown;
  final String skill4_desc;
  final String skill4_image;
  final String skill4_mana;
  final String skill4_name;
  final String skill4_name2;
  final String skill4_video;

  Abilities({this.skillp_cooldown, this.skillp_desc, this.skillp_image, this.skillp_mana, this.skillp_name, this.skillp_name2, this.skillp_video,
    this.skill1_cooldown, this.skill1_desc, this.skill1_image, this.skill1_mana, this.skill1_name, this.skill1_name2, this.skill1_video,
    this.skill2_cooldown, this.skill2_desc, this.skill2_image, this.skill2_mana, this.skill2_name, this.skill2_name2, this.skill2_video,
    this.skill3_cooldown, this.skill3_desc, this.skill3_image, this.skill3_mana, this.skill3_name, this.skill3_name2, this.skill3_video,
    this.skill4_cooldown, this.skill4_desc, this.skill4_image, this.skill4_mana, this.skill4_name, this.skill4_name2, this.skill4_video,
  });

  factory Abilities.fromJson(Map<String, dynamic> json){
    return Abilities(
        skillp_cooldown: json['skillp_cooldown'],
        skillp_desc: json['skillp_desc'],
        skillp_image: json['skillp_image'],
        skillp_mana: json['skillp_mana'],
        skillp_name: json['skillp_name'],
        skillp_name2: json['skillp_name2'],
        skillp_video: json['skillp_video'],

        skill1_cooldown: json['skill1_cooldown'],
        skill1_desc: json['skill1_desc'],
        skill1_image: json['skill1_image'],
        skill1_mana: json['skill1_mana'],
        skill1_name: json['skill1_name'],
        skill1_name2: json['skill1_name2'],
        skill1_video: json['skill1_video'],

        skill2_cooldown: json['skill2_cooldown'],
        skill2_desc: json['skill2_desc'],
        skill2_image: json['skill2_image'],
        skill2_mana: json['skill2_mana'],
        skill2_name: json['skill2_name'],
        skill2_name2: json['skill2_name2'],
        skill2_video: json['skill2_video'],

        skill3_cooldown: json['skill3_cooldown'],
        skill3_desc: json['skill3_desc'],
        skill3_image: json['skill3_image'],
        skill3_mana: json['skill3_mana'],
        skill3_name: json['skill3_name'],
        skill3_name2: json['skill3_name2'],
        skill3_video: json['skill3_video'],

        skill4_cooldown: json['skill4_cooldown'],
        skill4_desc: json['skill4_desc'],
        skill4_image: json['skill4_image'],
        skill4_mana: json['skill4_mana'],
        skill4_name: json['skill4_name'],
        skill4_name2: json['skill4_name2'],
        skill4_video: json['skill4_video']
    );
  }
}






class ChampionRoute extends StatefulWidget {
  const ChampionRoute({Key key, this.id, this.image, this.name, this.video}) : super(key: key);
  final String id;
  final String image;
  final String name;
  final String video;
  @override
  _ChampionRouteState createState() => _ChampionRouteState();
}

class _ChampionRouteState extends State<ChampionRoute>  with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<ChampionRoute>{
  var variHeight = 500.0;

  @override
  bool get wantKeepAlive => true;
  Dio dio;

  int _playBackTime;
  int _playBackTime1;
  int _playBackTime2;
  int _playBackTime3;
  Future<List<Item>> itemsBuild;
  Future<Infos> infos;
  Future<Abilities> abilities;
  Future<Ads> ads;
  Future<List<Combos>> combos;
  Future<List<Counters>> weaks;
  Future<List<Counters>> strongs;
  Future<List<Counters>> mates;


  String items1Response;
  Future<List<Items>> items1;
  Future<List<Items>> items2;
  Future<List<Items>> items3;
  Future<List<Items>> items4;
  Future<List<Items>> items5;

  Future<List<Items>> runes1;
  Future<List<Items>> runes2;
  Future<List<Items>> runes3;
  Future<List<Items>> runes4;

  Future<List<Items>> spells1;
  Future<List<Items>> spells2;
  Future<List<Items>> spells3;
  Future<List<Items>> spells4;
  String _connectionStatus = 'Unknown';
  Future<String> counters;

  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;

  //The values that are passed when changing quality
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  TabController _tabController2;
  var currentIndex;
  List<Widget> _generalWidgets = List<Widget>();
  List<Tab> _tabs = List<Tab>();
  final int _startingTabCount = 3;
  Widget tabBodyInner = Container(
    color: FitnessAppTheme.background,
  );
  bool firstTabOne = true;
  bool firstTabTwo = true;
  var skillTapIndex = 0;
  var videoShwe = true;

  final greenKey = new GlobalKey();
  final blueKey = new GlobalKey();
  final orangeKey = new GlobalKey();
  final yellowKey = new GlobalKey();
  ScrollController scrollController;
  TabController _tabController;

  void initState() {
    _initializeAndPlay(widget.video);
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

    infos = fetchInfos(widget.id);
    abilities = fetchAbilities(widget.id);

    // Use the controller to loop the video.
    _tabs = getTabs(_startingTabCount);
    _tabController2 = getTabController();
    //_tabController2.index = 0;
    _tabController2.addListener(_handleTabSelection);
//    tabBodyInner = TestScreen();
    currentIndex = 0;

    super.initState();
    scrollController = ScrollController();
    _tabController = new TabController(length: 4, vsync: this);

    // initConnectivityCR();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatusCR);
  }

  Future<Abilities> fetchAbilities(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getSkillDetailsByChampionId.php?id='+id);
    print('https://hninsunyein.me/rift_plus/rift_plus/api/getSkillDetailsByChampionId.php?id='+id);
    // Use the compute function to run parsePhotos in a separate isolate.
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Abilities.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<Combos>> fetchPlayStyleCombos(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getChampPlayStyleCombos.php?id=' + id);
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      print(response.toString());
      Iterable list = jsonObject["combos"];
      var cbos = list.map((combos) => Combos.fromJson(combos)).toList();
      return cbos;

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Counters>> fetchWeaksCounters(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getCountersById.php?id=' + id);
    //print(response.body);
    if (response.statusCode == 200) {

      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject['weaks'];
      var wk = list.map((weaks) => Counters.fromJson(weaks)).toList();
      return wk;

      // Iterable list = jsonObject["combos"];
      // var cbos = list.map((combos) => Combos.fromJson(combos)).toList();
      // return cbos;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Counters>> fetchStrongsCounters(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getCountersById.php?id=' + id);
    //print(response.body);
    if (response.statusCode == 200) {

      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject['strongs'];
      var wk = list.map((strongs) => Counters.fromJson(strongs)).toList();
      return wk;

      // Iterable list = jsonObject["combos"];
      // var cbos = list.map((combos) => Combos.fromJson(combos)).toList();
      // return cbos;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Counters>> fetchMatesCounters(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getCountersById.php?id=' + id);
    //print(response.body);
    if (response.statusCode == 200) {

      Map<String, dynamic> jsonObject = json.decode(response.toString());
      print('mates + ' + response.toString());
      Iterable list = jsonObject['mates'];
      var wk = list.map((mates) => Counters.fromJson(mates)).toList();
      return wk;

      // Iterable list = jsonObject["combos"];
      // var cbos = list.map((combos) => Combos.fromJson(combos)).toList();
      // return cbos;

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Ads> fetchAds() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/champAds.php');

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

  Future<List<Items>> fetchItems1ById(id, type1, type2) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getCBuildsByChampionId.php?id='+id);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonStr = jsonDecode(response.toString());
      Map<String, dynamic> jsonObject = json.decode(jsonEncode(jsonStr[type1]));
      Iterable list = jsonObject[type2];
      var its = list.map((items1) => Items.fromJson(items1)).toList();
      return its;

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Items>> fetchItem1Response(item) async{
    print('shwe shwe' + item);
    Map<String, dynamic> jsonObject = json.decode(item);
    Iterable list = jsonObject['items1'];
    var its = list.map((items1) => Items.fromJson(items1)).toList();
    return its;
  }


  Tab getTab(int widgetNumber) {
    return Tab(
      icon: currentIndex == 0 ? Image.asset(
        'assets/images/championroleicons/all_icon.png',
        height: 25,): Image.asset(
        'assets/images/championroleicons/tank_icon.png',
        height: 25,),
    );
  }

  Future<void> _handleTabSelection() {
    setState(() {
      currentIndex = _tabController2.index;
    });
    if (_tabController2.indexIsChanging) {
      switch (_tabController2.index) {
        case 1:
          if (firstTabOne) {
            setState(() {
              combos = fetchPlayStyleCombos(widget.id);
              weaks = fetchWeaksCounters(widget.id);
              strongs = fetchStrongsCounters(widget.id);
              mates = fetchMatesCounters(widget.id);
              print('hererererererer      ' + counters.toString());
            });

            firstTabOne = false;
          }
          break;
        case 2:
          if (firstTabTwo) {
            // itemsBuild = fetchItemsBuild(widget.id);
            setState(() {
              items1 = fetchItems1ById(widget.id, 'items','items_1');
              items2 = fetchItems1ById(widget.id, 'items','items_2');
              items3 = fetchItems1ById(widget.id, 'items','items_3');
              items4 = fetchItems1ById(widget.id, 'items','items_4');
              items5 = fetchItems1ById(widget.id, 'items','items_5');

              runes1 = fetchItems1ById(widget.id, 'runes','runes_1');
              runes2 = fetchItems1ById(widget.id, 'runes','runes_2');
              runes3 = fetchItems1ById(widget.id, 'runes','runes_3');
              runes4 = fetchItems1ById(widget.id, 'runes','runes_4');

              spells1 = fetchItems1ById(widget.id, 'spells','spells_1');
              spells2 = fetchItems1ById(widget.id, 'spells','spells_2');
              spells3 = fetchItems1ById(widget.id, 'spells','spells_3');
              spells4 = fetchItems1ById(widget.id, 'spells','spells_4');
            });


            firstTabTwo = false;
          }
      }
    }
  }



  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      _tabs.add(getTab(i));
    }
    return _tabs;
  }

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _disposed = true;
    _timerVisibleControl?.cancel();
    _exitFullScreen();
    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;

//    _controller?.pause()?.then((_) {
//      _controller.dispose();
//    });


    // _connectivitySubscription.cancel();
    _tabController2.dispose();
    super.dispose();

  }


  // Future<void> initConnectivityCR() async {
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
  //   return _updateConnectionStatusCR(result);
  // }
  //
  // Future<void> _updateConnectionStatusCR(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //       //print('wifi here');
  //       //infos = fetchInfos(widget.id);
  //       //abilities = fetchAbilities(widget.id);
  //       //_showCupertinoDialog();
  //       break;
  //     case ConnectivityResult.mobile:
  //       //print('mobile');
  //       //infos = fetchInfos(widget.id);
  //       //abilities = fetchAbilities(widget.id);
  //       //_showCupertinoDialog();
  //       break;
  //     case ConnectivityResult.none:
  //       //print('none');
  //       setState(() => _connectionStatus = result.toString());
  //       //_showCupertinoDialog();
  //       break;
  //     default:
  //       //print('failed');
  //       setState(() => _connectionStatus = 'Failed to get connectivity.');
  //       //_showCupertinoDialog();
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: AppTheme.secBgColor,
        body: SafeArea(
          top: true,
          child: Stack(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top: 56.0),
                child: Container(
                  color: AppTheme.priBgColor,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
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
                            ),
                          ],
                        ),
                      ),
                      makeTabBarHeader(),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: SizedBox.expand(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _tabController2,
                                  children: getWidgets(),
                                ),
                              ),
                            )
                            // Container(
                            //   key: greenKey,
                            //   height: 800,
                            //   color: Colors.green,
                            // ),
                            // Container(
                            //   key: blueKey,
                            //   height: 800,
                            //   color: Colors.blue,
                            // ),
                            // Container(
                            //   key: orangeKey,
                            //   height: 800,
                            //   color: Colors.orange,
                            // ),
                            // Container(
                            //   key: yellowKey,
                            //   height: 800,
                            //   color: Colors.yellow,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              appBar(),
            ],
          ),
        )
    );
  }

  Widget _buildListItemOne(BuildContext context, snapshot) {

    return SizedBox();
//    final record = RecordDetailOne.fromSnapshot(data);
//    return Expanded(
//      child: Container(
//        decoration: BoxDecoration(
//            color: Colors.transparent,
//            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//            border: Border.all(color: Colors.transparent)),
//        child: Material(
//          color: Colors.transparent,
//          child: InkWell(
//            splashColor: Colors.transparent,
//            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
//            onTap: () {
////                                  setState(() {
////                                    categoryType = categoryTypeData;
////                                  });
//            },
//            child: Padding(
//              padding: const EdgeInsets.only(
//                  top: 0, bottom: 12, left: 10, right: 10),
//              child: Container(
//                decoration: BoxDecoration(
//                    border: Border(
//                      bottom: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                      top: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                      left: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                      right: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                    )
//                ),
//                child: Center(
//                    child: Image.asset(
//                      'assets/images/champions/img_ahri.png',)
//                ),
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
  }

  List<Widget> getWidgets() {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(getWidget(i));
    }
    return _generalWidgets;
  }

  Widget getWidget(int widgetNumber) {
    if (widgetNumber == 0) {
      variHeight = 400;
      return ChampionRouteTabOne(id: widget.id, video: widget.video);
    } else if (widgetNumber == 1){
      variHeight = 600;
      return ScreenOneFighter();
    } else if (widgetNumber == 2) {
      variHeight = 800;
      return ScreenOneTank();
    }
  }

  Widget appBar() {
//    print(st);
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
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
  String skillComboNo(image) {
    if(image.contains('p.png')) {
      return 'P';
    } else if(image.contains('1.png')) {
      return '1';
    } else if(image.contains('2.png')) {
      return '2';
    } else if(image.contains('3.png')) {
      return '3';
    } else if(image.contains('4.png')) {
      return 'U';
    } else if(image.contains('a.png')) {
      return 'A';
    }
  }
  String abilityData(userDocument, type) {
    //print('abilityData' + userDocument.skillp_image);

    if(type == 'name') {
      if(skillTapIndex == 0) {
        return userDocument.skillp_name;
      } else if(skillTapIndex == 1) {
        return userDocument.skill1_name;
      } else if(skillTapIndex == 2) {
        return userDocument.skill2_name;
      } else if(skillTapIndex == 3) {
        return userDocument.skill3_name;
      } else {
        return userDocument.skill4_name;
      }
    } else if (type == 'desc'){
      if(skillTapIndex == 0) {
        return (userDocument.skillp_desc as String).replaceAll("\\n", "\n");
      } else if(skillTapIndex == 1) {
        return (userDocument.skill1_desc as String).replaceAll("\\n", "\n");
      } else if(skillTapIndex == 2) {
        return (userDocument.skill2_desc as String).replaceAll("\\n", "\n");
      } else if(skillTapIndex == 3) {
        return (userDocument.skill3_desc as String).replaceAll("\\n", "\n");
      } else {
        return (userDocument.skill4_desc as String).replaceAll("\\n", "\n");
      }
    } else if (type == 'name2'){
      if(skillTapIndex == 0) {
        return userDocument.skillp_name2;
      } else if(skillTapIndex == 1) {
        return userDocument.skill1_name2;
      } else if(skillTapIndex == 2) {
        return userDocument.skill2_name2;
      } else if(skillTapIndex == 3) {
        return userDocument.skill3_name2;
      } else {
        return userDocument.skill4_name2;
      }
    } else if (type == 'colddown'){
      if(skillTapIndex == 0) {
        return userDocument.skillp_cooldown;
      } else if(skillTapIndex == 1) {
        return userDocument.skill1_cooldown;
      } else if(skillTapIndex == 2) {
        return userDocument.skill2_cooldown;
      } else if(skillTapIndex == 3) {
        return userDocument.skill3_cooldown;
      } else {
        return userDocument.skill4_cooldown;
      }
    } else if (type == 'mana'){
      if(skillTapIndex == 0) {
        return userDocument.skillp_mana;
      } else if(skillTapIndex == 1) {
        return userDocument.skill1_mana;
      } else if(skillTapIndex == 2) {
        return userDocument.skill2_mana;
      } else if(skillTapIndex == 3) {
        return userDocument.skill3_mana;
      } else {
        return userDocument.skill4_mana;
      }
    }
  }



  VideoPlayerCust(skillp,skill1,skill2,skill3,skill4) {
//    return Container();
    var size = MediaQuery.of(context).size;
    var width = size.width - 40;
    var height = width * (9/16);
    return skillp != '' ? Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          width: width,
          height: height,
          child: _playView(context),
        ),
      ),
    ): Container();
  }

  set _isPlaying(bool value) {
    _playing = value;
    _timerVisibleControl?.cancel();
    if (value) {
      _timerVisibleControl = Timer(Duration(seconds: 2), () {
        if (_disposed) return;
        setState(() {
          _controlAlpha = 0.0;
        });
      });
    } else {
      _timerVisibleControl = Timer(Duration(milliseconds: 200), () {
        if (_disposed) return;
        setState(() {
          _controlAlpha = 1.0;
        });
      });
    }
  }

  void _onTapVideo() {
    debugPrint("_onTapVideo $_controlAlpha");
    setState(() {
      _controlAlpha = _controlAlpha > 0 ? 0 : 1;
    });
    _timerVisibleControl?.cancel();
    _timerVisibleControl = Timer(Duration(seconds: 2), () {
      if (_isPlaying) {
        setState(() {
          _controlAlpha = 0.0;
        });
      }
    });
  }

  VideoPlayerController _controller;

  List<VideoClip> get _clips {
    return VideoClip.remoteClips;
  }

  var _playingIndex = -1;
  var _disposed = false;
  var _isFullScreen = false;
  var _isEndOfClip = false;
  var _progress = 0.0;
  var _showingDialog = false;
  Timer _timerVisibleControl;
  double _controlAlpha = 1.0;

  var _playing = false;
  bool get _isPlaying {
    return _playing;
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;

    if (controller != null && controller.value.initialized) {
      return AspectRatio(
        //aspectRatio: controller.value.aspectRatio,
        aspectRatio: 16.0 / 9.0,
        child: Stack(
          children: <Widget>[
            // GestureDetector(
            //   child: VideoPlayer(controller),
            //   // onTap: _onTapVideo,
            // ),
            VideoPlayer(controller),
            // _controlAlpha > 0
            //     ? AnimatedOpacity(
            //   opacity: _controlAlpha,
            //   duration: Duration(milliseconds: 250),
            //   child: _controlView(context),
            // )
            //     : Container(),

            AnimatedOpacity(
              opacity: _controller.value.isPlaying == false || _position?.inMilliseconds + 700 >= _duration?.inMilliseconds? 1:0,
              duration: Duration(milliseconds: 250),
              child: Center(
                child: new ClipRect(
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: GestureDetector(
                      onTap: () async {
                        await controller.seekTo(Duration.zero);
                        setState(() {
                          controller.play();
                        });
                      },
                      child: new Container(
                        // width: width,
                        // height: height,
                        decoration: new BoxDecoration(
                            color: Colors.black45.withOpacity(0.1)
                        ),
                        child: new Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border(
                                  bottom: BorderSide(color: AppTheme.activeIcon, width: 2.5),
                                  top: BorderSide(color: AppTheme.activeIcon, width: 2.5),
                                  left: BorderSide(color: AppTheme.activeIcon, width: 2.5),
                                  right: BorderSide(color: AppTheme.activeIcon, width: 2.5),
                                )
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: AppTheme.activeIcon,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _controlView(context)
          ],
        ),
      );
    } else {
      return AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Center(
            // child: Text(
            //   "Preparing ...",
            //   style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18.0),
            // )),
            child: Container(
              color: Colors.black,
              child:
              Center(child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                  child: CupertinoActivityIndicator(radius: 12,))),

            ),
          )
      );
    }
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
            height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
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
              height: 1.3,
              color: AppTheme.invisibility,
              letterSpacing: 0,
              //fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtiv>') + 8);
      }


    }
    textSpan.children.add(
      TextSpan(
        text: abilityData,
        style: TextStyle(
          fontFamily: 'spiegel',
          height: 1.3,
          fontSize: 15,
          color: AppTheme
              .labTextActive,
          letterSpacing: 0,
        ),
      ),
    );
    return textSpan;
//    return RichText(
//        text: TextSpan(
//            style: Theme.of(context).textTheme.body1,
//            children: [
//              WidgetSpan(
//                child: Padding(
//                  padding: const EdgeInsets.only(right: 5.0),
//                  child: Icon(
//                    RiftPlusIcons.cooldown,
//                    color: AppTheme.coolDown2,
//                    size: 15,
//                  ),
//                ),
//              ),
//              TextSpan(
//                text: '',
//                style: TextStyle(
//                  fontFamily: 'spiegel',
//                  fontSize: 15,
//                  color: AppTheme
//                      .labTextActive,
//                  letterSpacing: 0,
//                  fontWeight: FontWeight.w600,
//                ),
//              ),
//              WidgetSpan(
//                child: Padding(
//                  padding: const EdgeInsets.only(left: 10.0, right: 5.0),
//                  child: Icon(
//                    RiftPlusIcons.mana,
//                    color: AppTheme.mana,
//                    size: 15,
//                  ),
//                ),
//              ),
//              TextSpan(
//                text: '',
//                style: TextStyle(
//                  fontFamily: 'spiegel',
//                  fontSize: 15,
//                  color: AppTheme
//                      .labTextActive,
//                  letterSpacing: 0,
//                  fontWeight: FontWeight.w600,
//                ),
//              )
//            ]
//        )
//    );
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Material Dialog",textScaleFactor: 1.0,),
          content: new Text("Hey! I'm Coflutter!",textScaleFactor: 1.0,),
          actions: <Widget>[
            FlatButton(
              child: Text('Close me!',textScaleFactor: 1.0,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  void _toggleFullscreen() async {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _enterFullScreen() async {
    debugPrint("enterFullScreen");
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = true;
    });
  }

  void _exitFullScreen() async {
    debugPrint("exitFullScreen");
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_disposed) return;
    setState(() {
      _isFullScreen = false;
    });
  }

  void _initializeAndPlay(String index) async {
    print("_initializeAndPlay ---------> $index");
    // final clip = _clips[index];
    //
    // final controller = clip.parent.startsWith("http")
    //     ? VideoPlayerController.network(clip.videoPath())
    //     : VideoPlayerController.asset(clip.videoPath());

    final controller = VideoPlayerController.network(index);

    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdated);
      old.pause();
      debugPrint("---- old contoller paused.");
    }

    debugPrint("---- controller changed.");
    setState(() {});

    controller
      ..initialize().then((_) {
        debugPrint("---- controller initialized");
        old?.dispose();
        // _playingIndex = index;
        _duration = null;
        // controller.setLooping(false);
        _position = null;
        controller.addListener(_onControllerUpdated);
        // controller.play();
        setState(() {});
      });
  }

  var _updateProgressInterval = 0.0;
  Duration _duration;
  Duration _position;

  void _onControllerUpdated() async {
    if (_disposed) return;
    // blocking too many updation
    // important !!
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_updateProgressInterval > now) {
      return;
    }
    _updateProgressInterval = now + 500.0;

    final controller = _controller;
    if (controller == null) return;
    if (!controller.value.initialized) return;
    if (_duration == null) {
      _duration = _controller.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    _position = position;
    final playing = controller.value.isPlaying;
    final isEndOfClip = position.inMilliseconds > 0 && position.inMilliseconds + 200 >= duration.inMilliseconds;
    if (playing) {
      // handle progress indicator
      if (_disposed) return;
      setState(() {
        _progress = position.inMilliseconds.ceilToDouble() / duration.inMilliseconds.ceilToDouble();
      });
    }

    //handle clip end
    if (_isPlaying != playing || _isEndOfClip != isEndOfClip) {
      _isPlaying = playing;
      _isEndOfClip = isEndOfClip;
      debugPrint("updated -----> isPlaying=$playing / isEndOfClip=$isEndOfClip");
      if (isEndOfClip && !playing) {
        debugPrint("========================== End of Clip / Handle NEXT ========================== ");
        final isComplete = _playingIndex == _clips.length - 1;
        if (isComplete) {
          // print("played all!!");
          // if (!_showingDialog) {
          //   _showingDialog = true;
          //   _showPlayedAllDialog().then((value) {
          //     _exitFullScreen();
          //     _showingDialog = false;
          //   });
          // }
        } else {
          // _initializeAndPlay(_playingIndex + 1);
        }
      }
    }
  }

  Future<bool> _showPlayedAllDialog() async {
    return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(child: Text("Played all videos.", textScaleFactor: 1.0,)),
            actions: <Widget>[
              FlatButton(
                child: Text("Close", textScaleFactor: 1.0,),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          );
        });
  }

  void _onTapCard(int index) {
    // _initializeAndPlay(index);
  }

  Widget _listView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _clips.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          splashColor: Colors.blue[100],
          onTap: () {
            _onTapCard(index);
          },
          child: _buildCard(index),
        );
      },
    ).build(context);
  }

  Widget _controlView(BuildContext context) {
    return Column(
      children: <Widget>[
        //_topUI(),
        // Expanded(
        //   child: _centerUI(),
        // ),
        Expanded(
          child: Container(),
        ),

        // _bottomUI()
      ],
    );
  }

  Widget _centerUI() {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                // final index = _playingIndex - 1;
                // if (index > 0 && _clips.length > 0) {
                //   _initializeAndPlay(index);
                // }
              },
              child: Icon(
                Icons.fast_rewind,
                size: 36.0,
                color: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () async {
                // if (_isPlaying) {
                //   _controller?.pause();
                //   _isPlaying = false;
                // } else {
                //   final controller = _controller;
                //   if (controller != null) {
                //     final pos = _position?.inSeconds ?? 0;
                //     final dur = _duration?.inSeconds ?? 0;
                //     final isEnd = pos == dur;
                //     if (isEnd) {
                //       _initializeAndPlay(_playingIndex);
                //     } else {
                //       controller.play();
                //     }
                //   }
                // }
                // setState(() {});
              },
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 56.0,
                color: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () async {
                // final index = _playingIndex + 1;
                // if (index < _clips.length - 1) {
                //   _initializeAndPlay(index);
                // }
              },
              child: Icon(
                Icons.fast_forward,
                size: 36.0,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _topUI() {
    final noMute = (_controller?.value?.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    // final min = convertTwo(remained ~/ 60.0);
    // final sec = convertTwo(remained % 60);
    //final min = _position?.inMilliseconds;
    final min = _controller.value.position;
    final sec = _controller.value.isPlaying;
    // final sec = _controller.value.duration;
    //final sec = _duration?.inMilliseconds;
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(offset: const Offset(0.0, 0.0), blurRadius: 4.0, color: Color.fromARGB(50, 0, 0, 0)),
                ]),
                child: Icon(
                  noMute ? Icons.volume_up : Icons.volume_off,
                  color: Colors.transparent,
                )),
          ),
          onTap: () {
            if (noMute) {
              _controller?.setVolume(0);
            } else {
              _controller?.setVolume(1.0);
            }
            setState(() {});
          },
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          "$min:$sec",
          textScaleFactor: 1.0,
          style: TextStyle(
            fontFamily: 'spiegel',
            color: AppTheme.labTextActive,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 4.0,
                color: Color.fromARGB(150, 0, 0, 0),
              ),
            ],
          ),
        ),
        SizedBox(width: 10)
      ],
    );
  }

  Widget _bottomUI() {
    return Row(
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
          child: Slider(
            value: max(0, min(_progress * 100, 100)),
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _progress = value * 0.01;
              });
            },
            onChangeStart: (value) {
              debugPrint("-- onChangeStart $value");
              _controller?.pause();
            },
            onChangeEnd: (value) {
              debugPrint("-- onChangeEnd $value");
              final duration = _controller?.value?.duration;
              if (duration != null) {
                var newValue = max(0, min(value, 99)) * 0.01;
                var millis = (duration.inMilliseconds * newValue).toInt();
                _controller?.seekTo(Duration(milliseconds: millis));
                _controller?.play();
              }
            },
          ),
        ),
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.yellow,
          icon: Icon(
            Icons.fullscreen,
            color: Colors.white,
          ),
          onPressed: _toggleFullscreen,
        ),
      ],
    );
  }

  Widget _buildCard(int index) {
    final clip = _clips[index];
    final playing = index == _playingIndex;
    String runtime;
    if (clip.runningTime > 60) {
      runtime = "${clip.runningTime ~/ 60}분 ${clip.runningTime % 60}초";
    } else {
      runtime = "${clip.runningTime % 60}초";
    }
    return Card(
      child: Container(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: clip.parent.startsWith("http")
                  ? Image.network(clip.thumbPath(), width: 70, height: 50, fit: BoxFit.fill)
                  : Image.asset(clip.thumbPath(), width: 70, height: 50, fit: BoxFit.fill),
            ),
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(clip.title, textScaleFactor: 1.0,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Padding(
                      child: Text("$runtime", textScaleFactor: 1.0,style: TextStyle(color: Colors.grey[500])),
                      padding: EdgeInsets.only(top: 3),
                    )
                  ]),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: playing
                  ? Icon(Icons.play_arrow)
                  : Icon(
                Icons.play_arrow,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }


  SliverPersistentHeader makeTabBarHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
          minHeight: 50.0,
          maxHeight: 50.0,
          // child: Container(
          //   color: Colors.white,
          //   child: TabBar(
          //     onTap: (val) {},
          //     unselectedLabelColor: Colors.grey.shade700,
          //     indicatorColor: Colors.red,
          //     indicatorWeight: 2.0,
          //     labelColor: Colors.red,
          //     controller: _tabController2,
          //     tabs: <Widget>[
          //       new Tab(
          //         child: Text(
          //           "Green",
          //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          //         ),
          //       ),
          //       new Tab(
          //         child: Text(
          //           "Blue",
          //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          //         ),
          //       ),
          //       new Tab(
          //         child: Text(
          //           "Orange",
          //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          //         ),
          //       ),
          //       new Tab(
          //         child: Text(
          //           "Yellow",
          //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          //         ),
          //       ),
          //     ],
          //     indicatorSize: TabBarIndicatorSize.tab,
          //   ),
          // ),
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
                controller: _tabController2,
              )
          )
      ),
    );
  }


}


class VideoClip {
  final String fileName;
  final String thumbName;
  final String title;
  final String parent;
  int runningTime;

  VideoClip(this.title, this.fileName, this.thumbName, this.runningTime, this.parent);

  String videoPath() {
    return "$parent/$fileName";
  }

  String thumbPath() {
    return "$parent/$thumbName";
  }


  static List<VideoClip> localClips = [
    VideoClip("Small", "small.mp4", "small.png", 6, "embed"),
    VideoClip("Earth", "earth.mp4", "earth.png", 13, "embed"),
    VideoClip("Giraffe", "giraffe.mp4", "giraffe.png", 18, "embed"),
    VideoClip("Particle", "particle.mp4", "particle.png", 11, "embed"),
    VideoClip("Summer", "summer.mp4", "summer.png", 8, "embed")
  ];

  static List<VideoClip> remoteClips = [
    VideoClip("For Bigger Fun", "ForBiggerFun.mp4", "images/ForBiggerFun.jpg", 0, "https://hninsunyein.me/rift_plus/heros/leesin/leesin_p.mp4"),
    VideoClip("Elephant Dream", "ElephantsDream.mp4", "images/ForBiggerBlazes.jpg", 0, "https://hninsunyein.me/rift_plus/heros/leesin/leesin_p.mp4"),
    VideoClip("BigBuckBunny", "BigBuckBunny.mp4", "images/BigBuckBunny.jpg", 0, "https://hninsunyein.me/rift_plus/heros/leesin/leesin_p.mp4"),
  ];
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
