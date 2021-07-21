import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
import 'package:riftplus02/screens/screen_one_route/report_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
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


class Ads {
  final String type;

  Ads({this.type});

  factory Ads.fromJson(Map<String, dynamic> json){
    return Ads(
      type: json['type'],
    );
  }
}

class ItemsDetailRoute extends StatefulWidget {
  const ItemsDetailRoute({Key key, this.id, this.image, this.name, this.name2, this.desc, this.price, this.type, this.video}) : super(key: key);
  final String id;
  final String image;
  final String name;
  final String name2;
  final String desc;
  final String price;
  final String type;
  final String video;

  @override
  _ItemsDetailRouteState createState() => _ItemsDetailRouteState();
}






class Infos {
  final String item_desc;
  final String item_desc_en;
  final String item_pros;
  final String item_video;
  Infos({this.item_desc, this.item_desc_en, this.item_pros, this.item_video});

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
        item_desc: json['item_desc'],
        item_desc_en: json['item_desc_en'],
        item_pros: json['item_pros'],
        item_video: json['item_video']
    );
  }
}

class Item {
  final String id;
  final String item_type;
  final String item_lv;
  final String item_name;
  final String item_name2;
  final String item_price;
  final String item_image;
  final String item_video;

  Item({this.id, this.item_type, this.item_lv, this.item_name, this.item_name2, this.item_price, this.item_image, this.item_video});

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
        id: json['id'],
        item_type: json['item_type'],
        item_lv: json['item_lv'],
        item_name: json['item_name'],
        item_name2: json['item_name2'],
        item_price: json['item_price'],
        item_image: json['item_image'],
        item_video: json['item_video']
    );
  }
}


class _ItemsDetailRouteState extends State<ItemsDetailRoute>  with TickerProviderStateMixin<ItemsDetailRoute>{
  Future<Infos> infos;
  Dio dio;
  Future<Ads> ads;
  Future<List<Item>> itemsBuildPath;
  Future<List<Item>> itemsBuildInto;
  Future languages;
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  bool itemDescriptionLoaded = false;
  bool itemBuildPathLoaded = false;
  bool itemBuildIntoLoaded = false;

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

  void initState() {
    AppState().increaseGloAdsInt(1.5);
    if(widget.video!='') {
      _initializeAndPlay(widget.video);
    }
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
    infos = fetchInfos(widget.id);
    languages = _getLanguage();
    itemsBuildPath = fetchItemsBuildPath(widget.id);
    itemsBuildInto = fetchItemsBuildInto(widget.id);
    print('check ' + widget.id + widget.image);
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    _timerVisibleControl?.cancel();
    _exitFullScreen();
    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;

    super.dispose();

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

  Future<Ads> fetchAds() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/itemAds.php');

    // Use the compute function to run parsePhotos in a separate isolate.
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
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getItemDescriptionById.php?id='+id);
    setState(() {
      itemDescriptionLoaded = true;
    });
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


  Future<List<Item>> fetchItemsBuildPath(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getBuildPathById.php?id='+id);
    setState(() {
      itemBuildPathLoaded = true;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject["hsuchan"];
      var itemBaseds = list.map((itemsBuildPath) => Item.fromJson(itemsBuildPath)).toList();


      return itemBaseds;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Item>> fetchItemsBuildInto(id) async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getBuildIntoById.php?id='+id);
    setState(() {
      itemBuildIntoLoaded = true;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject["hsuchan"];
      var items = list.map((itemsBuildInto) => Item.fromJson(itemsBuildInto)).toList();


      return items;

    } else {
      throw Exception('Failed to load album');
    }
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
                child: Container(
                  color: AppTheme.priBgColor,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:20,right: 20, top: 20),
                            child: Row(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
//                                      image: DecorationImage(
//                                          fit: BoxFit.cover, image: NetworkImage(widget.image)),
                                        border: Border(

                                          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
                                          top: BorderSide(color: AppTheme.borderColor, width: 1),
                                          left: BorderSide(color: AppTheme.borderColor, width: 1),
                                          right: BorderSide(color: AppTheme.borderColor, width: 1),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: CachedNetworkImage(
                                          imageUrl: widget.image,
                                          width: 120,
                                          height: 120,
                                          placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fadeInDuration: Duration(milliseconds: 100),
                                          fadeOutDuration: Duration(milliseconds: 10),
                                          fadeInCurve: Curves.bounceIn
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  height: 125,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 30, right: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(widget.name,
                                            textAlign: TextAlign.start,
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              letterSpacing: 0.3,
                                              color: AppTheme.labTextActive,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(widget.name2,
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                letterSpacing: 0.3,
                                                color: AppTheme.labText,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),

                                        Expanded(child:
                                        Container(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(widget.price,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                fontFamily: 'spiegel',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                                letterSpacing: 0.3,
                                                color: AppTheme.activeIcon,
                                              ),
                                            ),
                                          ),
                                        )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10,left: 0.0, right: 0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                  ),
                                ),
                              )
                          ),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  FutureBuilder(
                                    //snapshot.data.item_desc.replaceAll("\\n", "\n")
                                      future: Future.wait([infos, languages]),
                                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {

                                        if(snapshot.hasData) {
                                          print('desc' + snapshot.data[0].item_pros);
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        'DESCRIPTION',
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
                                                    // InkWell(
                                                    //   highlightColor: Colors.transparent,
                                                    //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                    //   onTap: () {
                                                    //     if(this.id.contains('runes')) {
                                                    //       print('runes');
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => SeeAllRunesRoute(id: this.id))
                                                    //       );
                                                    //     } else {
                                                    //       print('not runes');
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => SeeAllRoute(id: this.id))
                                                    //       );
                                                    //     }
                                                    //
                                                    //   },
                                                    //   child: Padding(
                                                    //     padding: const EdgeInsets.only(left: 8),
                                                    //     child: Row(
                                                    //       children: <Widget>[
                                                    //         Text(
                                                    //           subTxt,
                                                    //           textAlign: TextAlign.right,
                                                    //           style: TextStyle(
                                                    //             fontFamily: 'spiegel',
                                                    //             fontWeight: FontWeight.normal,
                                                    //             fontSize: 16,
                                                    //             letterSpacing: 0.5,
                                                    //             color: AppTheme.borderColor,
                                                    //           ),
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                              snapshot.data[0].item_pros!=''?
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20.0, right:20.0, top:10.0),
                                                child: Container(
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: RichText(
                                                        textScaleFactor: 1,
                                                        text: modifyDesc(snapshot.data[0].item_pros)
                                                    ),
                                                  ),
                                                ),
                                              ):Container(),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 20.0, right:20.0, top:15.0),
                                                child: Container(
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: RichText(
                                                        textScaleFactor: 1,
                                                        text: modifyDesc(snapshot.data[1]=='_en'?snapshot.data[0].item_desc_en.toString():snapshot.data[0].item_desc.toString())
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              widget.video!=''?VideoPlayerCust(snapshot.data[0].item_video):Container(),
                                            ],
                                          );
                                        }
                                        return Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                            child: CupertinoActivityIndicator(radius: 12,));
                                      }
                                  ),

                                  FutureBuilder<List<Item>>(
                                      future: itemsBuildPath,
                                      builder: (context, snapshot) {
                                        print('ERROR' + snapshot.error.toString());
                                        if (snapshot.hasData) {

                                          return Column(
                                            children: [
                                              SizedBox(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 15,left: 0.0, right: 0.0, bottom: 0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        'BUILD PATH',
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
                                                    // InkWell(
                                                    //   highlightColor: Colors.transparent,
                                                    //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                    //   onTap: () {
                                                    //     if(this.id.contains('runes')) {
                                                    //       print('runes');
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => SeeAllRunesRoute(id: this.id))
                                                    //       );
                                                    //     } else {
                                                    //       print('not runes');
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => SeeAllRoute(id: this.id))
                                                    //       );
                                                    //     }
                                                    //
                                                    //   },
                                                    //   child: Padding(
                                                    //     padding: const EdgeInsets.only(left: 8),
                                                    //     child: Row(
                                                    //       children: <Widget>[
                                                    //         Text(
                                                    //           subTxt,
                                                    //           textAlign: TextAlign.right,
                                                    //           style: TextStyle(
                                                    //             fontFamily: 'spiegel',
                                                    //             fontWeight: FontWeight.normal,
                                                    //             fontSize: 16,
                                                    //             letterSpacing: 0.5,
                                                    //             color: AppTheme.borderColor,
                                                    //           ),
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height: 80,
                                                  child: GridView.builder(
                                                    padding: const EdgeInsets.only(
                                                        top: 0, left: 20, right: 20, bottom: 0),
                                                    physics: const BouncingScrollPhysics(),
                                                    scrollDirection: Axis.horizontal,
                                                    // children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (context, index) {
                                                      return AspectRatio(
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
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                                                child: Tooltip(
                                                                  verticalOffset: -69,
                                                                  message: snapshot.data[index].item_name,
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
                                                                                builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_name2, price:snapshot.data[index].item_price, type: snapshot.data[index].item_type, video: snapshot.data[index].item_video))
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
                                                    },
                                                    gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 1,
                                                      mainAxisSpacing: 15.0,
                                                      crossAxisSpacing: 15.0,
                                                      childAspectRatio: 1.5,
                                                    ),
                                                  )
                                              ),
                                              //                              SizedBox(
                                              //                                  child: Padding(
                                              //                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              //                                    child: Container(
                                              //                                      decoration: BoxDecoration(
                                              //                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                              //                                      ),
                                              //                                    ),
                                              //                                  )
                                              //                              ),
                                            ],
                                          );
                                        }
                                        return Container();

                                      }
                                  ),
                                  FutureBuilder<List<Item>>(
                                      future: itemsBuildInto,
                                      builder: (context, snapshot) {
                                        print('ERROR' + snapshot.error.toString());
                                        if (snapshot.hasData) {

                                          return Column(
                                            children: [
                                              SizedBox(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5,left: 0.0, right: 0.0, bottom: 0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        'BUILD INTO',
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
                                                    // InkWell(
                                                    //   highlightColor: Colors.transparent,
                                                    //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                    //   onTap: () {
                                                    //     if(this.id.contains('runes')) {
                                                    //       print('runes');
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => SeeAllRunesRoute(id: this.id))
                                                    //       );
                                                    //     } else {
                                                    //       print('not runes');
                                                    //       Navigator.of(context).push(
                                                    //           MaterialPageRoute(
                                                    //               builder: (context) => SeeAllRoute(id: this.id))
                                                    //       );
                                                    //     }
                                                    //
                                                    //   },
                                                    //   child: Padding(
                                                    //     padding: const EdgeInsets.only(left: 8),
                                                    //     child: Row(
                                                    //       children: <Widget>[
                                                    //         Text(
                                                    //           subTxt,
                                                    //           textAlign: TextAlign.right,
                                                    //           style: TextStyle(
                                                    //             fontFamily: 'spiegel',
                                                    //             fontWeight: FontWeight.normal,
                                                    //             fontSize: 16,
                                                    //             letterSpacing: 0.5,
                                                    //             color: AppTheme.borderColor,
                                                    //           ),
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height: 80,
                                                  child: GridView.builder(
                                                    padding: const EdgeInsets.only(
                                                        top: 0, left: 20, right: 20, bottom: 0),
                                                    physics: const BouncingScrollPhysics(),
                                                    scrollDirection: Axis.horizontal,
                                                    // children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (context, index) {
                                                      return AspectRatio(
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
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                                                child: Tooltip(
                                                                  verticalOffset: -69,
                                                                  message: snapshot.data[index].item_name,
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
                                                                                builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_name2, price:snapshot.data[index].item_price, type: snapshot.data[index].item_type, video: snapshot.data[index].item_video))
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
                                                    },
                                                    gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 1,
                                                      mainAxisSpacing: 15.0,
                                                      crossAxisSpacing: 15.0,
                                                      childAspectRatio: 1.5,
                                                    ),
                                                  )
                                              ),
                                              //                              SizedBox(
                                              //                                  child: Padding(
                                              //                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              //                                    child: Container(
                                              //                                      decoration: BoxDecoration(
                                              //                                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                              //                                      ),
                                              //                                    ),
                                              //                                  )
                                              //                              ),
                                            ],
                                          );
                                        }
                                        return Container();

                                      }
                                  ),
                                  SizedBox(
                                    height: 80
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      itemDescriptionLoaded && itemBuildPathLoaded && itemBuildIntoLoaded ? Container():Stack(
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
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }

  VideoPlayerCust(skillp) {
//    return Container();
    var size = MediaQuery.of(context).size;
    var width = size.width - 40;
    var height = width * (9/16);
    return skillp != '' ? Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
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


  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5851001553018666/2287026456';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5851001553018666/2854836810';
    }
    return null;
  }


  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final record = Record.fromSnapshot(data);
  //   return ClipRRect(
  //     borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  //     child: Stack(
  //       alignment: AlignmentDirectional.center,
  //       children: <Widget>[
  //         Image(
  //           image: NetworkImage(record.image),
  //           fit: BoxFit.cover,
  //         ),
  //         Material(
  //           color: Colors.transparent,
  //           child: InkWell(
  //             splashColor: Colors.grey.withOpacity(0.2),
  //             borderRadius:
  //             const BorderRadius.all(Radius.circular(4.0)),
  //             onTap: () {
  //               Navigator.of(context).push(
  //                   MaterialPageRoute(
  //                       builder: (context) => ItemsDetailRoute(id: record.id,image: record.image, name: record.name, desc: record.desc, price:record.price, type: record.type))
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                    'ITEM DETAIL',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontFamily: 'beaufortforlol',
                      fontSize: 21,
                      color: AppTheme.lightText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
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

//   ItemsPros(snapshot) {
//     Column column = Column(
//       children: [
//         SizedBox()
//       ],
//     );
//     snapshot.data.documents.map<Widget>((document) {
//       column.children.add(
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 20.0, top:5.0, bottom:0.0),
//             child: Container(
//               child: RichText(
//                   text: modifyDesc(document['text'])
//               ),
//             ),
//           ),
//         )
//       );
//     }).toList();
//     return column;
// //    if(widget.id.contains('physical')&&widget.id.contains('basic')) {
// //      return StreamBuilder(
// //          stream: Firestore.instance.collection('items').document('physical').collection('basic').snapshots(),
// //          builder: (context, snapshot) {
// //          return Align(
// //            alignment: Alignment.centerLeft,
// //            child: Padding(
// //              padding: const EdgeInsets.only(left: 20.0, top:15.0, bottom:0.0),
// //              child: Container(
// //                child: RichText(
// //                    text: TextSpan(
// //                        style: Theme.of(context).textTheme.body1,
// //                        children: [
// //                          WidgetSpan(
// //                            child: Padding(
// //                              padding: const EdgeInsets.only(right: 5.0),
// //                              child: Icon(
// //                                RiftPlusIcons.cooldown,
// //                                color: AppTheme.coolDown2,
// //                                size: 15,
// //                              ),
// //                            ),
// //                          ),
// //                          TextSpan(
// //                            text: 'asefasf',
// //                            style: TextStyle(
// //                              fontFamily: 'spiegel',
// //                              fontSize: 15,
// //                              color: AppTheme
// //                                  .labTextActive,
// //                              letterSpacing: 0,
// //                              fontWeight: FontWeight.w600,
// //                            ),
// //                          ),
// //                        ]
// //                    )
// //                ),
// //              ),
// //            ),
// //        );
// //      },
// //    );
// //    }
//
//   }





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