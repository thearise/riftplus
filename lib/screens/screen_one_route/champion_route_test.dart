import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
// import 'package:connectivity/connectivity.dart';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/screen_one_route/pos_lane_detail.dart';
import 'package:riftplus02/screens/screen_one_route/pos_pref_info.dart';
import 'package:riftplus02/screens/screen_one_route/report_detail_page.dart';
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
import 'package:riftplus02/screens/screen_one_route/spellsdetail_route.dart';
import 'package:riftplus02/screens/screen_one_route/runesdetail_route.dart';
import 'package:riftplus02/screens/screen_one_route/itemsdetail_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chewie/chewie.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';
import '../../apptheme.dart';
import '../../fintness_app_theme.dart';
import '../app.dart';
import '../dropdown_pos.dart';
import 'combo_video_route.dart';
import 'dragon_lane.dart';
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
  final String ps_desc_en;
  final String ps_skill1;
  final String ps_skill2;
  final String ps_skill3;
  final String ps_skill4;
  final String ps_skill5;
  final String ps_skill6;
  final String ps_skill7;
  final String ps_skill8;
  final String ps_skill9;
  final String ps_skill10;
  final String ps_video;

  Combos({this.id, this.ps_name, this.ps_desc, this.ps_desc_en, this.ps_skill1, this.ps_skill2, this.ps_skill3, this.ps_skill4, this.ps_skill5, this.ps_skill6, this.ps_skill7, this.ps_skill8, this.ps_skill9, this.ps_skill10, this.ps_video});

  factory Combos.fromJson(Map<String, dynamic> json){
    return Combos(
      id: json['id'],
      ps_name: json['ps_name'],
      ps_desc: json['ps_desc'],
      ps_desc_en: json['ps_desc_en'],
      ps_skill1: json['ps_skill1'],
      ps_skill2: json['ps_skill2'],
      ps_skill3: json['ps_skill3'],
      ps_skill4: json['ps_skill4'],
      ps_skill5: json['ps_skill5'],
      ps_skill6: json['ps_skill6'],
      ps_skill7: json['ps_skill7'],
      ps_skill8: json['ps_skill8'],
      ps_skill9: json['ps_skill9'],
      ps_skill10: json['ps_skill10'],
      ps_video: json['ps_video'],
    );
  }
}


class Counters {
  final String id;
  final String name;
  final String image;
  final String video;

  Counters({this.id, this.name, this.image, this.video});

  factory Counters.fromJson(Map<String, dynamic> json){
    return Counters(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      video: json['video']
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
  final String main_lane;
  final String ps_ml;
  final String utility;
  final String toughness;
  final String damage;
  final String difficulty;
  final String skill_order;

  Infos({this.blue_motes, this.wild_cores, this.main_role, this.main_lane, this.ps_ml, this.utility, this.toughness, this.damage, this.difficulty, this.skill_order});

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
        blue_motes: json['blue_motes'],
        wild_cores: json['wild_cores'],
        main_role: json['main_role'],
        main_lane: json['main_lane'],
        ps_ml: json['ps_ml'],
        utility: json['utility'],
        toughness: json['toughness'],
        damage: json['damage'],
        difficulty: json['difficulty'],
        skill_order: json['skill_order'],
    );
  }
}


class Tips {
  final String playstyle;
  final String playstyle_en;

  Tips({
    this.playstyle,
    this.playstyle_en,
  });

  factory Tips.fromJson(Map<String, dynamic> json){
    return Tips(
      playstyle: json['playstyle'],
      playstyle_en: json['playstyle_en'],
    );
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

class Abilities {
  final String skillp_cooldown;
  final String skillp_desc;
  final String skillp_desc_en;

  final String skillp_image;
  final String skillp_mana;
  final String skillp_name;
  final String skillp_name2;
  final String skillp_video;
  final String skill1_cooldown;
  final String skill1_desc;
  final String skill1_desc_en;

  final String skill1_image;
  final String skill1_mana;
  final String skill1_name;
  final String skill1_name2;
  final String skill1_video;
  final String skill2_cooldown;
  final String skill2_desc;
  final String skill2_desc_en;

  final String skill2_image;
  final String skill2_mana;
  final String skill2_name;
  final String skill2_name2;
  final String skill2_video;
  final String skill3_cooldown;
  final String skill3_desc;
  final String skill3_desc_en;

  final String skill3_image;
  final String skill3_mana;
  final String skill3_name;
  final String skill3_name2;
  final String skill3_video;
  final String skill4_cooldown;
  final String skill4_desc;
  final String skill4_desc_en;

  final String skill4_image;
  final String skill4_mana;
  final String skill4_name;
  final String skill4_name2;
  final String skill4_video;

  Abilities({this.skillp_cooldown, this.skillp_desc, this.skillp_desc_en, this.skillp_image, this.skillp_mana, this.skillp_name, this.skillp_name2, this.skillp_video,
    this.skill1_cooldown, this.skill1_desc, this.skill1_desc_en, this.skill1_image, this.skill1_mana, this.skill1_name, this.skill1_name2, this.skill1_video,
    this.skill2_cooldown, this.skill2_desc, this.skill2_desc_en, this.skill2_image, this.skill2_mana, this.skill2_name, this.skill2_name2, this.skill2_video,
    this.skill3_cooldown, this.skill3_desc, this.skill3_desc_en, this.skill3_image, this.skill3_mana, this.skill3_name, this.skill3_name2, this.skill3_video,
    this.skill4_cooldown, this.skill4_desc, this.skill4_desc_en, this.skill4_image, this.skill4_mana, this.skill4_name, this.skill4_name2, this.skill4_video,
  });

  factory Abilities.fromJson(Map<String, dynamic> json){
    return Abilities(
        skillp_cooldown: json['skillp_cooldown'],
        skillp_desc: json['skillp_desc'],
        skillp_desc_en: json['skillp_desc_en'],

        skillp_image: json['skillp_image'],
        skillp_mana: json['skillp_mana'],
        skillp_name: json['skillp_name'],
        skillp_name2: json['skillp_name2'],
        skillp_video: json['skillp_video'],

        skill1_cooldown: json['skill1_cooldown'],
        skill1_desc: json['skill1_desc'],
        skill1_desc_en: json['skill1_desc_en'],

        skill1_image: json['skill1_image'],
        skill1_mana: json['skill1_mana'],
        skill1_name: json['skill1_name'],
        skill1_name2: json['skill1_name2'],
        skill1_video: json['skill1_video'],

        skill2_cooldown: json['skill2_cooldown'],
        skill2_desc: json['skill2_desc'],
        skill2_desc_en: json['skill2_desc_en'],

        skill2_image: json['skill2_image'],
        skill2_mana: json['skill2_mana'],
        skill2_name: json['skill2_name'],
        skill2_name2: json['skill2_name2'],
        skill2_video: json['skill2_video'],

        skill3_cooldown: json['skill3_cooldown'],
        skill3_desc: json['skill3_desc'],
        skill3_desc_en: json['skill3_desc_en'],

        skill3_image: json['skill3_image'],
        skill3_mana: json['skill3_mana'],
        skill3_name: json['skill3_name'],
        skill3_name2: json['skill3_name2'],
        skill3_video: json['skill3_video'],

        skill4_cooldown: json['skill4_cooldown'],
        skill4_desc: json['skill4_desc'],
        skill4_desc_en: json['skill4_desc_en'],

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
  @override
  bool get wantKeepAlive => true;
  Dio dio;

  int _playBackTime;
  int _playBackTime1;
  int _playBackTime2;
  int _playBackTime3;
  Future<List<Item>> itemsBuild;
  Future<Infos> infos;
  Future<Tips> playstyleTips;
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

  bool abilitiesLoaded = false;

  bool psComboLoaded = false;
  bool psWeaksLoaded = false;
  bool psStrongsLoaded = false;
  bool psMatesLoaded = false;

  bool buildsSp1 = false;
  bool buildsSp2 = false;
  bool buildsSp3 = false;
  bool buildsSp4 = false;
  bool buildsRune1 = false;
  bool buildsRune2 = false;
  bool buildsRune3 = false;
  bool buildsRune4 = false;
  bool buildsItem1 = false;
  bool buildsItem2 = false;
  bool buildsItem3 = false;
  bool buildsItem4 = false;
  bool buildsItem5 = false;


  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  GlobalKey<AppState> _globTwo = GlobalKey();
  Future<Items> itemDetail;



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
  final int _startingTabCount = 5;
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
  Future languages;

  String champSkp;
  String champSk1;
  String champSk2;
  String champSk3;
  String champSk4;

  var champPosVis = false;


  void initState() {
    AppState().increaseGloAdsInt(2);

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
    WidgetsFlutterBinding.ensureInitialized();
    // // Initialize without device test ids.
    // Admob.initialize();
    // Admob.requestTrackingAuthorization();
    ads = fetchAds();
    languages = _getLanguage();
    infos = fetchInfos(widget.id);
    infos.then((val) {
      print('shining star ' + val.skill_order);
      setState(() {
        skill_order = val.skill_order;
      });

    });

    // itemDetail = fetchItemDetailsByName('Kindlegem', 'outside');
    playstyleTips = fetchPlaystyleTips(widget.id);
    abilities = fetchAbilities(widget.id);
    // Use the controller to loop the video.
    _tabs = getTabs(_startingTabCount);
    _tabController2 = getTabController();
    //_tabController2.index = 0;
    _tabController2.addListener(_handleTabSelection);
//    tabBodyInner = TestScreen();
    currentIndex = 0;

    super.initState();
    // initializePlayer();


    scrollController = ScrollController();
    _tabController = new TabController(length: 4, vsync: this);

    combos = fetchPlayStyleCombos(widget.id);
    weaks = fetchWeaksCounters(widget.id);
    strongs = fetchStrongsCounters(widget.id);
    mates = fetchMatesCounters(widget.id);
    print('hererererererer      ' + counters.toString());
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
    //checkFirstSeen();
    //ShowCaseWidget.of(context).startShowCase([_globTwo]);

    // initConnectivityCR();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatusCR);
  }


  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenChamp') ?? false);

    if (_seen) {
      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new Home()));
    } else {
      await prefs.setBool('seenChamp', true);
      // ShowCaseWidget.of(context).startShowCase([_globTwo]);
      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }


  Future<Abilities> fetchAbilities(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getSkillDetailsByChampionId.php?id='+id);
    print('https://hninsunyein.me/rift_plus/rift_plus/api/getSkillDetailsByChampionId.php?id='+id);
    // Use the compute function to run parsePhotos in a separate isolate.
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        abilitiesLoaded = true;
      });
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
      setState(() {
        psComboLoaded = true;
      });
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
      setState(() {
        psWeaksLoaded = true;
      });
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
      setState(() {
        psStrongsLoaded = true;
      });
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
      setState(() {
        psMatesLoaded = true;
      });
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

  Future<Tips> fetchPlaystyleTips(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getPlaystyleTipsById.php?id='+id);

    // Use the compute function to run parsePhotos in a separate isolate.

    if (response.statusCode == 200) {
      print('HERE HAYYYYYY Playstyle' + response.toString());
      return Tips.fromJson(jsonDecode(response.toString()));
    } else {
      throw Exception('Failed to load album');
    }
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

  Future<List<Items>> fetchItems1ById(id, type1, type2) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getCBuildsByChampionId.php?id='+id);
    if (response.statusCode == 200) {
      if(type2 == 'spells_1') {
        setState(() {
          buildsSp1 = true;
        });
      } else if(type2 == 'spells_2') {
        setState(() {
          buildsSp2 = true;
        });
      } else if(type2 == 'spells_3') {
        setState(() {
          buildsSp3 = true;
        });
      } else if(type2 == 'spells_4') {
        setState(() {
          buildsSp4 = true;
        });
      } else if(type2 == 'runes_1') {
        setState(() {
          buildsRune1 = true;
        });
      } else if(type2 == 'runes_2') {
        setState(() {
          buildsRune2 = true;
        });
      } else if(type2 == 'runes_3') {
        setState(() {
          buildsRune3 = true;
        });
      } else if(type2 == 'runes_4') {
        setState(() {
          buildsRune4 = true;
        });
      } else if(type2 == 'items_1') {
        setState(() {
          buildsItem1 = true;
        });
      } else if(type2 == 'items_2') {
        setState(() {
          buildsItem2 = true;
        });
      } else if(type2 == 'items_3') {
        setState(() {
          buildsItem3 = true;
        });
      } else if(type2 == 'items_4') {
        setState(() {
          buildsItem4 = true;
        });
      } else if(type2 == 'items_5') {
        setState(() {
          buildsItem5 = true;
        });
      }
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
      champPosVis = false;
    });
    // if (_tabController2.indexIsChanging) {
    //   switch (_tabController2.index) {
    //     case 1:
    //       if (firstTabOne) {
    //         // combos = fetchPlayStyleCombos(widget.id);
    //         // weaks = fetchWeaksCounters(widget.id);
    //         // strongs = fetchStrongsCounters(widget.id);
    //         // mates = fetchMatesCounters(widget.id);
    //         // print('hererererererer      ' + counters.toString());
    //         // items1 = fetchItems1ById(widget.id, 'items','items_1');
    //         // items2 = fetchItems1ById(widget.id, 'items','items_2');
    //         // items3 = fetchItems1ById(widget.id, 'items','items_3');
    //         // items4 = fetchItems1ById(widget.id, 'items','items_4');
    //         // items5 = fetchItems1ById(widget.id, 'items','items_5');
    //         //
    //         // runes1 = fetchItems1ById(widget.id, 'runes','runes_1');
    //         // runes2 = fetchItems1ById(widget.id, 'runes','runes_2');
    //         // runes3 = fetchItems1ById(widget.id, 'runes','runes_3');
    //         // runes4 = fetchItems1ById(widget.id, 'runes','runes_4');
    //         //
    //         // spells1 = fetchItems1ById(widget.id, 'spells','spells_1');
    //         // spells2 = fetchItems1ById(widget.id, 'spells','spells_2');
    //         // spells3 = fetchItems1ById(widget.id, 'spells','spells_3');
    //         // spells4 = fetchItems1ById(widget.id, 'spells','spells_4');
    //
    //         firstTabOne = false;
    //       }
    //       break;
    //     case 2:
    //       if (firstTabTwo) {
    //         // items1 = fetchItems1ById(widget.id, 'items','items_1');
    //         // items2 = fetchItems1ById(widget.id, 'items','items_2');
    //         // items3 = fetchItems1ById(widget.id, 'items','items_3');
    //         // items4 = fetchItems1ById(widget.id, 'items','items_4');
    //         // items5 = fetchItems1ById(widget.id, 'items','items_5');
    //         //
    //         // runes1 = fetchItems1ById(widget.id, 'runes','runes_1');
    //         // runes2 = fetchItems1ById(widget.id, 'runes','runes_2');
    //         // runes3 = fetchItems1ById(widget.id, 'runes','runes_3');
    //         // runes4 = fetchItems1ById(widget.id, 'runes','runes_4');
    //         //
    //         // spells1 = fetchItems1ById(widget.id, 'spells','spells_1');
    //         // spells2 = fetchItems1ById(widget.id, 'spells','spells_2');
    //         // spells3 = fetchItems1ById(widget.id, 'spells','spells_3');
    //         // spells4 = fetchItems1ById(widget.id, 'spells','spells_4');
    //
    //
    //         firstTabTwo = false;
    //       }
    //   }
    // }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.transparent,
    primary: Colors.transparent,
    minimumSize: Size(50, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );



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

    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();

    super.dispose();

  }

  Future<void> initializePlayer() async {
    // _videoPlayerController1 = VideoPlayerController.network(
    //     'https://vod-progressive.akamaized.net/exp=1621866467~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F2747%2F14%2F363737105%2F1496953606.mp4~hmac=338a92b333db6f4c0bfbcb79de889d01ee5e426bfbdf1e9b664456e4b76042bd/vimeo-prod-skyfire-std-us/01/2747/14/363737105/1496953606.mp4');
    _videoPlayerController1 = VideoPlayerController.network(
        'https://hninsunyein.me/rift_plus/heros/ziggs/ziggs_1.mp4');
    _videoPlayerController2 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      // subtitle: Subtitles([
      //   Subtitle(
      //     index: 0,
      //     start: Duration.zero,
      //     end: const Duration(seconds: 10),
      //     text: 'Hello from subtitles',
      //   ),
      //   Subtitle(
      //     index: 0,
      //     start: const Duration(seconds: 10),
      //     end: const Duration(seconds: 20),
      //     text: 'Whats up? :)',
      //   ),
      // ]),
      // subtitleBuilder: (context, subtitle) => Container(
      //   padding: const EdgeInsets.all(10.0),
      //   child: Text(
      //     subtitle,
      //     style: const TextStyle(color: Colors.white),
      //   ),
      // ),


      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
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

  var orderPosIndex = '0';
  String skill_order = 'mid-111111111111111,no-no,no-no';
  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   orderPosIndex = '0';
    // });
    
    List _testList = [{'no': 'EN', 'keyword': 'english'},{'no': 'MM', 'keyword': 'burmese'},{'no': 'EN', 'keyword': 'english'},];
    List<DropdownMenuItem> _dropdownTestItems;
    _dropdownTestItems = buildDropdownTestItems(_testList);

    return Scaffold(
        backgroundColor: AppTheme.secBgColor,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              champPosVis = false;
            });
          },
          child: SafeArea(
            top: true,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 56.0),
                  child: Container(
                    color: AppTheme.priBgColor,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustomScrollView(
                          controller: scrollController,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Container(
                                    color: AppTheme.thirdBgColor,
                                    child: Row(
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
                                                  // child: Image(
                                                  //   image: NetworkImage(widget.image),
                                                  //   width: 120,
                                                  //   height: 120,
                                                  // ),
                                                    child: CachedNetworkImage(
                                                        imageUrl: widget.image,
                                                        width: 120,
                                                        height: 120,
                                                        placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        fadeInDuration: Duration(milliseconds: 100),
                                                        fadeOutDuration: Duration(milliseconds: 10),
                                                        fadeInCurve: Curves.bounceIn
                                                    )
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
                                                        top: 10, bottom: 0, left: 20, right: 10),
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
                                                              height: 25,
                                                              child: ListView(
                                                                scrollDirection: Axis.horizontal,
                                                                children: [
                                                                  _mainRole(snapshot.data.main_lane.split('/')[0], 0, 'in', '',context),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[0], 1, 'in', '',context),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[0], 2, 'in', '',context),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[0], 3, 'in', '',context),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Container(color: Colors.white38, height: 23, width: 1,),
                                                                  ),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[1], 0, 'in', snapshot.data.main_lane.split('/')[0],context),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[1], 1, 'in', snapshot.data.main_lane.split('/')[0],context),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[1], 2, 'in', snapshot.data.main_lane.split('/')[0],context),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Container(color: Colors.white38, height: 23, width: 1,),
                                                                  ),
                                                                  _mainRole(snapshot.data.main_lane.split('/')[1], 3, 'in', '', context),
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
                                  ),
                                ],
                              ),
                            ),
                            makeTabBarHeader(),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                                    child: Column(
                                      children: [
                                        IndexedStack(
                                          children: <Widget>[
                                            Visibility(
                                              child: Container(
                                                // constraints: BoxConstraints(
                                                //     minHeight: MediaQuery.of(context).size.height-200),
                                                child: Stack(
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    Visibility(
                                                      visible: !abilitiesLoaded,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:180.0),
                                                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                                            child: CupertinoActivityIndicator(radius: 12,)),
                                                      ),
                                                    ),
                                                    FutureBuilder(
                                                        future: Future.wait([abilities, languages]),
                                                        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                                          if (snapshot.hasData) {
                                                            champSkp = snapshot.data[0].skillp_name;
                                                            champSk1 = snapshot.data[0].skill1_name;
                                                            champSk2 = snapshot.data[0].skill2_name;
                                                            champSk3 = snapshot.data[0].skill3_name;
                                                            champSk4 = snapshot.data[0].skill4_name;
                                                            return Container(
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10, bottom:0.0),
                                                                    child: Container(
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    border: Border.all(color: Colors.transparent)),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        skillTapIndex = 0;
                                                                                      });
                                                                                      _initializeAndPlay(snapshot.data[0].skillp_video);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(
                                                                                          top: 0, bottom: 12, left: 10, right: 10),
                                                                                      child: Container(

                                                                                        child: Center(
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: skillTapIndex==0? AppTheme.borderColor: Colors.transparent, width: 1.5),

                                                                                              ),
                                                                                              // child: FadeInImage.assetNetwork(
                                                                                              //   placeholder: 'assets/images/system/black-square.png',
                                                                                              //   fadeInDuration: Duration(milliseconds: 10),
                                                                                              //   image: snapshot.data[0].skillp_image,
                                                                                              //   fit: BoxFit.cover,
                                                                                              // ),
                                                                                              child: CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[0].skillp_image,
                                                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                  fadeInDuration: Duration(milliseconds: 100),
                                                                                                  fadeOutDuration: Duration(milliseconds: 10),
                                                                                                  fadeInCurve: Curves.bounceIn
                                                                                              ),
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    border: Border.all(color: Colors.transparent)),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        skillTapIndex = 1;
                                                                                      });
                                                                                      _initializeAndPlay(snapshot.data[0].skill1_video);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(
                                                                                          top: 0, bottom: 12, left: 10, right: 10),
                                                                                      child: Container(

                                                                                        child: Center(
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: skillTapIndex==1? AppTheme.borderColor: Colors.transparent, width: 1.5),

                                                                                              ),
                                                                                              child: CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[0].skill1_image,
                                                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                  fadeInDuration: Duration(milliseconds: 100),
                                                                                                  fadeOutDuration: Duration(milliseconds: 10),
                                                                                                  fadeInCurve: Curves.bounceIn
                                                                                              ),
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    border: Border.all(color: Colors.transparent)),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        skillTapIndex = 2;
                                                                                      });
                                                                                      _initializeAndPlay(snapshot.data[0].skill2_video);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(
                                                                                          top: 0, bottom: 12, left: 10, right: 10),
                                                                                      child: Container(

                                                                                        child: Center(
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: skillTapIndex==2? AppTheme.borderColor: Colors.transparent, width: 1.5),

                                                                                              ),
                                                                                              child: CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[0].skill2_image,
                                                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                  fadeInDuration: Duration(milliseconds: 100),
                                                                                                  fadeOutDuration: Duration(milliseconds: 10),
                                                                                                  fadeInCurve: Curves.bounceIn
                                                                                              ),
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    border: Border.all(color: Colors.transparent)),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        skillTapIndex = 3;
                                                                                      });
                                                                                      _initializeAndPlay(snapshot.data[0].skill3_video);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(
                                                                                          top: 0, bottom: 12, left: 10, right: 10),
                                                                                      child: Container(

                                                                                        child: Center(
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: skillTapIndex==3? AppTheme.borderColor: Colors.transparent, width: 1.5),

                                                                                              ),
                                                                                              child: CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[0].skill3_image,
                                                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                  fadeInDuration: Duration(milliseconds: 100),
                                                                                                  fadeOutDuration: Duration(milliseconds: 10),
                                                                                                  fadeInCurve: Curves.bounceIn
                                                                                              ),
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    border: Border.all(color: Colors.transparent)),
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        skillTapIndex = 4;
                                                                                      });
                                                                                      _initializeAndPlay(snapshot.data[0].skill4_video);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(
                                                                                          top: 0, bottom: 12, left: 10, right: 10),
                                                                                      child: Container(

                                                                                        child: Center(
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: skillTapIndex==4? AppTheme.borderColor: Colors.transparent, width: 1.5),

                                                                                              ),
                                                                                              child: CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[0].skill4_image,
                                                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                  fadeInDuration: Duration(milliseconds: 100),
                                                                                                  fadeOutDuration: Duration(milliseconds: 10),
                                                                                                  fadeInCurve: Curves.bounceIn
                                                                                              ),
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                                      child: Column(
                                                                        children: [
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Container(
                                                                              child: Text(
                                                                                abilityData(snapshot.data[0], 'name'),
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'spiegel',
                                                                                  fontSize: 18,
                                                                                  color: AppTheme.labTextActive,
                                                                                  letterSpacing: 0.3,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 3,
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Container(
                                                                              child: Text(
                                                                                abilityData(snapshot.data[0], 'name2'),
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'spiegel',
                                                                                  fontSize: 16,
                                                                                  color: AppTheme.blueAccent,
                                                                                  letterSpacing: 0.3,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top:10.0, bottom:10.0),
                                                                              child: Container(
                                                                                child: RichText(
                                                                                    textScaleFactor: 1.0,
                                                                                    text: TextSpan(
                                                                                        style: Theme.of(context).textTheme.body1,
                                                                                        children: [
                                                                                          WidgetSpan(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(right: 5.0),
                                                                                              child: Icon(
                                                                                                RiftPlusIcons.cooldown,
                                                                                                color: AppTheme.coolDown2,
                                                                                                size: 15,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          abilityData(snapshot.data[0], 'colddown')!='0'?
                                                                                          TextSpan(
                                                                                            text: abilityData(snapshot.data[0], 'colddown'),
                                                                                            style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              fontSize: 15,
                                                                                              color: AppTheme
                                                                                                  .labTextActive,
                                                                                              letterSpacing: 0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          ):
                                                                                          TextSpan(
                                                                                            text: 'No Cooldown',
                                                                                            style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              fontSize: 14,
                                                                                              color: AppTheme
                                                                                                  .labTextActive,
                                                                                              letterSpacing: 0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          )
                                                                                          ,
                                                                                          abilityData(snapshot.data[0], 'mana').contains('mana')?
                                                                                          WidgetSpan(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                                                                              child: Icon(
                                                                                                RiftPlusIcons.mana_1,
                                                                                                color: AppTheme.mana,
                                                                                                size: 15,
                                                                                              ),
                                                                                            ),
                                                                                          ):TextSpan()
                                                                                          ,
                                                                                          abilityData(snapshot.data[0], 'mana').contains('energy')?
                                                                                          WidgetSpan(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                                                                              child: Icon(
                                                                                                RiftPlusIcons.energy,
                                                                                                color: AppTheme.energy,
                                                                                                size: 15,
                                                                                              ),
                                                                                            ),
                                                                                          ):TextSpan()
                                                                                          ,
                                                                                          abilityData(snapshot.data[0], 'mana').contains('fury')?
                                                                                          WidgetSpan(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                                                                              child: Icon(
                                                                                                RiftPlusIcons.mana_1,
                                                                                                color: AppTheme.criticalStrike,
                                                                                                size: 15,
                                                                                              ),
                                                                                            ),
                                                                                          ):TextSpan()
                                                                                          ,
                                                                                          abilityData(snapshot.data[0], 'mana').contains('health')?
                                                                                          WidgetSpan(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                                                                                              child: Icon(
                                                                                                RiftPlusIcons.health,
                                                                                                color: AppTheme.health,
                                                                                                size: 15,
                                                                                              ),
                                                                                            ),
                                                                                          ):TextSpan()
                                                                                          ,
                                                                                          abilityData(snapshot.data[0], 'mana')!='0'?
                                                                                          TextSpan(
                                                                                            text: abilityData(snapshot.data[0], 'mana').split('-')[1].trim(),
                                                                                            style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              fontSize: 14,
                                                                                              color: AppTheme
                                                                                                  .labTextActive,
                                                                                              letterSpacing: 0,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          ): TextSpan()
                                                                                        ]
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10.0,
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.topLeft,
                                                                            child: Container(
                                                                                child: RichText(text: modifyDesc(abilityData(snapshot.data[0], 'desc'+snapshot.data[1].toString())),textScaleFactor: 1.0)
                                                                            ),
                                                                          ),
                                                                          VideoPlayerCust(snapshot.data[0].skillp_video,snapshot.data[0].skill1_video,snapshot.data[0].skill2_video,snapshot.data[0].skill3_video,snapshot.data[0].skill4_video,),
                                                                          //modifyDesc(abilityData(userDocument, 'desc'))

                                                                        ],
                                                                      )

                                                                  ),
                                                                  SizedBox(
                                                                    height: 60
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                          return Container();
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              maintainState: true,
                                              visible: currentIndex == 0,
                                            ),
                                            Visibility(
                                              child: Container(
                                                // constraints: BoxConstraints(
                                                //     minHeight: MediaQuery.of(context).size.height-200),
                                                // height: MediaQuery.of(context).size.height - 200,
                                                child: Stack(
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(top:180.0),
                                                    //   child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                                    //       child: CupertinoActivityIndicator(radius: 12,)),
                                                    // ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2.0),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Container(
                                                              child: Text(
                                                                'Recommended spells',
                                                                textScaleFactor: 1.0,
                                                                style: TextStyle(
                                                                  fontFamily: 'spiegel',
                                                                  fontSize: 18,
                                                                  color: AppTheme.labTextActive,
                                                                  letterSpacing: 0.3,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ResponsiveGridRow(
                                                            children: [
                                                              ResponsiveGridCol(
                                                                xs: 6,
                                                                md: 6,
                                                                child: FutureBuilder<List<Items>>(
                                                                    future: spells1,
                                                                    builder: (context, snapshot) {
                                                                      var size = MediaQuery.of(context).size;

                                                                      /*24 is for notification bar on Android*/
                                                                      //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                      final double containerHeight = size.width / 5;
                                                                      if (snapshot.hasData) {
                                                                        //print('here ' + snapshot.data.skill1_image);
                                                                        return Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  snapshot.data[0].name,
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.blueAccent,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                                height: containerHeight,
                                                                                child: GridView.builder(
                                                                                  padding: const EdgeInsets.only(
                                                                                      top: 15, left: 20, right: 20, bottom: 10),
                                                                                  physics: const BouncingScrollPhysics(),
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemCount: snapshot.data.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Tooltip(
                                                                                      verticalOffset: -69,
                                                                                      message: snapshot.data[index].item_name,
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
                                                                                      child: AspectRatio(
                                                                                        aspectRatio: 1.5,
                                                                                        child: ClipRRect(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                          child: Stack(
                                                                                            alignment: AlignmentDirectional.center,
                                                                                            children: <Widget>[
                                                                                              CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[index].item_image,
                                                                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                  fadeInDuration: Duration(milliseconds: 100),
                                                                                                  fadeOutDuration: Duration(milliseconds: 10),
                                                                                                  fadeInCurve: Curves.bounceIn
                                                                                              ),
                                                                                              // Image(
                                                                                              //   image: AssetImage('assets/images/system/' + snapshot.data[index].item_name.toLowerCase() + '.png'),
                                                                                              //   fit: BoxFit.cover,
                                                                                              // ),
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
                                                                                                            builder: (context) => SpellsDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, cooldown: snapshot.data[index].item_other1, desc: snapshot.data[index].item_other2, sugg: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                                    mainAxisSpacing: 15.0,
                                                                                    crossAxisSpacing: 20.0,
                                                                                    childAspectRatio: 1,
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ],
                                                                        );
                                                                      } else if (snapshot.hasError){
                                                                        print(snapshot.error.toString());
                                                                      }
                                                                      return Container();
                                                                    }
                                                                ),
                                                              ),
                                                              ResponsiveGridCol(
                                                                xs: 6,
                                                                md: 6,
                                                                child: FutureBuilder<List<Items>>(
                                                                    future: spells2,
                                                                    builder: (context, snapshot) {
                                                                      var size = MediaQuery.of(context).size;

                                                                      /*24 is for notification bar on Android*/
                                                                      //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                      final double containerHeight = size.width / 5;
                                                                      if (snapshot.hasData) {
                                                                        //print('here ' + snapshot.data.skill1_image);
                                                                        return Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  snapshot.data[0].name,
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.blueAccent,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                                height: containerHeight,
                                                                                child: GridView.builder(
                                                                                  padding: const EdgeInsets.only(
                                                                                      top: 15, left: 20, right: 20, bottom: 10),
                                                                                  physics: const BouncingScrollPhysics(),
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemCount: snapshot.data.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Tooltip(
                                                                                      verticalOffset: -69,
                                                                                      message: snapshot.data[index].item_name,
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
                                                                                      child: AspectRatio(
                                                                                        aspectRatio: 1.5,
                                                                                        child: ClipRRect(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                          child: Stack(
                                                                                            alignment: AlignmentDirectional.center,
                                                                                            children: <Widget>[
                                                                                              CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[index].item_image,
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
                                                                                                            builder: (context) => SpellsDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, cooldown: snapshot.data[index].item_other1, desc: snapshot.data[index].item_other2, sugg: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                                    mainAxisSpacing: 15.0,
                                                                                    crossAxisSpacing: 20.0,
                                                                                    childAspectRatio: 1,
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ],
                                                                        );
                                                                      } else if (snapshot.hasError){
                                                                        print(snapshot.error.toString());
                                                                      }
                                                                      return Container();
                                                                    }
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                        FutureBuilder<List<Items>>(
                                                            future: spells3,
                                                            builder: (context, snapshot) {
                                                              if (snapshot.hasData) {
                                                                return SizedBox(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                        ),
                                                                      ),
                                                                    )
                                                                );
                                                              }
                                                              return Container();
                                                            }
                                                        ),
                                                        ResponsiveGridRow(
                                                            children: [
                                                              ResponsiveGridCol(
                                                                xs: 6,
                                                                md: 6,
                                                                child: FutureBuilder<List<Items>>(
                                                                    future: spells3,
                                                                    builder: (context, snapshot) {
                                                                      var size = MediaQuery.of(context).size;

                                                                      /*24 is for notification bar on Android*/
                                                                      //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                      final double containerHeight = size.width / 5;
                                                                      if (snapshot.hasData) {
                                                                        //print('here ' + snapshot.data.skill1_image);
                                                                        return Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  snapshot.data[0].name,
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.blueAccent,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                                height: containerHeight,
                                                                                child: GridView.builder(
                                                                                  padding: const EdgeInsets.only(
                                                                                      top: 15, left: 20, right: 20, bottom: 10),
                                                                                  physics: const BouncingScrollPhysics(),
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemCount: snapshot.data.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Tooltip(
                                                                                      verticalOffset: -69,
                                                                                      message: snapshot.data[index].item_name,
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
                                                                                      child: AspectRatio(
                                                                                        aspectRatio: 1.5,
                                                                                        child: ClipRRect(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                          child: Stack(
                                                                                            alignment: AlignmentDirectional.center,
                                                                                            children: <Widget>[
                                                                                              CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[index].item_image,
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
                                                                                                            builder: (context) => SpellsDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, cooldown: snapshot.data[index].item_other1, desc: snapshot.data[index].item_other2, sugg: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                                    mainAxisSpacing: 15.0,
                                                                                    crossAxisSpacing: 20.0,
                                                                                    childAspectRatio: 1,
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ],
                                                                        );
                                                                      } else if (snapshot.hasError){
                                                                        print(snapshot.error.toString());
                                                                      }
                                                                      return Container();
                                                                    }
                                                                ),
                                                              ),
                                                              ResponsiveGridCol(
                                                                xs: 6,
                                                                md: 6,
                                                                child: FutureBuilder<List<Items>>(
                                                                    future: spells4,
                                                                    builder: (context, snapshot) {
                                                                      var size = MediaQuery.of(context).size;

                                                                      /*24 is for notification bar on Android*/
                                                                      //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                      final double containerHeight = size.width / 5;
                                                                      if (snapshot.hasData) {
                                                                        //print('here ' + snapshot.data.skill1_image);
                                                                        return Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  snapshot.data[0].name,
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.blueAccent,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                                height: containerHeight,
                                                                                child: GridView.builder(
                                                                                  padding: const EdgeInsets.only(
                                                                                      top: 15, left: 20, right: 20, bottom: 10),
                                                                                  physics: const BouncingScrollPhysics(),
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemCount: snapshot.data.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Tooltip(
                                                                                      verticalOffset: -69,
                                                                                      message: snapshot.data[index].item_name,
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
                                                                                      child: AspectRatio(
                                                                                        aspectRatio: 1.5,
                                                                                        child: ClipRRect(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                          child: Stack(
                                                                                            alignment: AlignmentDirectional.center,
                                                                                            children: <Widget>[
                                                                                              CachedNetworkImage(
                                                                                                  imageUrl: snapshot.data[index].item_image,
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
                                                                                                            builder: (context) => SpellsDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, cooldown: snapshot.data[index].item_other1, desc: snapshot.data[index].item_other2, sugg: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                                    mainAxisSpacing: 15.0,
                                                                                    crossAxisSpacing: 20.0,
                                                                                    childAspectRatio: 1,
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ],
                                                                        );
                                                                      } else if (snapshot.hasError){
                                                                        print(snapshot.error.toString());
                                                                      }
                                                                      return Container();
                                                                    }
                                                                ),
                                                              ),
                                                            ]
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 20.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.black26,
                                                                border: Border(top: BorderSide(color: AppTheme.lineColor, width: 1.0), bottom:BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 15.0),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0, bottom: 2.0),
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Container(
                                                                        child: Text(
                                                                          'Runes build',
                                                                          textScaleFactor: 1.0,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 18,
                                                                            color: AppTheme.labTextActive,
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  FutureBuilder<List<Items>>(
                                                                      future: runes1,
                                                                      builder: (context, snapshot) {
                                                                        var size = MediaQuery.of(context).size;

                                                                        /*24 is for notification bar on Android*/
                                                                        //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                        final double containerHeight = size.width / 4.3;
                                                                        if (snapshot.hasData) {
                                                                          //print('here ' + snapshot.data.skill1_image);
                                                                          return Column(
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                  child: Text(
                                                                                    snapshot.data[0].name,
                                                                                    textScaleFactor: 1,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'spiegel',
                                                                                      fontSize: 16,
                                                                                      color: AppTheme.blueAccent,
                                                                                      letterSpacing: 0.3,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                  height: containerHeight,
                                                                                  child: GridView.builder(
                                                                                    padding: const EdgeInsets.only(
                                                                                        top: 15, left: 20, right: 20, bottom: 10),
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: snapshot.data.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return Tooltip(
                                                                                        verticalOffset: -69,
                                                                                        message: snapshot.data[index].item_name,
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
                                                                                        child: AspectRatio(
                                                                                          aspectRatio: 1.5,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                            child: Stack(
                                                                                              alignment: AlignmentDirectional.center,
                                                                                              children: <Widget>[
                                                                                                // FadeInImage.assetNetwork(
                                                                                                //   placeholder: 'assets/images/system/black-square.png',
                                                                                                //   fadeInDuration: Duration(milliseconds: 10),
                                                                                                //   image: snapshot.data[index].item_image,
                                                                                                //   fit: BoxFit.cover,
                                                                                                // ),
                                                                                                CachedNetworkImage(
                                                                                                    imageUrl: snapshot.data[index].item_image,
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
                                                                                                              builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, pros: snapshot.data[index].item_other2, video: snapshot.data[index].item_video))
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
                                                                                      mainAxisSpacing: 15.0,
                                                                                      crossAxisSpacing: 20.0,
                                                                                      childAspectRatio: 1,
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                            ],
                                                                          );
                                                                        } else if (snapshot.hasError){
                                                                          print(snapshot.error.toString());
                                                                        }
                                                                        return Container();
                                                                      }
                                                                  ),
                                                                  FutureBuilder<List<Items>>(
                                                                      future: runes2,
                                                                      builder: (context, snapshot) {
                                                                        var size = MediaQuery.of(context).size;

                                                                        /*24 is for notification bar on Android*/
                                                                        //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                        final double containerHeight = size.width / 4.3;
                                                                        if (snapshot.hasData) {
                                                                          //print('here ' + snapshot.data.skill1_image);
                                                                          return Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                  child: Text(
                                                                                    snapshot.data[0].name,
                                                                                    textScaleFactor: 1,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'spiegel',
                                                                                      fontSize: 16,
                                                                                      color: AppTheme.blueAccent,
                                                                                      letterSpacing: 0.3,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                  height: containerHeight,
                                                                                  child: GridView.builder(
                                                                                    padding: const EdgeInsets.only(
                                                                                        top: 15, left: 20, right: 20, bottom: 10),
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: snapshot.data.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return Tooltip(
                                                                                        verticalOffset: -69,
                                                                                        message: snapshot.data[index].item_name,
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
                                                                                        child: AspectRatio(
                                                                                          aspectRatio: 1.5,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                            child: Stack(
                                                                                              alignment: AlignmentDirectional.center,
                                                                                              children: <Widget>[
                                                                                                // FadeInImage.assetNetwork(
                                                                                                //   placeholder: 'assets/images/system/black-square.png',
                                                                                                //   fadeInDuration: Duration(milliseconds: 10),
                                                                                                //   image: snapshot.data[index].item_image,
                                                                                                //   fit: BoxFit.cover,
                                                                                                // ),
                                                                                                CachedNetworkImage(
                                                                                                    imageUrl: snapshot.data[index].item_image,
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
                                                                                                              builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, pros: snapshot.data[index].item_other2, video: snapshot.data[index].item_video))
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
                                                                                      mainAxisSpacing: 15.0,
                                                                                      crossAxisSpacing: 20.0,
                                                                                      childAspectRatio: 1,
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                            ],
                                                                          );
                                                                        } else if (snapshot.hasError){
                                                                          print(snapshot.error.toString());
                                                                        }
                                                                        return Container();
                                                                      }
                                                                  ),
                                                                  FutureBuilder<List<Items>>(
                                                                      future: runes3,
                                                                      builder: (context, snapshot) {
                                                                        var size = MediaQuery.of(context).size;

                                                                        /*24 is for notification bar on Android*/
                                                                        //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                        final double containerHeight = size.width / 4.3;
                                                                        if (snapshot.hasData) {
                                                                          //print('here ' + snapshot.data.skill1_image);
                                                                          return Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                  child: Text(
                                                                                    snapshot.data[0].name,
                                                                                    textScaleFactor: 1,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'spiegel',
                                                                                      fontSize: 16,
                                                                                      color: AppTheme.blueAccent,
                                                                                      letterSpacing: 0.3,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                  height: containerHeight,
                                                                                  child: GridView.builder(
                                                                                    padding: const EdgeInsets.only(
                                                                                        top: 15, left: 20, right: 20, bottom: 10),
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: snapshot.data.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return Tooltip(
                                                                                        verticalOffset: -69,
                                                                                        message: snapshot.data[index].item_name,
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
                                                                                        child: AspectRatio(
                                                                                          aspectRatio: 1.5,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                            child: Stack(
                                                                                              alignment: AlignmentDirectional.center,
                                                                                              children: <Widget>[
                                                                                                CachedNetworkImage(
                                                                                                    imageUrl: snapshot.data[index].item_image,
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
                                                                                                              builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, pros: snapshot.data[index].item_other2, video: snapshot.data[index].item_video))
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
                                                                                      mainAxisSpacing: 15.0,
                                                                                      crossAxisSpacing: 20.0,
                                                                                      childAspectRatio: 1,
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                            ],
                                                                          );
                                                                        } else if (snapshot.hasError){
                                                                          print(snapshot.error.toString());
                                                                        }
                                                                        return Container();

                                                                      }
                                                                  ),
                                                                  FutureBuilder<List<Items>>(
                                                                      future: runes4,
                                                                      builder: (context, snapshot) {
                                                                        var size = MediaQuery.of(context).size;

                                                                        /*24 is for notification bar on Android*/
                                                                        //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                                        final double containerHeight = size.width / 4.3;
                                                                        if (snapshot.hasData) {
                                                                          //print('here ' + snapshot.data.skill1_image);
                                                                          return Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                  child: Text(
                                                                                    snapshot.data[0].name,
                                                                                    textScaleFactor: 1,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'spiegel',
                                                                                      fontSize: 16,
                                                                                      color: AppTheme.blueAccent,
                                                                                      letterSpacing: 0.3,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                  height: containerHeight,
                                                                                  child: GridView.builder(
                                                                                    padding: const EdgeInsets.only(
                                                                                        top: 15, left: 20, right: 20, bottom: 10),
                                                                                    physics: const BouncingScrollPhysics(),
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: snapshot.data.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return Tooltip(
                                                                                        verticalOffset: -69,
                                                                                        message: snapshot.data[index].item_name,
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
                                                                                        child: AspectRatio(
                                                                                          aspectRatio: 1.5,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                            child: Stack(
                                                                                              alignment: AlignmentDirectional.center,
                                                                                              children: <Widget>[
                                                                                                CachedNetworkImage(
                                                                                                    imageUrl: snapshot.data[index].item_image,
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
                                                                                                              builder: (context) => RunesDetailRoute(id: snapshot.data[index].id, image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, pros: snapshot.data[index].item_other2, video: snapshot.data[index].item_video))
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
                                                                                      mainAxisSpacing: 15.0,
                                                                                      crossAxisSpacing: 20.0,
                                                                                      childAspectRatio: 1,
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                            ],
                                                                          );
                                                                        } else if (snapshot.hasError){
                                                                          print(snapshot.error.toString());
                                                                        }
                                                                        return Container();
                                                                      }
                                                                  ),
                                                                  SizedBox(height: 5.0)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0, bottom: 2.0),
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Container(
                                                              child: Text(
                                                                'Items build',
                                                                textScaleFactor: 1.0,
                                                                style: TextStyle(
                                                                  fontFamily: 'spiegel',
                                                                  fontSize: 18,
                                                                  color: AppTheme.labTextActive,
                                                                  letterSpacing: 0.3,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        FutureBuilder<List<Items>>(
                                                            future: items1,
                                                            builder: (context, snapshot) {
                                                              var size = MediaQuery.of(context).size;

                                                              /*24 is for notification bar on Android*/
                                                              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                              final double containerHeight = size.width / 5;
                                                              if (snapshot.hasData) {
                                                                //print('here ' + snapshot.data.skill1_image);
                                                                return Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment: Alignment.topLeft,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                        child: Text(
                                                                          snapshot.data[0].name,
                                                                          textScaleFactor: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 16,
                                                                            color: AppTheme.blueAccent,
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: containerHeight,
                                                                        child: GridView.builder(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15, left: 20, right: 20, bottom: 10),
                                                                          physics: const BouncingScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemCount: snapshot.data.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Tooltip(
                                                                              verticalOffset: -69,
                                                                              message: snapshot.data[index].item_name,
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
                                                                              child: AspectRatio(
                                                                                aspectRatio: 1.5,
                                                                                child: ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                  child: Stack(
                                                                                    alignment: AlignmentDirectional.center,
                                                                                    children: <Widget>[
                                                                                      CachedNetworkImage(
                                                                                          imageUrl: snapshot.data[index].item_image,
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
                                                                                                    builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, price:snapshot.data[index].item_other2, type: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                            mainAxisSpacing: 15.0,
                                                                            crossAxisSpacing: 20.0,
                                                                            childAspectRatio: 1,
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                );
                                                              } else if (snapshot.hasError){
                                                                print(snapshot.error.toString());
                                                              }
                                                              return Container();
                                                            }
                                                        ),

                                                        FutureBuilder<List<Items>>(
                                                            future: items2,
                                                            builder: (context, snapshot) {
                                                              var size = MediaQuery.of(context).size;

                                                              /*24 is for notification bar on Android*/
                                                              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                              final double containerHeight = size.width / 5;
                                                              if (snapshot.hasData) {
                                                                //print('here ' + snapshot.data.skill1_image);
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.topLeft,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                        child: Text(
                                                                          snapshot.data[0].name,
                                                                          textScaleFactor: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 16,
                                                                            color: AppTheme.blueAccent,
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: containerHeight,
                                                                        child: GridView.builder(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15, left: 20, right: 20, bottom: 10),
                                                                          physics: const BouncingScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemCount: snapshot.data.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Tooltip(
                                                                              verticalOffset: -69,
                                                                              message: snapshot.data[index].item_name,
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
                                                                              child: AspectRatio(
                                                                                aspectRatio: 1.5,
                                                                                child: ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                  child: Stack(
                                                                                    alignment: AlignmentDirectional.center,
                                                                                    children: <Widget>[
                                                                                      CachedNetworkImage(
                                                                                          imageUrl: snapshot.data[index].item_image,
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
                                                                                                    builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, price:snapshot.data[index].item_other2, type: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                            mainAxisSpacing: 15.0,
                                                                            crossAxisSpacing: 20.0,
                                                                            childAspectRatio: 1,
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                );
                                                              } else if (snapshot.hasError){
                                                                print(snapshot.error.toString());
                                                              }
                                                              return Container();
                                                            }
                                                        ),
                                                        FutureBuilder<List<Items>>(
                                                            future: items3,
                                                            builder: (context, snapshot) {
                                                              var size = MediaQuery.of(context).size;

                                                              /*24 is for notification bar on Android*/
                                                              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                              final double containerHeight = size.width / 5;
                                                              if (snapshot.hasData) {
                                                                //print('here ' + snapshot.data.skill1_image);
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.topLeft,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                        child: Text(
                                                                          snapshot.data[0].name,
                                                                          textScaleFactor: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 16,
                                                                            color: AppTheme.blueAccent,
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: containerHeight,
                                                                        child: GridView.builder(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15, left: 20, right: 20, bottom: 10),
                                                                          physics: const BouncingScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemCount: snapshot.data.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Tooltip(
                                                                              verticalOffset: -69,
                                                                              message: snapshot.data[index].item_name,
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
                                                                              child: AspectRatio(
                                                                                aspectRatio: 1.5,
                                                                                child: ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                  child: Stack(
                                                                                    alignment: AlignmentDirectional.center,
                                                                                    children: <Widget>[
                                                                                      CachedNetworkImage(
                                                                                          imageUrl: snapshot.data[index].item_image,
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
                                                                                                    builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, price:snapshot.data[index].item_other2, type: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                            mainAxisSpacing: 15.0,
                                                                            crossAxisSpacing: 20.0,
                                                                            childAspectRatio: 1,
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                );
                                                              } else if (snapshot.hasError){
                                                                print(snapshot.error.toString());
                                                              }
                                                              return Container();

                                                            }
                                                        ),
                                                        FutureBuilder<List<Items>>(
                                                            future: items4,
                                                            builder: (context, snapshot) {
                                                              var size = MediaQuery.of(context).size;

                                                              /*24 is for notification bar on Android*/
                                                              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                              final double containerHeight = size.width / 5;
                                                              if (snapshot.hasData) {
                                                                //print('here ' + snapshot.data.skill1_image);
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.topLeft,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                        child: Text(
                                                                          snapshot.data[0].name,
                                                                          textScaleFactor: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 16,
                                                                            color: AppTheme.blueAccent,
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: containerHeight,
                                                                        child: GridView.builder(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15, left: 20, right: 20, bottom: 10),
                                                                          physics: const BouncingScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemCount: snapshot.data.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Tooltip(
                                                                              verticalOffset: -69,
                                                                              message: snapshot.data[index].item_name,
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
                                                                              child: AspectRatio(
                                                                                aspectRatio: 1.5,
                                                                                child: ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                  child: Stack(
                                                                                    alignment: AlignmentDirectional.center,
                                                                                    children: <Widget>[
                                                                                      CachedNetworkImage(
                                                                                          imageUrl: snapshot.data[index].item_image,
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
                                                                                                    builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, price:snapshot.data[index].item_other2, type: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                            mainAxisSpacing: 15.0,
                                                                            crossAxisSpacing: 20.0,
                                                                            childAspectRatio: 1,
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                );
                                                              } else if (snapshot.hasError){
                                                                print(snapshot.error.toString());
                                                              }
                                                              return Container();
                                                            }
                                                        ),
                                                        FutureBuilder<List<Items>>(
                                                            future: items5,
                                                            builder: (context, snapshot) {
                                                              var size = MediaQuery.of(context).size;

                                                              /*24 is for notification bar on Android*/
                                                              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                                                              final double containerHeight = size.width / 5;
                                                              if (snapshot.hasData) {
                                                                //print('here ' + snapshot.data.skill1_image);
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                            ),
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.topLeft,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                        child: Text(
                                                                          snapshot.data[0].name,
                                                                          textScaleFactor: 1,
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 16,
                                                                            color: AppTheme.blueAccent,
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: containerHeight,
                                                                        child: GridView.builder(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15, left: 20, right: 20, bottom: 10),
                                                                          physics: const BouncingScrollPhysics(),
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemCount: snapshot.data.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Tooltip(
                                                                              verticalOffset: -69,
                                                                              message: snapshot.data[index].item_name,
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
                                                                              child: AspectRatio(
                                                                                aspectRatio: 1.5,
                                                                                child: ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                  child: Stack(
                                                                                    alignment: AlignmentDirectional.center,
                                                                                    children: <Widget>[
                                                                                      CachedNetworkImage(
                                                                                          imageUrl: snapshot.data[index].item_image,
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
                                                                                                    builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_other1, price:snapshot.data[index].item_other2, type: snapshot.data[index].item_other3, video: snapshot.data[index].item_video))
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
                                                                            mainAxisSpacing: 15.0,
                                                                            crossAxisSpacing: 20.0,
                                                                            childAspectRatio: 1,
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                );
                                                              } else if (snapshot.hasError){
                                                                print(snapshot.error.toString());
                                                              }
                                                              return Container();
                                                            }
                                                        ),
                                                        SizedBox(
                                                          height: 80,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              maintainState: true,
                                              visible: currentIndex == 1,
                                            ),
                                            Visibility(
                                              child: Container(
                                                // constraints: BoxConstraints(
                                                //     minHeight: MediaQuery.of(context).size.height-200),
                                                child: Stack(
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    Visibility(
                                                      visible: !(psComboLoaded && psWeaksLoaded && psStrongsLoaded && psMatesLoaded),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:180.0),
                                                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                                            child: CupertinoActivityIndicator(radius: 12,)),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: psComboLoaded && psWeaksLoaded && psStrongsLoaded && psMatesLoaded,
                                                      child: FutureBuilder(
                                                        future: languages,
                                                        builder: (context, snapshotO) {
                                                          if(snapshotO.hasData) {
                                                            return FutureBuilder<List<Combos>> (
                                                              future: combos,
                                                              builder: (context, snapshot) {
                                                                if (snapshot.hasData) {
                                                                  return Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20.0, bottom:1),
                                                                        child: Align(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Container(
                                                                            child: Text(
                                                                              'Combos',
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(
                                                                                fontFamily: 'spiegel',
                                                                                fontSize: 18,
                                                                                color: AppTheme.labTextActive,
                                                                                letterSpacing: 0.3,
                                                                                fontWeight: FontWeight.w600,
                                                                                height: 0.5
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      ListView.builder(
                                                                            shrinkWrap: true,
                                                                            physics: ScrollPhysics(),
                                                                            itemCount: snapshot.data.length,
                                                                            itemBuilder: (context, index) {
                                                                              return Column(
                                                                                children: [
                                                                                  Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Align(
                                                                                            alignment: Alignment.topLeft,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(top: 4.0, left: 20.0, right: 20.0, bottom: 10.0),
                                                                                              child: Text(
                                                                                                snapshot.data[index].ps_name,
                                                                                                textScaleFactor: 1,
                                                                                                textAlign: TextAlign.left,
                                                                                                style: TextStyle(
                                                                                                  fontFamily: 'spiegel',
                                                                                                  fontSize: 16,
                                                                                                  color: AppTheme.blueAccent,
                                                                                                  letterSpacing: 0.3,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        snapshot.data[index].ps_video!=''?Padding(
                                                                                          padding: EdgeInsets.only(top: Platform.isIOS?0:1, right: 20.0, bottom: 0),
                                                                                          child: Tooltip(
                                                                                            verticalOffset: -69,
                                                                                            message: 'Watch combo',
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
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.grey.withOpacity(0.3),
                                                                                                borderRadius:
                                                                                                BorderRadius.circular(2),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(left:10.0, right:10.0, bottom:0),
                                                                                                  child: Icon(
                                                                                                    RiftPlusIcons.video,
                                                                                                    color: AppTheme.activeIcon,
                                                                                                    size: 28,
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  showComboVideo(context, snapshot.data[index].ps_video, snapshot.data[index].ps_skill1, snapshot.data[index].ps_skill2, snapshot.data[index].ps_skill3, snapshot.data[index].ps_skill4
                                                                                                      , snapshot.data[index].ps_skill5, snapshot.data[index].ps_skill6, snapshot.data[index].ps_skill7, snapshot.data[index].ps_skill8
                                                                                                      , snapshot.data[index].ps_skill9, snapshot.data[index].ps_skill10, snapshot.data[index].ps_name, snapshotO.data=='_en'?snapshot.data[index].ps_desc_en.toString():snapshot.data[index].ps_desc.toString());
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ):Container(),

                                                                                      ]
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top:5.0, bottom: 10.0),
                                                                                    child: Container(
                                                                                      height: MediaQuery.of(context).size.width/7.8,
                                                                                      child: ListView(
                                                                                        scrollDirection: Axis.horizontal,

                                                                                        children: [
                                                                                          SizedBox(width: 20,),
                                                                                          snapshot.data[index].ps_skill1 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill1),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill1),
                                                                                                            snapshot.data[index].ps_skill1.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill1),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),


                                                                                          snapshot.data[index].ps_skill2 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill2 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill2),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill2),
                                                                                                            snapshot.data[index].ps_skill2.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill2),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),


                                                                                          snapshot.data[index].ps_skill3 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill3 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill3),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill3),
                                                                                                            snapshot.data[index].ps_skill3.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill3),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),


                                                                                          snapshot.data[index].ps_skill4 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill4 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill4),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill4),
                                                                                                            snapshot.data[index].ps_skill4.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill4),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),


                                                                                          snapshot.data[index].ps_skill5 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill5 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill5),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill5),
                                                                                                            snapshot.data[index].ps_skill5.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill5),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),


                                                                                          snapshot.data[index].ps_skill6 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill6 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill6),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill6),
                                                                                                            snapshot.data[index].ps_skill6.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill6),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),

                                                                                          snapshot.data[index].ps_skill7 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill7 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill7),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill7),
                                                                                                            snapshot.data[index].ps_skill7.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill7),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),

                                                                                          snapshot.data[index].ps_skill8 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill8 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill8),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill8),
                                                                                                            snapshot.data[index].ps_skill8.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill8),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),

                                                                                          snapshot.data[index].ps_skill9 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill9 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill9),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill9),
                                                                                                            snapshot.data[index].ps_skill9.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill9),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),

                                                                                          snapshot.data[index].ps_skill10 != '' ? Container(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                                                                                child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                                                                              )
                                                                                          ): Container(),
                                                                                          snapshot.data[index].ps_skill10 != '' ? Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                border: Border.all(color: Colors.transparent)),
                                                                                            child: Material(
                                                                                              color: Colors.transparent,
                                                                                              child: InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                                                                                onTap: () {

                                                                                                },
                                                                                                child: Center(
                                                                                                    child: Tooltip(
                                                                                                      verticalOffset: -69,
                                                                                                      message: skillComboTooltip(snapshot.data[index].ps_skill10),
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
                                                                                                      child: Container(
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomRight,
                                                                                                          children: [
                                                                                                            _combosImage(snapshot.data[index].ps_skill10),
                                                                                                            snapshot.data[index].ps_skill10.contains('http')?Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: AppTheme.skillNo,
                                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                                              ),
                                                                                                              width: 20,
                                                                                                              height: 20,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  skillComboNo(snapshot.data[index].ps_skill10),
                                                                                                                  textScaleFactor: 1,
                                                                                                                  style: TextStyle(
                                                                                                                      fontFamily: 'spiegel',
                                                                                                                      height: 1,
                                                                                                                      fontSize: 13,
                                                                                                                      color: Colors.black,
                                                                                                                      letterSpacing: 0,
                                                                                                                      fontWeight: FontWeight.w700
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ):Container(),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ):Container(),
                                                                                          SizedBox(width: 20,),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SingleChildScrollView(
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: <Widget>[
                                                                                        Align(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 10.0),
                                                                                            child: ReadMoreText(
                                                                                              snapshotO.data=='_en'?snapshot.data[index].ps_desc_en.toString():snapshot.data[index].ps_desc.toString(),
                                                                                              trimLines: 2,
                                                                                              textScaleFactor: 1,
                                                                                              style: const TextStyle(
                                                                                                  fontSize: 15,
                                                                                                  fontFamily: 'spiegel',
                                                                                                  color: AppTheme.labTextActive,
                                                                                                  height: 1.4
                                                                                              ),
                                                                                              colorClickableText: AppTheme.borderColor,
                                                                                              trimMode: TrimMode.Line,
                                                                                              trimCollapsedText: '... more',
                                                                                              trimExpandedText: '',
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  snapshot.data.length != index+1?
                                                                                  SizedBox(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(top: 5, bottom: 10, left: 20.0, right: 20.0),
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                              border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                  ):SizedBox(height: 10,)
                                                                                ],
                                                                              );
                                                                            }
                                                                      ),
                                                                      SizedBox(
                                                                        height: 70
                                                                      )
                                                                    ],
                                                                  );
                                                                } else {
                                                                  return Container(
                                                                    height:  MediaQuery.of(context).size.height>700.0?(MediaQuery.of(context).size.height)*0.40:(MediaQuery.of(context).size.height)*0.36,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Image(
                                                                            image: AssetImage('assets/images/system/poro_joke.png'),
                                                                            width: 100,
                                                                        ),
                                                                        Text(
                                                                          'UNDER PROGRESS',
                                                                          textScaleFactor: 1.0,
                                                                          style: TextStyle(
                                                                            fontFamily: 'spiegel',
                                                                            fontSize: 18,
                                                                            height: 1.8,
                                                                            color: Colors.white.withOpacity(0.2),
                                                                            letterSpacing: 0.3,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                                return Container();

                                                              },
                                                            );
                                                          }
                                                          return Container();
                                                        }
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              maintainState: true,
                                              visible: currentIndex == 2,
                                            ),
                                            Visibility(
                                              child: skill_order != 'mid-111111111111111,no-no,no-no'? Container(
                                                child: skill_order!=''?Column(
                                                  children: [
                                                    skill_order!=''?Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 2.0),
                                                              child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Container(
                                                                  child: Text(
                                                                    'Skill order analytics',
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(
                                                                      fontFamily: 'spiegel',
                                                                      fontSize: 18,
                                                                      color: AppTheme.labTextActive,
                                                                      letterSpacing: 0.3,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 10.0),
                                                                child: Text(
                                                                  onChangePosText() + ' position',
                                                                  textScaleFactor: 1,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    fontFamily: 'spiegel',
                                                                    fontSize: 16,
                                                                    color: AppTheme.blueAccent,
                                                                    letterSpacing: 0.3,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ]
                                                        ),
                                                        Expanded(
                                                          child: Container()
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 20.0, bottom: 8),
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  if(champPosVis) {
                                                                    setState(() {
                                                                      champPosVis = false;
                                                                    });
                                                                  } else {
                                                                    setState(() {
                                                                      champPosVis = true;
                                                                    });
                                                                  }

                                                                },
                                                                child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: AppTheme.thirdBgColor,
                                                                  borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                                  border: Border(
                                                                    bottom: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                    top: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                    left: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                    right: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                  )
                                                                ),
                                                                width: 57,
                                                                height: 40,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(bottom: 7.0, top:7.0),
                                                                  child: onChangeIconPos()
                                                                  // champPosIcon(skill_order.split(',')[orderPosIndex].split('-')[0])
                                                                ),
                                                              )
                                                              ),
                                                            ),
                                                          ),
                                                        )

                                                      ],
                                                    )
                                                    :Container(),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    skill_order!=''?Padding(
                                                      padding: const EdgeInsets.only(left: 12.0),
                                                      child: Stack(
                                                        alignment: Alignment.topLeft,
                                                        children: [

                                                          Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Column(

                                                              children: [
                                                                Container(
                                                                    height: 266.0,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 60.0),
                                                                      child: new ListView(
                                                                        scrollDirection: Axis.horizontal,
                                                                        children: <Widget>[
                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('0')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '1',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','0'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','0'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','0'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','0'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('1')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '2',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','1'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','1'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','1'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','1'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('2')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '3',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','2'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','2'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','2'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','2'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),



                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('3')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '4',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','3'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','3'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','3'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','3'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('4')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '5',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','4'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','4'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','4'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','4'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),


                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('5')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '6',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','5'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','5'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','5'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','5'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('6')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '7',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','6'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','6'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','6'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','6'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('7')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '8',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','7'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','7'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','7'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','7'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('8')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '9',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','8'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','8'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','8'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','8'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('9')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '10',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','9'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','9'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','9'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','9'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('10')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '11',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','10'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','10'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','10'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','10'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('11')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '12',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','11'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','11'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','11'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','11'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('12')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '13',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','12'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','12'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','12'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','12'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('13')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '14',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','13'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','13'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','13'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','13'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Container(
                                                                            color: AppTheme.priBgColor,
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 30.0, bottom: onChangeSkillDiv('14')),
                                                                                  child: VerticalDivider(
                                                                                    color: Colors.white.withOpacity(0.3),
                                                                                    width: 50,
                                                                                    thickness: 1,
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                    children: [
                                                                                      SizedBox(height: 3),
                                                                                      Text(
                                                                                        '15',
                                                                                        textScaleFactor: 1,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'spiegel',
                                                                                          fontSize: 18,
                                                                                          color: AppTheme
                                                                                              .labTextActive,
                                                                                          letterSpacing: 0.3,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                      SizedBox(
                                                                                            height: 10
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('1','14'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('2','14'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('3','14'),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: onChangeSkillOrder('4','14'),
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          SizedBox(
                                                                            width: 12
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                ),

                                                              ],
                                                            )
                                                          ),
                                                          FutureBuilder(
                                                            future: abilities,
                                                            builder: (context, snapshot) {
                                                              if(snapshot.hasData) {
                                                                return Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Container(
                                                                    color: AppTheme.priBgColor,
                                                                    child: Column(
                                                                        children: [
                                                                          Container(
                                                                            width: 40,
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.black45,
                                                                              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top: 7,right: 0.0, bottom: 7),
                                                                              child: Icon(
                                                                                RiftPlusIcons.levelup,
                                                                                size: 17,
                                                                                color: AppTheme.labTextActive,
                                                                              ),
                                                                            )
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0, right:8.0, top:12.0, ),
                                                                            child: Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              child: Stack(
                                                                                children: [
                                                                                  CachedNetworkImage(
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    imageUrl: snapshot.data.skill1_image,
                                                                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                    fadeInDuration: Duration(milliseconds: 100),
                                                                                    fadeOutDuration: Duration(milliseconds: 10),
                                                                                    fadeInCurve: Curves.bounceIn
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.bottomRight,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppTheme.skillNo,
                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                      ),
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          '1',
                                                                                          textScaleFactor: 1,
                                                                                          style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              height: 1,
                                                                                              fontSize: 12,
                                                                                              color: Colors.black,
                                                                                              letterSpacing: 0,
                                                                                              fontWeight: FontWeight.w700
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  )

                                                                                ],
                                                                              ),

                                                                            )
                                                                          ),

                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0, right:8.0, top:8.0, ),
                                                                            child: Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              child: Stack(
                                                                                children: [
                                                                                  CachedNetworkImage(
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    imageUrl: snapshot.data.skill2_image,
                                                                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                    fadeInDuration: Duration(milliseconds: 100),
                                                                                    fadeOutDuration: Duration(milliseconds: 10),
                                                                                    fadeInCurve: Curves.bounceIn
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.bottomRight,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppTheme.skillNo,
                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                      ),
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          '2',
                                                                                          textScaleFactor: 1,
                                                                                          style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              height: 1,
                                                                                              fontSize: 12,
                                                                                              color: Colors.black,
                                                                                              letterSpacing: 0,
                                                                                              fontWeight: FontWeight.w700
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  )

                                                                                ],
                                                                              ),

                                                                            )
                                                                          ),


                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0, right:8.0, top:8.0, ),
                                                                            child: Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              child: Stack(
                                                                                children: [
                                                                                  CachedNetworkImage(
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    imageUrl: snapshot.data.skill3_image,
                                                                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                    fadeInDuration: Duration(milliseconds: 100),
                                                                                    fadeOutDuration: Duration(milliseconds: 10),
                                                                                    fadeInCurve: Curves.bounceIn
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.bottomRight,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppTheme.skillNo,
                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                      ),
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          '3',
                                                                                          textScaleFactor: 1,
                                                                                          style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              height: 1,
                                                                                              fontSize: 12,
                                                                                              color: Colors.black,
                                                                                              letterSpacing: 1,
                                                                                              fontWeight: FontWeight.w700
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  )

                                                                                ],
                                                                              ),

                                                                            )
                                                                          ),

                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left:8.0, bottom:8.0, right:8.0, top:8.0, ),
                                                                            child: Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              child: Stack(
                                                                                children: [
                                                                                  CachedNetworkImage(
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                    imageUrl: snapshot.data.skill4_image,
                                                                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                    fadeInDuration: Duration(milliseconds: 100),
                                                                                    fadeOutDuration: Duration(milliseconds: 10),
                                                                                    fadeInCurve: Curves.bounceIn
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: Alignment.bottomRight,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppTheme.skillNo,
                                                                                        borderRadius: BorderRadius.circular(2),
                                                                                      ),
                                                                                      width: 18,
                                                                                      height: 18,
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          'U',
                                                                                          textScaleFactor: 1,
                                                                                          style: TextStyle(
                                                                                              fontFamily: 'spiegel',
                                                                                              height: 1,
                                                                                              fontSize: 12,
                                                                                              color: Colors.black,
                                                                                              letterSpacing: 0,
                                                                                              fontWeight: FontWeight.w700
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  )

                                                                                ],
                                                                              ),

                                                                            )
                                                                          ),
                                                                        ]
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              return Container();
                                                            }
                                                          ),


                                                          Align(
                                                            alignment: Alignment.topRight,
                                                            child: Visibility(
                                                              visible: champPosVis,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(right: 20.0, top: 0.0),
                                                                child: skill_order!=''?Container(
                                                                    decoration: BoxDecoration(
                                                                    color: AppTheme.thirdBgColor,
                                                                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                                    border: Border(
                                                                      bottom: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                      top: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                      left: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                      right: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                    )
                                                                  ),
                                                                  child: Container(
                                                                    width: 55,
                                                                    child: ClipRRect(
                                                                      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          !skill_order.split(',')[0].contains('no')?GestureDetector(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                orderPosIndex = '0';
                                                                                champPosVis = false;
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: AppTheme.thirdBgColor,
                                                                              border: !skill_order.split(',')[1].contains('no')?Border(
                                                                                bottom: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                              ):Border(
                                                                                bottom: BorderSide(color: Colors.transparent, width: 0.0),
                                                                              )
                                                                            ),
                                                                            width: 55,
                                                                            height: 40,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(bottom: 3.0, top:3.0),
                                                                              child: orderPosIndex=='0'?champPosIcon(skill_order.split(',')[0].split('-')[0]):champPosIconN(skill_order.split(',')[0].split('-')[0])
                                                                            ),
                                                                          )
                                                                          ):Container(),

                                                                          !skill_order.split(',')[1].contains('no')?GestureDetector(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                orderPosIndex = '1';
                                                                                champPosVis = false;
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: AppTheme.thirdBgColor,
                                                                              border: !skill_order.split(',')[2].contains('no')?Border(
                                                                                bottom: BorderSide(color: AppTheme.lineColor, width: 1.0),
                                                                              ):Border(
                                                                                bottom: BorderSide(color: Colors.transparent, width: 0.0),
                                                                              )
                                                                            ),
                                                                            width: 55,
                                                                            height: 40,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(bottom: 3.0, top:3.0),
                                                                              child: orderPosIndex=='1'?champPosIcon(skill_order.split(',')[1].split('-')[0]):champPosIconN(skill_order.split(',')[1].split('-')[0])
                                                                            ),
                                                                          )
                                                                          ):Container(),

                                                                          !skill_order.split(',')[2].contains('no')?GestureDetector(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                orderPosIndex = '2';
                                                                                champPosVis = false;
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: AppTheme.thirdBgColor,
                                                                            ),
                                                                            width: 55,
                                                                            height: 40,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(bottom: 3.0, top:3.0),
                                                                              child: orderPosIndex=='2'?champPosIcon(skill_order.split(',')[2].split('-')[0]):champPosIconN(skill_order.split(',')[2].split('-')[0])
                                                                            ),
                                                                          )
                                                                          ):Container(),

                                                                        ],
                                                                      )
                                                                    )

                                                                  ),
                                                                ):Container()
                                                              ),
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                    ):Container(),
                                                    skill_order!=''?SizedBox(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 5, bottom: 0, left: 0.0, right: 0.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                            ),
                                                          ),
                                                        )
                                                    ):Container(),
                                                    Container(
                                                      color: AppTheme.thirdBgColor,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 3.0),
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Container(
                                                                child: Text(
                                                                  'Champion analytics',
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                    fontFamily: 'spiegel',
                                                                    fontSize: 18,
                                                                    color: AppTheme.labTextActive,
                                                                    letterSpacing: 0.3,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom:0.0),
                                                              child: Row(
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: AppTheme.secBgColor,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  'Best teammates',
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.blueAccent,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 5.0),
                                                                              child: FutureBuilder(
                                                                                  future: mates,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      return Container(
                                                                                        height: 110,
                                                                                        child: ListView.builder(
                                                                                          shrinkWrap: true,
                                                                                          padding: const EdgeInsets.only(
                                                                                              top: 0, left: 10, right: 10, bottom: 0),
                                                                                          physics: const BouncingScrollPhysics(),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          itemCount: snapshot.data.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return Column(
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 95,
                                                                                                  width: 95,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                                                    child: AspectRatio(
                                                                                                      aspectRatio: 1,
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                                        child: Stack(
                                                                                                          alignment: AlignmentDirectional.center,
                                                                                                          children: <Widget>[
                                                                                                            ClipRRect(
                                                                                                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                                              child: CachedNetworkImage(
                                                                                                                imageUrl: snapshot.data[index].image,
                                                                                                                placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                                fadeInDuration: Duration(milliseconds: 100),
                                                                                                                fadeOutDuration: Duration(milliseconds: 10),
                                                                                                                fadeInCurve: Curves.bounceIn,
                                                                                                                fit: BoxFit.cover,
                                                                                                              ),
                                                                                                            ),


                                                                                                            // FadeInImage.assetNetwork(
                                                                                                            //   placeholder: 'assets/images/system/black-square.png',
                                                                                                            //   fadeInDuration: Duration(milliseconds: 10),
                                                                                                            //   image: snapshot.data[index].image,
                                                                                                            //   fit: BoxFit.cover,
                                                                                                            // ),
                                                                                                            Tooltip(
                                                                                                              verticalOffset: -69,
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                                                                                child: Material(
                                                                                                                  color: Colors.transparent,
                                                                                                                  child: InkWell(
                                                                                                                    splashColor: Colors.transparent,
                                                                                                                    highlightColor: Colors.grey.withOpacity(0.3),
                                                                                                                    borderRadius:
                                                                                                                    const BorderRadius.all(Radius.circular(4.0)),
                                                                                                                    onTap: () {
                                                                                                                      Navigator.of(context).push(
                                                                                                                          MaterialPageRoute(
                                                                                                                              builder: (context) => ChampionRoute(id: snapshot.data[index].id, image: snapshot.data[index].image, name: snapshot.data[index].name, video: snapshot.data[index].video))
                                                                                                                      );
                                                                                                                    },
                                                                                                                  ),
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
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                                                  child: Text(
                                                                                                    snapshot.data[index].name,
                                                                                                    textScaleFactor: 1.0,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'beaufortforlol',
                                                                                                      fontSize: 14,
                                                                                                      color: AppTheme.lightText,
                                                                                                      fontWeight: FontWeight.w700,
                                                                                                      letterSpacing: 0,
                                                                                                      height: 0.5
                                                                                                    ),
                                                                                                    overflow: TextOverflow.fade,
                                                                                                    maxLines: 1,
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    return Container();
                                                                                  }
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 20)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),


                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: AppTheme.secBgColor,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  'Strong against',
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.health,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 5.0),
                                                                              child: FutureBuilder(
                                                                                  future: strongs,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      return Container(
                                                                                        height: 110,
                                                                                        child: ListView.builder(
                                                                                          shrinkWrap: true,
                                                                                          padding: const EdgeInsets.only(
                                                                                              top: 0, left: 10, right: 10, bottom: 0),
                                                                                          physics: const BouncingScrollPhysics(),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          itemCount: snapshot.data.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return Column(
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 95,
                                                                                                  width: 95,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                                                    child: AspectRatio(
                                                                                                      aspectRatio: 1,
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                                        child: Stack(
                                                                                                          alignment: AlignmentDirectional.center,
                                                                                                          children: <Widget>[
                                                                                                            ClipRRect(
                                                                                                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                                              child: CachedNetworkImage(
                                                                                                                imageUrl: snapshot.data[index].image,
                                                                                                                placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                                fadeInDuration: Duration(milliseconds: 100),
                                                                                                                fadeOutDuration: Duration(milliseconds: 10),
                                                                                                                fadeInCurve: Curves.bounceIn,
                                                                                                                fit: BoxFit.cover,
                                                                                                              ),
                                                                                                            ),


                                                                                                            // FadeInImage.assetNetwork(
                                                                                                            //   placeholder: 'assets/images/system/black-square.png',
                                                                                                            //   fadeInDuration: Duration(milliseconds: 10),
                                                                                                            //   image: snapshot.data[index].image,
                                                                                                            //   fit: BoxFit.cover,
                                                                                                            // ),
                                                                                                            Tooltip(
                                                                                                              verticalOffset: -69,
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                                                                                child: Material(
                                                                                                                  color: Colors.transparent,
                                                                                                                  child: InkWell(
                                                                                                                    splashColor: Colors.transparent,
                                                                                                                    highlightColor: Colors.grey.withOpacity(0.3),
                                                                                                                    borderRadius:
                                                                                                                    const BorderRadius.all(Radius.circular(4.0)),
                                                                                                                    onTap: () {
                                                                                                                      Navigator.of(context).push(
                                                                                                                          MaterialPageRoute(
                                                                                                                              builder: (context) => ChampionRoute(id: snapshot.data[index].id, image: snapshot.data[index].image, name: snapshot.data[index].name, video: snapshot.data[index].video))
                                                                                                                      );
                                                                                                                    },
                                                                                                                  ),
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
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                                                  child: Text(
                                                                                                    snapshot.data[index].name,
                                                                                                    textScaleFactor: 1.0,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'beaufortforlol',
                                                                                                      fontSize: 14,
                                                                                                      color: AppTheme.lightText,
                                                                                                      fontWeight: FontWeight.w700,
                                                                                                      letterSpacing: 0,
                                                                                                      height: 0.5
                                                                                                    ),
                                                                                                    overflow: TextOverflow.fade,
                                                                                                    maxLines: 1,
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    return Container();
                                                                                  }
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 20)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: AppTheme.secBgColor,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                                child: Text(
                                                                                  'Weak against',
                                                                                  textScaleFactor: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'spiegel',
                                                                                    fontSize: 16,
                                                                                    color: AppTheme.physicalvamp,
                                                                                    letterSpacing: 0.3,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 5.0),
                                                                              child: FutureBuilder(
                                                                                  future: weaks,
                                                                                  builder: (context, snapshot) {
                                                                                    if (snapshot.hasData) {
                                                                                      return Container(
                                                                                        height: 110,
                                                                                        child: ListView.builder(
                                                                                          shrinkWrap: true,
                                                                                          padding: const EdgeInsets.only(
                                                                                              top: 0, left: 10, right: 10, bottom: 0),
                                                                                          physics: const BouncingScrollPhysics(),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          itemCount: snapshot.data.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            return Column(
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 95,
                                                                                                  width: 95,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                                                    child: AspectRatio(
                                                                                                      aspectRatio: 1,
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                                        child: Stack(
                                                                                                          alignment: AlignmentDirectional.center,
                                                                                                          children: <Widget>[
                                                                                                            ClipRRect(
                                                                                                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                                                                              child: CachedNetworkImage(
                                                                                                                imageUrl: snapshot.data[index].image,
                                                                                                                placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                                fadeInDuration: Duration(milliseconds: 100),
                                                                                                                fadeOutDuration: Duration(milliseconds: 10),
                                                                                                                fadeInCurve: Curves.bounceIn,
                                                                                                                fit: BoxFit.cover,
                                                                                                              ),
                                                                                                            ),


                                                                                                            // FadeInImage.assetNetwork(
                                                                                                            //   placeholder: 'assets/images/system/black-square.png',
                                                                                                            //   fadeInDuration: Duration(milliseconds: 10),
                                                                                                            //   image: snapshot.data[index].image,
                                                                                                            //   fit: BoxFit.cover,
                                                                                                            // ),
                                                                                                            Tooltip(
                                                                                                              verticalOffset: -69,
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                                                                                child: Material(
                                                                                                                  color: Colors.transparent,
                                                                                                                  child: InkWell(
                                                                                                                    splashColor: Colors.transparent,
                                                                                                                    highlightColor: Colors.grey.withOpacity(0.3),
                                                                                                                    borderRadius:
                                                                                                                    const BorderRadius.all(Radius.circular(4.0)),
                                                                                                                    onTap: () {
                                                                                                                      Navigator.of(context).push(
                                                                                                                          MaterialPageRoute(
                                                                                                                              builder: (context) => ChampionRoute(id: snapshot.data[index].id, image: snapshot.data[index].image, name: snapshot.data[index].name, video: snapshot.data[index].video))
                                                                                                                      );
                                                                                                                    },
                                                                                                                  ),
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
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(top: 5.0),
                                                                                                  child: Text(
                                                                                                    snapshot.data[index].name,
                                                                                                    textScaleFactor: 1.0,
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'beaufortforlol',
                                                                                                      fontSize: 14,
                                                                                                      color: AppTheme.lightText,
                                                                                                      fontWeight: FontWeight.w700,
                                                                                                      letterSpacing: 0,
                                                                                                      height: 0.5
                                                                                                    ),
                                                                                                    overflow: TextOverflow.fade,
                                                                                                    maxLines: 1,
                                                                                                    softWrap: false,
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    return Container();
                                                                                  }
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 20)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ]
                                                              ),
                                                            )
                                                        ),
                                                          SizedBox(
                                                            height: 70,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ):Container(
                                                  height:  MediaQuery.of(context).size.height>700.0?(MediaQuery.of(context).size.height)*0.40:(MediaQuery.of(context).size.height)*0.36,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image(
                                                        image: AssetImage('assets/images/system/poro_joke.png'),
                                                        width: 100,
                                                      ),
                                                      Text(
                                                        'UNDER PROGRESS',
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          fontSize: 18,
                                                          height: 1.8,
                                                          color: Colors.white.withOpacity(0.2),
                                                          letterSpacing: 0.3,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ):Container(),
                                              maintainState: true,
                                              visible: currentIndex == 3,
                                            ),

                                            Visibility(
                                              child: FutureBuilder(
                                                  future: Future.wait([playstyleTips, languages, infos]),
                                                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {

                                                    if (snapshot.hasData) {
                                                      if (snapshot.data[0].playstyle=='Coming soon..') {
                                                        return Container(
                                                          height:  MediaQuery.of(context).size.height>700.0?(MediaQuery.of(context).size.height)*0.40:(MediaQuery.of(context).size.height)*0.36,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image(
                                                                image: AssetImage('assets/images/system/poro_joke.png'),
                                                                width: 100,
                                                              ),
                                                              Text(
                                                                'UNDER PROGRESS',
                                                                textScaleFactor: 1.0,
                                                                style: TextStyle(
                                                                  fontFamily: 'spiegel',
                                                                  fontSize: 18,
                                                                  height: 1.8,
                                                                  color: Colors.white.withOpacity(0.2),
                                                                  letterSpacing: 0.3,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(

                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Container(
                                                                    child: Text(
                                                                      'Playstyle tips',
                                                                      textScaleFactor: 1.0,
                                                                      style: TextStyle(
                                                                        fontFamily: 'spiegel',
                                                                        fontSize: 18,
                                                                        color: AppTheme.labTextActive,
                                                                        letterSpacing: 0.3,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //
                                                              // FutureBuilder(
                                                              //     future: itemDetail,
                                                              //     builder: (context, snapshot) {
                                                              //       if(snapshot.hasData) {
                                                              //         return GestureDetector(
                                                              //           onTap: () {
                                                              //             // Navigator.of(context).push(
                                                              //             //     MaterialPageRoute(
                                                              //             //         builder: (context) => ItemsDetailRoute(id: snapshot.data.id,image: snapshot.data.image, name: snapshot.data.name, name2: snapshot.data.name2, price: snapshot.data.name, type: snapshot.data.name, video: snapshot.data.name))
                                                              //             // );
                                                              //           },
                                                              //           child: Tooltip(
                                                              //               verticalOffset: -69,
                                                              //               message: 'hehe',
                                                              //               padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
                                                              //               textStyle: TextStyle(
                                                              //                 fontFamily: 'beaufortforlol',
                                                              //                 fontSize: 16,
                                                              //                 height: 1.4,
                                                              //                 color: AppTheme
                                                              //                     .coolDown,
                                                              //                 letterSpacing: 0,
                                                              //                 fontWeight: FontWeight.w600,
                                                              //               ),
                                                              //               decoration: BoxDecoration(
                                                              //                   color: Colors.black,
                                                              //                   border: Border(
                                                              //                     bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                                              //                     top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                                              //                     left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                                              //                     right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                                              //                   )
                                                              //               ),
                                                              //               child: CachedNetworkImage(
                                                              //                 // imageUrl: 'https://hninsunyein.me/rift_plus/allinone/' + inner + '.png',
                                                              //                 imageUrl: snapshot.data.item_image,
                                                              //                 placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                              //                 errorWidget: (context, url, error) => Icon(Icons.error),
                                                              //                 fadeInDuration: Duration(milliseconds: 100),
                                                              //                 fadeOutDuration: Duration(milliseconds: 10),
                                                              //                 fadeInCurve: Curves.bounceIn,
                                                              //                 width: 19,
                                                              //                 height: 19,
                                                              //               ),
                                                              //               //child: Text('Kindlegem')
                                                              //           ),
                                                              //         );
                                                              //       }
                                                              //       return Text('Kindlegem', style: TextStyle(color: Colors.yellow));
                                                              //     }
                                                              // ),
                                                              //

                                                              Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 2.0, left: 20.0, right: 0.0, bottom: 0.0),
                                                                  child: Text(
                                                                    snapshot.data[2].ps_ml,
                                                                    textScaleFactor: 1,
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(
                                                                      fontFamily: 'spiegel',
                                                                      fontSize: 16,
                                                                      color: AppTheme.blueAccent,
                                                                      letterSpacing: 0.3,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding: const EdgeInsets.only(top: 13.0, left: 20.0),
                                                              //   child: Align(
                                                              //     alignment: Alignment.topLeft,
                                                              //     child: Container(
                                                              //       decoration: BoxDecoration(
                                                              //           color: Colors.transparent,
                                                              //           borderRadius: const BorderRadius.all(Radius.circular(11.0)),
                                                              //           border: Border.all(color: Colors.yellow)),
                                                              //
                                                              //       child: Padding(
                                                              //         padding: const EdgeInsets.all(1.0),
                                                              //         child: ClipRRect(
                                                              //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                              //
                                                              //           child: Container(
                                                              //             width: width,
                                                              //             color: Colors.red,
                                                              //             child: Row(
                                                              //               children: [
                                                              //                 Container(
                                                              //                   width: 40,
                                                              //                   height: 33,
                                                              //                   color: AppTheme.blueAccent,
                                                              //                   child: Padding(
                                                              //                     padding: const EdgeInsets.only(left: 8.0),
                                                              //                     child: _mainRole(snapshot.data[2].main_lane.split('/')[1], 0, 'ps'),
                                                              //                   ),
                                                              //                 ),
                                                              //                 snapshot.data[2].main_lane.split('/')[1].split('-')[1]!='no'?
                                                              //                 Container(
                                                              //                   width: 40,
                                                              //                   height: 33,
                                                              //                   color: Colors.grey,
                                                              //                   child: Padding(
                                                              //                     padding: const EdgeInsets.only(left: 8.0),
                                                              //                     child: _mainRole(snapshot.data[2].main_lane.split('/')[1], 1, 'ps'),
                                                              //                   ),
                                                              //                 ):Container(),
                                                              //                 snapshot.data[2].main_lane.split('/')[1].split('-')[2]!='no'?
                                                              //                 Container(
                                                              //                   width: 40,
                                                              //                   height: 33,
                                                              //                   color: Colors.grey,
                                                              //                   child: Padding(
                                                              //                     padding: const EdgeInsets.only(left: 8.0),
                                                              //                     child: _mainRole(snapshot.data[2].main_lane.split('/')[1], 2, 'ps'),
                                                              //                   ),
                                                              //                 ):Container(),
                                                              //               ],
                                                              //             )
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                                                                child: Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: RichText(text: modifyDesc(snapshot.data[1]=='_en'?snapshot.data[0].playstyle_en.toString():snapshot.data[0].playstyle.toString()))
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 85,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }

                                                    }
                                                    return Container();
                                                  }
                                              ),
                                              maintainState: true,
                                              visible: currentIndex == 4,
                                            ),
                                          ],
                                          index: currentIndex,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                        abilitiesLoaded && psComboLoaded && psWeaksLoaded && psStrongsLoaded && psMatesLoaded && buildsSp1 &&
                        buildsSp2 && buildsSp3 && buildsSp4 && buildsRune1 && buildsRune2 && buildsRune3 && buildsRune4 &&
                            buildsItem1 && buildsItem2 && buildsItem3 && buildsItem4 && buildsItem5
                            ? Container():Stack(
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
                                      height: 1.4,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        FutureBuilder<Ads>(
                          future: ads,
                          builder: (context, snapshot) {
                            if(snapshot.hasData && snapshot.data.type.contains('bannerAndroid') && Platform.isAndroid) {
                              return Container();
                            } else if (snapshot.hasData && snapshot.data.type.contains('bannerIOS') && !Platform.isAndroid) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                // child: Container(
                                //   width: MediaQuery.of(context).size.width,
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
                                // ),

                                child: Align(
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
                                            child: Container()
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                appBar(),
              ],
            ),
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

  _mainRole(string, pos, des, string2, context) {
    print(string + ' and the Freaking ' + pos.toString());
    if(string.split('-')[pos] == 'fighter') {
      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.fighter,
            size: 22,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Fighter',
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
      );
    } else if(string.split('-')[pos] == 'assasin') {

      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.assasin,
            size: 22,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Assassin',
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
      );
    } else if(string.split('-')[pos] == 'tank') {
      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.tank,
            size: 22,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Tank',
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
      );
    } else if(string.split('-')[pos] == 'mage') {
      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.mage,
            size: 22,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Mage',
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
      );
    } else if(string.split('-')[pos] == 'support') {
      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.support,
            size: 22,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Support',
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
      );
    } else if(string.split('-')[pos] == 'marksman') {
      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.marksman,
            size: 23,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Marksman',
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
      );
    } else if(string.split('-')[pos] == 'jungle') {
      return Tooltip(
        verticalOffset: -69,
        child: GestureDetector(
          onTap: () {
            showPosPrefInfo(context, string.split('-')[pos], '');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 1, right: 10.0),
            child: Icon(
              RiftPlusIcons.jungle_role,
              size: 24,
              color: AppTheme.activeIcon,
            ),
          ),
        ),
        message: 'Jungle position',
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
        textStyle: TextStyle(
          fontFamily: 'beaufortforlol',
          fontSize: 16,
          height: 1.4,
          color: des != 'ps'? AppTheme
              .coolDown: AppTheme.coolDown,
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
      );
    } else if(string.split('-')[pos] == 'mid') {
      return Tooltip(
        verticalOffset: -69,
        child: GestureDetector(
          onTap: () {
            showPosPrefInfo(context, string.split('-')[pos], '');
            // Navigator.of(context, rootNavigator:true).push(
            //   FadeRoute(page: PosPrefInfo(prContext: context)),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              RiftPlusIcons.mid_role,
              size: 25,
              color: des != 'ps'? AppTheme
                  .activeIcon: AppTheme.coolDown,
            ),
          ),
        ),
        message: 'Mid position',
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
        textStyle: TextStyle(
          fontFamily: 'beaufortforlol',
          fontSize: 16,
          height: 1.4,
          color: AppTheme.coolDown,
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
      );
    } else if(string.split('-')[pos] == 'baron') {
      return Tooltip(
        verticalOffset: -69,
        child: GestureDetector(
          onTap: () {
            showPosPrefInfo(context, string.split('-')[pos], '');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 1, right: 10.0),
            child: Icon(
              RiftPlusIcons.solo_role,
              size: 24,
              color: des != 'ps'? AppTheme
                  .activeIcon: AppTheme.coolDown,
            ),
          ),
        ),
        message: 'Solo position',
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
        textStyle: TextStyle(
          fontFamily: 'beaufortforlol',
          fontSize: 16,
          height: 1.4,
          color: AppTheme.coolDown,
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
      );
    } else if(string.split('-')[pos] == 'dragon' && string2.contains('marksman')) {
      return Tooltip(
        verticalOffset: -69,
        child: GestureDetector(
          onTap: () {
            showPosPrefInfo(context, string.split('-')[pos], 'marksman');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 1, right: 10.0),
            child: Icon(
              RiftPlusIcons.duo_role,
              size: 25,
              color: des != 'ps'? AppTheme
                  .activeIcon: AppTheme.coolDown,
            ),
          ),
        ),
        message: 'Duo position',
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
        textStyle: TextStyle(
          fontFamily: 'beaufortforlol',
          fontSize: 16,
          height: 1.4,
          color: AppTheme.coolDown,
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
      );
    } else if(string.split('-')[pos] == 'dragon' && !string2.contains('marksman')) {
      return Tooltip(
        verticalOffset: -69,
        child: GestureDetector(
          onTap: () {
            showPosPrefInfo(context, string.split('-')[pos], '');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 0, right: 10.0),
            child: Icon(
              RiftPlusIcons.support_role,
              size: 25,
              color: des != 'ps'? AppTheme
                  .activeIcon: AppTheme.coolDown,
            ),
          ),
        ),
        message: 'Support position',
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 14),
        textStyle: TextStyle(
          fontFamily: 'beaufortforlol',
          fontSize: 16,
          height: 1.4,
          color: AppTheme.coolDown,
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
      );
    } else if(string.split('-')[pos] == 'melee') {
      return Tooltip(
        verticalOffset: -69,
        message: 'Melee hero',
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
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.melee,
            size: 25,
            color: AppTheme.activeIcon,
          ),
        ),
      );
    } else if(string.split('-')[pos] == 'ranged') {
      return Tooltip(
        verticalOffset: -69,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            RiftPlusIcons.ranged,
            size: 25,
            color: AppTheme.activeIcon,
          ),
        ),
        message: 'Ranged hero',
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
      );
    } else {
      return SizedBox();
    }
  }


  List<Widget> getWidgets() {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(getWidget(i));
    }
    return _generalWidgets;
  }

  Widget getWidget(int widgetNumber) {
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
                        FadeRoute(page: ReportDetailPage(name: widget.name),),
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
    } else {
      return '';
    }
  }
  String skillComboTooltip(image) {
    if(image.contains('p.png')) {
      return champSkp;
    } else if(image.contains('1.png')) {
      return champSk1;
    } else if(image.contains('2.png')) {
      return champSk2;
    } else if(image.contains('3.png')) {
      return champSk3;
    } else if(image.contains('4.png')) {
      return champSk4;
    } else if(image.contains('a.png')) {
      return 'Physical attack';
    } else if(image.contains('flash')){
      return 'Flash spell';
    } else if(image.contains('ghost')){
      return 'Ghost spell';
    } else if(image.contains('barrier')){
      return 'Barrier spell';
    } else if(image.contains('exhaust')){
      return 'Exhaust spell';
    } else if(image.contains('heal')){
      return 'Heal spell';
    } else if(image.contains('ignite')){
      return 'Ignite spell';
    } else if(image.contains('smite')){
      return 'Smite spell';
    } else if(image.contains('cleanse')){
      return 'Cleanse spell';
    } else if(image.contains('dashonly')){
      return 'Dash spell';
    } else if(image.contains('clarity')){
      return 'Clarity spell';
    } else if(image.contains('mark_and_dash')){
      return 'Mark and Dash spell';
    }
  }
  String abilityData(userDocument, type){
    //print('abilityData' + userDocument.skillp_image);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var index = prefs.getString('language');
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
    } else if (type == 'desc_en'){
      if(skillTapIndex == 0) {
        return (userDocument.skillp_desc_en as String).replaceAll("\\n", "\n");
      } else if(skillTapIndex == 1) {
        return (userDocument.skill1_desc_en as String).replaceAll("\\n", "\n");
      } else if(skillTapIndex == 2) {
        return (userDocument.skill2_desc_en as String).replaceAll("\\n", "\n");
      } else if(skillTapIndex == 3) {
        return (userDocument.skill3_desc_en as String).replaceAll("\\n", "\n");
      } else {
        return (userDocument.skill4_desc_en as String).replaceAll("\\n", "\n");
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
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              color: Colors.black,
            ),
            Container(
              width: width,
              height: height,
              child: _playView(context),
            ),
          ],
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
  var inVideo = '';
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
                        print('video   = ' + video + ' and inVideo   = ' + inVideo);
                        if(video!=inVideo){
                          AppState().increaseGloAdsInt(2);
                        }
                        await controller.seekTo(Duration.zero);
                        setState(() {
                          controller.play();
                        });
                        inVideo = video;
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
            _controlView(context),
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
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtsk>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtsk>') + 8, abilityData.indexOf('<]txtsk>'));
        // String image = 'https://hninsunyein.me/rift_plus/items/' + inner.split('~')[5] + '/' + inner.split('~')[1];
        textSpan.children.add(
            WidgetSpan(
                child: FutureBuilder(
                    future: abilities,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return GestureDetector(
                          child: Tooltip(
                            verticalOffset: -69,
                            message: psAbiImg(inner, snapshot.data, 'name'),
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
                              imageUrl: psAbiImg(inner, snapshot.data, 'image'),
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
        abilityData = abilityData.substring(abilityData.indexOf('<]txtsk>') + 8);
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

  var video = '';

  void _initializeAndPlay(String index) async {
    print("_initializeAndPlay ---------> $index");
    video = index;
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

    // ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpLWXhMRDB1ZzNNOVI=@18.140.62.131:646/?outline=1

    // ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTplUUNSQjY0dkF2ZHQ=@18.140.62.131:646/?outline=1

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
        child: Container(

          decoration: BoxDecoration(
              color: AppTheme.thirdBgColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.lineColor, width: 1),
              )
          ),
            child: TabBar(
              labelColor: AppTheme.borderColor,
              unselectedLabelColor: AppTheme.labText,
              isScrollable: true,
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
                Tab(
                  child: Text(
                    'COMBOS',
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
                    'ANALYTICS',
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
                    'PLAYSTYLE',
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

  _combosImage(String ps_skill1) {
    if (!ps_skill1.contains('http')) {
      return CachedNetworkImage(
          imageUrl: 'https://hninsunyein.me/rift_plus/spells/' + ps_skill1.toLowerCase(),
          placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fadeInDuration: Duration(milliseconds: 100),
          fadeOutDuration: Duration(milliseconds: 10),
          fadeInCurve: Curves.bounceIn
      );
      //return Image(image: AssetImage('assets/images/system/' + ps_skill1.toLowerCase()));
    } else {
      // return FadeInImage.assetNetwork(
      //   placeholder: 'assets/images/system/black-square.png',
      //   fadeInDuration: Duration(milliseconds: 10),
      //   image: ps_skill1,
      //   fit: BoxFit.cover,
      // );

      return CachedNetworkImage(
          imageUrl: ps_skill1,
          placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fadeInDuration: Duration(milliseconds: 100),
          fadeOutDuration: Duration(milliseconds: 10),
          fadeInCurve: Curves.bounceIn
      );
    }
  }

  void showComboVideo(BuildContext context, String video, String skill1, String skill2, String skill3, String skill4,
      String skill5, String skill6, String skill7, String skill8, String skill9, String skill10, String name, String desc) {
    // AppState()._disBotTabBar(context);


    // await Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
    //     CupertinoPageRoute(
    //         builder: (BuildContext context) {
    //           return ComboVideoRoute();
    //         }
    //     ) );

    print('Video ' + video);
    Navigator.of(context, rootNavigator:true).push(
      FadeRoute(page: ComboVideoRoute(video: video, skill1: skill1, skill2: skill2, skill3: skill3, skill4: skill4, skill5: skill5,
        skill6: skill6, skill7: skill7, skill8: skill8, skill9: skill9, skill10: skill10, name: name, desc: desc,
        champSkp: champSkp, champSk1: champSk1, champSk2: champSk2, champSk3: champSk3, champSk4: champSk4)),
    );


    // showDialog(
    //   barrierColor: Colors.transparent,
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return Container(
    //         color: Colors.transparent,
    //         child: AlertDialog(
    //           backgroundColor: Colors.transparent,
    //           title: Container(
    //             color: Colors.yellow,
    //             height: 200,
    //             width: MediaQuery.of(context).size.width,
    //           ),
    //         ),
    //       );
    //     });

    // Navigator.push(
    //   context, FadeRoute(page: ComboVideoRoute()),
    // );


    // showDialog(
    //     context: context,
    //     barrierColor: Colors.black87,
    //     barrierDismissible: true,
    //     builder: (context) {
    //       return Container(
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Align(
    //               alignment: Alignment.topLeft,
    //               child: Padding(
    //                 padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 10.0),
    //                 child: Text(
    //                   'Initiative combo (easy)',
    //                   textScaleFactor: 1,
    //                   textAlign: TextAlign.left,
    //                   style: TextStyle(
    //                     fontFamily: 'spiegel',
    //                     fontSize: 16,
    //                     color: AppTheme.blueAccent,
    //                     letterSpacing: 0.3,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               height: MediaQuery.of(context).size.width/1.77,
    //               child: Center(
    //                 child: _chewieController != null &&
    //                     _chewieController
    //                         .videoPlayerController.value.initialized
    //                     ? Chewie(
    //                   controller: _chewieController,
    //                 )
    //                     : Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: const [
    //                     CircularProgressIndicator(),
    //                     SizedBox(height: 20),
    //                     Text('Loading'),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //
    //           ],
    //         ),
    //       );
    //     });
  }

  void showPosPrefInfo(priContext, pos, pos2) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.85),
        context: context,
        builder: (context) {
          return SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 50.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppTheme.secBgColor,
                                border: Border(
                                  bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                  right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                )
                            ),
                            child: Column(
                              children: [
                                posLaneImage(pos, pos2),
                                //Image(image: AssetImage('assets/images/system/vision-illu.png')),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top:10, bottom:15),
                                  child: FutureBuilder(
                                    future: languages,
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData) {
                                        if(snapshot.data=='_en') {
                                          return Text(
                                            'If it\'s a mirror map, game will notify you lanes are swapped at the match start and champion positions should be swapped according to that.',
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontSize: 14,
                                              color: AppTheme
                                                  .labTextActive2,
                                              letterSpacing: 0.3,
                                            ),
                                            textAlign: TextAlign.center,
                                          );
                                        } else {
                                          return Text(
                                            'Mirror map ဖြစ်သွားရင် game အစမှာ lane များ ပြောင်းသွားကြောင်း အသိပေးမှာဖြစ်ပြီး ထို lane များအတိုင်း champions များဟာလည်း ပြောင်းပြီး သွားသင့်ပါတယ်။',
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontSize: 13,
                                              height: 1.5,
                                              color: AppTheme
                                                  .labTextActive2,
                                              letterSpacing: 0.3,
                                            ),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                      }
                                      return Container();
                                    }
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    RaisedGradientButton(
                                        child: Text(
                                          'Okay',
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontFamily: 'beaufortforlol',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                            letterSpacing: 0.3,
                                            color: AppTheme.labTextActive,
                                          ),
                                        ),
                                        gradient: LinearGradient(
                                          colors: <Color>[Color(0xFF111217), Color(0xFF111217)],
                                          begin: const FractionalOffset(0.0, 1.0),
                                          end: const FractionalOffset(0.0, 0.0),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        }
                                    ),
                                    SizedBox(
                                        width: 10
                                    ),
                                    RaisedGradientButton(
                                        child: Text(
                                          'Detail',
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontFamily: 'beaufortforlol',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                            letterSpacing: 0.3,
                                            color: AppTheme.labTextActive,
                                          ),
                                        ),
                                        gradient: LinearGradient(
                                          colors: <Color>[Color(0xFF4B3F2A), Color(0xFF13191C)],
                                          begin: const FractionalOffset(0.0, 1.0),
                                          end: const FractionalOffset(0.0, 0.0),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                          if(pos=='mid') {
                                            Navigator.of(priContext).push(
                                                MaterialPageRoute(
                                                    builder: (priContext) => PosLaneDet(type: 'mid'))
                                            );
                                          } else if(pos=='baron') {
                                            Navigator.of(priContext).push(
                                                MaterialPageRoute(
                                                    builder: (priContext) => PosLaneDet(type: 'solo'))
                                            );
                                          } else if(pos=='jungle') {
                                            Navigator.of(priContext).push(
                                                MaterialPageRoute(
                                                    builder: (priContext) => PosLaneDet(type: 'jungle'))
                                            );
                                          } else if(pos=='dragon' && pos2.contains('marksman')) {
                                            Navigator.of(priContext).push(
                                                MaterialPageRoute(
                                                    builder: (priContext) => PosLaneDet(type: 'duo'))
                                            );
                                          } else if(pos=='dragon' && !pos2.contains('marksman')) {
                                            Navigator.of(priContext).push(
                                                MaterialPageRoute(
                                                    builder: (priContext) => PosLaneDet(type: 'support'))
                                            );
                                          }

                                          // _ChampionRouteState().goPosPrefDetail('s');
                                          // AppState().goPosPrefDetail('2');
                                        }
                                    ),
                                    Expanded(
                                        child: SizedBox()
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  posLaneImage(pos, pos2) {
    if(pos=='mid') {
      return Image(image: AssetImage('assets/images/system/mid-pos-screen.png'));
    } else if(pos=='baron') {
      return Image(image: AssetImage('assets/images/system/solo-pos-screen.png'));
    } else if(pos=='jungle') {
      return Image(image: AssetImage('assets/images/system/jungle-pos-screen.png'));
    } else if(pos=='dragon' && pos2.contains('marksman')) {
      return Image(image: AssetImage('assets/images/system/duo-pos-screen.png'));
    } else if(pos=='dragon' && !pos2.contains('marksman')) {
      return Image(image: AssetImage('assets/images/system/support-post-screen.png'));
    }
    return Container();
  }

  List<DropdownMenuItem> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem> items = List();
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword'], textScaleFactor: 1,),
        ),
      );
    }
    return items;
  }

  champPosIcon(String data) {
    print('champPosIcon ' + data);
    if(data=='mid') {
      return Icon(
        RiftPlusIcons.mid_role,
        size: 25,
        color: AppTheme
            .activeIcon,
      );
    } else if(data=='solo') {
      return Icon(
        RiftPlusIcons.solo_role,
        size: 24,
        color: AppTheme
            .activeIcon,
      );
    } else if(data=='duo') {
      return Icon(
        RiftPlusIcons.duo_role,
        size: 25,
        color: AppTheme
            .activeIcon,
      );
    } else if(data=='support') {
      return Icon(
        RiftPlusIcons.support_role,
        size: 25,
        color: AppTheme
            .activeIcon,
      );
    } else if(data=='jungle') {
      return Icon(
        RiftPlusIcons.jungle_role,
        size: 24,
        color: AppTheme
            .activeIcon,
      );
    }
  }


  champPosIconN(String data) {
    print('champPosIcon ' + data);
    if(data=='mid') {
      return Icon(
        RiftPlusIcons.mid_role,
        size: 25,
        color: AppTheme.normalIcon,
      );
    } else if(data=='solo') {
      return Icon(
        RiftPlusIcons.solo_role,
        size: 24,
        color: AppTheme.normalIcon,
      );
    } else if(data=='duo') {
      return Icon(
        RiftPlusIcons.duo_role,
        size: 25,
        color: AppTheme.normalIcon,
      );
    } else if(data=='support') {
      return Icon(
        RiftPlusIcons.support_role,
        size: 25,
        color: AppTheme.normalIcon,
      );
    } else if(data=='jungle') {
      return Icon(
        RiftPlusIcons.jungle_role,
        size: 24,
        color: AppTheme.normalIcon,
      );
    }
  }


  onChangeIconPos() {
    if(orderPosIndex=='0') {
      return champPosIcon(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[0]);
    } else if(orderPosIndex=='1') {
      return champPosIcon(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[0]);
    } else if(orderPosIndex=='2') {
      return champPosIcon(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[0]);
    }
  }

  onChangePosText() {
    if(orderPosIndex=='0') {
      return capitalize(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[0]);
    } else if(orderPosIndex=='1') {
      return capitalize(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[0]); 
    } else if(orderPosIndex=='2') {
      return capitalize(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[0]); 
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  onChangeSkillDiv(numx) {
    if(skill_order!='') {
      if(orderPosIndex=='0') {
        
        if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='4') {
          return 35.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='3') {
          return 90.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='2') {
          return 145.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='1') {
          return 200.0;
        }
      } else if(orderPosIndex=='1') {
        if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='4') {
          return 35.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='3') {
          return 90.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='2') {
          return 145.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='1') {
          return 200.0;
        }
      } else if(orderPosIndex=='2') {
        if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='4') {
          return 35.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='3') {
          return 90.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='2') {
          return 145.0;
        } else if(skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numx)]=='1') {
          return 200.0;
        }
      }
    } else {
      return 0.0;
    }
  }


  onChangeSkillOrder(numx, numy) {
    print(numx + numy + 'numxy');
    if(skill_order=='') {
      return Container();
    }
    if(orderPosIndex=='0') {
      print('shwe ' + orderPosIndex.toString());
      if(numx.toString()==skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numy)]) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.secBgColor,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
          height: 40,
          width: 40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Text(
                skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numy)],
                textScaleFactor: 1,
                style: TextStyle(
                  fontFamily: 'spiegel',
                  fontSize: 18,
                  color: AppTheme
                      .labTextActive,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        return Container(
          height: 40,
          width: 40,
        );
      }
    } else if(orderPosIndex=='1') {
      if(numx.toString()==skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numy)]) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.secBgColor,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
          height: 40,
          width: 40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Text(
                skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numy)],
                textScaleFactor: 1,
                style: TextStyle(
                  fontFamily: 'spiegel',
                  fontSize: 18,
                  color: AppTheme
                      .labTextActive,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        return Container(
          height: 40,
          width: 40,
        );
      }
    } else if(orderPosIndex=='2') {
      if(numx.toString()==skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numy)]) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.secBgColor,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
          height: 40,
          width: 40,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Text(
                skill_order.split(',')[int.parse(orderPosIndex)].split('-')[1][int.parse(numy)],
                textScaleFactor: 1,
                style: TextStyle(
                  fontFamily: 'spiegel',
                  fontSize: 18,
                  color: AppTheme
                      .labTextActive,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        return Container(
          height: 40,
          width: 40,
        );
      }
    }
  }

  onChangeDropdownTests(selectedTest) async{
    // setState(() {
    //   _selectedTest = getSelectedLang(selectedTest.toString());
    // });
    // print('ASHINE ' + selectedTest.toString());
    //
    // print('ASHINE 2 ' + prevLang);

    AppState().showAlert(context);
    


    // prevLang = selectedTest.toString();

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
