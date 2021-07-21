// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riftplus02/icon_fonts/rift_plus_icons_icons.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
import 'package:riftplus02/screens/screen_one_route/champion_route_test2.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:convert';

import '../../apptheme.dart';
import '../../fintness_app_theme.dart';
// import 'homescreen.dart';

class ChampionRouteTabOne extends StatefulWidget {
  const ChampionRouteTabOne({Key key, this.id, this.video}) : super(key: key);
  final String id;
  final String video;
  //final called1 = false;
  @override
  _ChampionRouteTabOneState createState() => _ChampionRouteTabOneState();
}

class _ChampionRouteTabOneState extends State<ChampionRouteTabOne> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<ChampionRouteTabOne>{
  @override
  bool get wantKeepAlive => true;
  Dio dio;
  var skillTapIndex = 0;
  VideoPlayerController _controller;
  Future<Abilities> abilities;

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
    _initializeAndPlay(widget.video);

    abilities = fetchAbilities(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.priBgColor,
      child: FutureBuilder<Abilities>(
          future: abilities,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //print('here ' + snapshot.data.skill1_image);
              return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom:0.0, top: 18.0),
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
                                      _initializeAndPlay(snapshot.data.skillp_video);
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
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/system/black-square.png',
                                                fadeInDuration: Duration(milliseconds: 10),
                                                image: snapshot.data.skillp_image,
                                                fit: BoxFit.cover,
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
                                      _initializeAndPlay(snapshot.data.skill1_video);
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
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/system/black-square.png',
                                                fadeInDuration: Duration(milliseconds: 10),
                                                image: snapshot.data.skill1_image,
                                                fit: BoxFit.cover,
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
                                      _initializeAndPlay(snapshot.data.skill2_video);
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
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/system/black-square.png',
                                                fadeInDuration: Duration(milliseconds: 10),
                                                image: snapshot.data.skill2_image,
                                                fit: BoxFit.cover,
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
                                      _initializeAndPlay(snapshot.data.skill3_video);
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
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/system/black-square.png',
                                                fadeInDuration: Duration(milliseconds: 10),
                                                image: snapshot.data.skill3_image,
                                                fit: BoxFit.cover,
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
                                      _initializeAndPlay(snapshot.data.skill4_video);
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
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/system/black-square.png',
                                                fadeInDuration: Duration(milliseconds: 10),
                                                image: snapshot.data.skill4_image,
                                                fit: BoxFit.cover,
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
                                abilityData(snapshot.data, 'name'),
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
                                abilityData(snapshot.data, 'name2'),
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
                                          abilityData(snapshot.data, 'colddown')!='0'?
                                          TextSpan(
                                            text: abilityData(snapshot.data, 'colddown'),
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
                                          abilityData(snapshot.data, 'mana').contains('mana')?
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
                                          abilityData(snapshot.data, 'mana').contains('energy')?
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
                                          abilityData(snapshot.data, 'mana')!='0'?
                                          TextSpan(
                                            text: abilityData(snapshot.data, 'mana').split('-')[1].trim(),
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

//                                        Align(
//                                          alignment: Alignment.centerLeft,
//                                          child: RichText(
//                                            text: modifyDesc(abilityData(userDocument, 'desc')),
//                                          ),
//                                        )
                          SizedBox(
                            height: 10.0,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                child: RichText(text: modifyDesc(abilityData(snapshot.data, 'desc')),textScaleFactor: 1.0)
                            ),
                          ),
                          VideoPlayerCust(snapshot.data.skillp_video,snapshot.data.skill1_video,snapshot.data.skill2_video,snapshot.data.skill3_video,snapshot.data.skill4_video,),
                          //modifyDesc(abilityData(userDocument, 'desc'))
                          // FutureBuilder<Ads>(
                          //   future: ads,
                          //   builder: (context, snapshot) {
                          //     if(snapshot.hasData) {
                          //       return _showAds(snapshot.data.type);
                          //     }
                          //     return Container();
                          //   },
                          // )
                        ],
                      )
                  ),
                ],
              );
            } else if (snapshot.hasError){
              print(snapshot.error.toString());
            }
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container()
              ],
            );
            // return Padding(
            //   padding: const EdgeInsets.only(top:150.0),
            //   child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
            //       child: CupertinoActivityIndicator(radius: 12,)),
            // );
          }
      ),
    );
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


  void _toggleFullscreen() async {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

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
            // _controlView(context)
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
}
