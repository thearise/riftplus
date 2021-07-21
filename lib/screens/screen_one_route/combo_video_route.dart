import 'dart:convert';
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
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
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
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

class ComboVideoRoute extends StatefulWidget {
  const ComboVideoRoute({Key key, this.video, this.skill1, this.skill2, this.skill3,
    this.skill4, this.skill5, this.skill6, this.skill7, this.skill8, this.skill9, this.skill10, this.name, this.desc,
    this.champSkp, this.champSk1, this.champSk2, this.champSk3, this.champSk4,}) : super(key: key);
  final String video;
  final String skill1;
  final String skill2;
  final String skill3;
  final String skill4;
  final String skill5;
  final String skill6;
  final String skill7;
  final String skill8;
  final String skill9;
  final String skill10;
  final String name;
  final String desc;
  
  final String champSkp;
  final String champSk1;
  final String champSk2;
  final String champSk3;
  final String champSk4;


  @override
  _ComboVideoRouteState createState() => _ComboVideoRouteState();
}

class _ComboVideoRouteState extends State<ComboVideoRoute>  with TickerProviderStateMixin{
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {

    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();

    super.dispose();

  }

  Future<void> initializePlayer() async {
    AppState().increaseGloAdsInt(2);
    // _videoPlayerController1 = VideoPlayerController.network(
    //     'https://vod-progressive.akamaized.net/exp=1621866467~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F2747%2F14%2F363737105%2F1496953606.mp4~hmac=338a92b333db6f4c0bfbcb79de889d01ee5e426bfbdf1e9b664456e4b76042bd/vimeo-prod-skyfire-std-us/01/2747/14/363737105/1496953606.mp4');
    _videoPlayerController1 = VideoPlayerController.network(
        widget.video);
    _videoPlayerController2 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: false,
      looping: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],

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

  @override
  Widget build(BuildContext context) {
    // showComboVideo2(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black87,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 50.0),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left:20.0, right:20.0),
                        child: Container(
                          height: (MediaQuery.of(context).size.width-40)/1.77,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            child: Center(
                              child: _chewieController != null &&
                                  _chewieController
                                      .videoPlayerController.value.initialized
                                  ? Stack(
                                    children: [
                                      Container(
                                        color: Colors.black,
                                        width: MediaQuery.of(context).size.width-40,
                                        height: (MediaQuery.of(context).size.width-40)/1.77,
                                      ),
                                      Chewie(
                                controller: _chewieController,
                              ),

                                    ],
                                  )
                                  : AspectRatio(
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
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20.0, bottom: 10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width/7.8,
                          child: ListView(
                            scrollDirection: Axis.horizontal,

                            children: [
                              SizedBox(width: 20,),
                              widget.skill1 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill1),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill1),
                                                widget.skill1.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill1),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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


                              widget.skill2 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill2 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill2),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill2),
                                                widget.skill2.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill2),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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


                              widget.skill3 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill3 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill3),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill3),
                                                widget.skill3.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill3),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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


                              widget.skill4 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill4 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill4),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill4),
                                                widget.skill4.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill4),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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


                              widget.skill5 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill5 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill5),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill5),
                                                widget.skill5.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill5),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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


                              widget.skill6 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill6 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill6),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill6),
                                                widget.skill6.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill6),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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

                              widget.skill7 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill7 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill7),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill7),
                                                widget.skill7.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill7),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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

                              widget.skill8 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill8 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill8),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill8),
                                                widget.skill8.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill8),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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

                              widget.skill9 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill9 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill9),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill9),
                                                widget.skill9.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill9),
                                                      style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          height: 1.3,
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

                              widget.skill10 != '' ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right:2.0),
                                    child: Icon(RiftPlusIcons.detail_arrow,color: AppTheme.labTextActive2,size: MediaQuery.of(context).size.width/20,),
                                  )
                              ): Container(),
                              widget.skill10 != '' ? Container(
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
                                          message: skillComboTooltip(widget.skill10),
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
                                          child: Container(
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                _combosImage(widget.skill10),
                                                widget.skill10.contains('http')?Container(
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.skillNo,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                  child: Center(
                                                    child: Text(
                                                      skillComboNo(widget.skill10),
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
                      Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                                  child: Text(
                                    widget.name,
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

                          ]
                      ),
                      Container(
                        height: 120,
                        child: ShaderMask(
                          shaderCallback: (Rect rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                              stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                                    child: Text(
                                      widget.desc.toString(),
                                      textScaleFactor: 1,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'spiegel',
                                          color: AppTheme.labTextActive,
                                          height: 1.3
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              appBar(),
            ],
          ),
        ),
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
      return widget.champSkp;
    } else if(image.contains('1.png')) {
      return widget.champSk1;
    } else if(image.contains('2.png')) {
      return widget.champSk2;
    } else if(image.contains('3.png')) {
      return widget.champSk3;
    } else if(image.contains('4.png')) {
      return widget.champSk4;
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

  Widget appBar() {
    return Container(
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
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    '',
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
              padding: const EdgeInsets.only(right: 15.0, top: 10.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: AppTheme.activeIcon, width: 1),
                        top: BorderSide(color: AppTheme.activeIcon, width: 1),
                        left: BorderSide(color: AppTheme.activeIcon, width: 1),
                        right: BorderSide(color: AppTheme.activeIcon, width: 1),
                      ),
                    color: AppTheme.secBgColor
                  ),
                width: 35,
                height: 35,
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
                        RiftPlusIcons.close,
                        color: AppTheme.activeIcon,
                        size: 26,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showComboVideo2(BuildContext context) {
    // Navigator.push(context, FadeRoute(page: ComboVideoRoute()));
  }




}