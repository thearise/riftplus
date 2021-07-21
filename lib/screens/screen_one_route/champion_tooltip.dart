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

class ChampionTooltip extends StatefulWidget {
  const ChampionTooltip({Key key}) : super(key: key);


  @override
  _ChampionTooltipState createState() => _ChampionTooltipState();
}

class _ChampionTooltipState extends State<ChampionTooltip>  with TickerProviderStateMixin{
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // showComboVideo2(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.8),
            child: SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 11, right: 4.5),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.secBgColor,
                            borderRadius: BorderRadius.circular(50),
                            // border: Border(
                            //   bottom: BorderSide(color: AppTheme.activeIcon, width: 1),
                            //   top: BorderSide(color: AppTheme.activeIcon, width: 1),
                            //   left: BorderSide(color: AppTheme.activeIcon, width: 1),
                            //   right: BorderSide(color: AppTheme.activeIcon, width: 1),
                            // )
                          ),

                          width: 43,
                          height: 43,
                          child: Icon(
                            Icons.language,
                            size: 22,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Language',
                            textScaleFactor: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'spiegel',
                              fontSize: 20,
                              color: AppTheme.blueAccent,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Change burmese(မြန်မာ)\nlanguage here',
                            textScaleFactor: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




}