
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/icon_fonts/blue_motes_icons.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/screens/rnsRunes.dart';
import 'package:riftplus02/screens/tab_screens/ml_buffs_screen.dart';
import 'package:riftplus02/screens/tab_screens/ml_laning_screen.dart';
import 'package:riftplus02/screens/tab_screens/ml_vision_screen.dart';
import 'package:riftplus02/screens/zoom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:video_player/video_player.dart';

import '../apptheme.dart';
import '../main.dart';
import 'app.dart';
import 'dropdown_below.dart';



class MapLanes extends StatefulWidget {
  const MapLanes({Key key, this.id, this.image, this.name, this.desc, this.price, this.type,}) : super(key: key);
  final String id;
  final String image;
  final String name;
  final String desc;
  final String price;
  final String type;

  @override
  _MapLanesState createState() => _MapLanesState();
}

class _MapLanesState extends State<MapLanes>  with TickerProviderStateMixin{
  final number = new ValueNotifier('0');



  AppValueNotifier appValueNotifier = AppValueNotifier();


  TabController _tabController2;
  var currentIndex;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _generalWidgets = List<Widget>();
  final int _startingTabCount = 3;
  var preferences;
  bool changingLan = false;

  var globLang = 'EN';
  void initState() {
    _initStreamPref();
    _tabs = getTabs(_startingTabCount);
    _tabController2 = getTabController();
    _tabController2.addListener(_handleTabSelection);
    currentIndex = 0;
    super.initState();



  }
  void _handleTabSelection() {
    setState(() {
      currentIndex = _tabController2.index;
    });
  }
  var langsStream;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: AppTheme.secBgColor,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  appBar(),
                  Container(
                    decoration: BoxDecoration(
                        color: AppTheme.thirdBgColor,
                        border: Border(
                          bottom: BorderSide(color: AppTheme.lineColor, width: 1),
                        )
                    ),
                    child: TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 1.0, color: AppTheme.borderColor),

                      ),
                      labelColor: AppTheme.borderColor,
                      unselectedLabelColor: AppTheme.labText,
                      tabs: [
                        Tab(
                          child: Text(
                            'LANING',
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
                            'BUFFS',
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
                            'VISION',
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
                        )
                      ],
                      controller: _tabController2,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          color: AppTheme.priBgColor,
                          child: TabBarView(
                            controller: _tabController2,
                            children: getWidgets(),
                          ),
                        ),
                        changingLan?Positioned.fill(
                          child: Container(
                            color: AppTheme.priBgColor,
                          ),
                        ):Container(),
                      ],
                    ),
                  ),

                  //tabBodyInner
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: Platform.isIOS? AdmobBanner(
              //       adUnitId: getBannerAdUnitId(),
              //       adSize: AdmobBannerSize.SMART_BANNER(context),
              //     ): AdmobBanner(
              //       adUnitId: getBannerAdUnitId(),
              //       adSize: AdmobBannerSize.ADAPTIVE_BANNER(
              //         width: MediaQuery.of(context)
              //             .size
              //             .width
              //             .toInt(), // considering EdgeInsets.all(20.0)
              //       ),
              //     ),
              //   ),
              // ),


              Align(
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
              )
            ],
          ),
        )
    );
  }
  Future<void> _initStreamPref() async {
    WidgetsFlutterBinding.ensureInitialized();
    preferences = await StreamingSharedPreferences.instance;

    Preference<String> langsStream = preferences.getString('language', defaultValue: 'EN');

    langsStream.listen((value) {
      print('Shared ' + value);
      if(value=="EN") {
        prevLang = "{no: EN, keyword: english}";
      } else {
        prevLang = "{no: MM, keyword: burmese}";
      }
    });

  }

  _setLanguage(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', index);

    preferences = await StreamingSharedPreferences.instance;
    preferences.setString('language', index);
    number.value = index;
    setState(() {

    });
    //appValueNotifier.incrementNotifier();
    print(preferences.getString('language', defaultValue: 'EN'));
  }



  _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getString('language');
    print(index);
    if(index == null) {
      return 'EN';
    }
    return index;
  }
  var _selectedTest = 'EN';
  var languages;
  Widget appBar() {
    List _testList = [{'no': 'EN', 'keyword': 'english'},{'no': 'MM', 'keyword': 'burmese'}];
    List<DropdownMenuItem> _dropdownTestItems;
    _dropdownTestItems = buildDropdownTestItems(_testList);
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 1.0))
      ),
      child: SizedBox(
        height: AppBar().preferredSize.height,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
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
                        child: Container(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: ValueListenableBuilder(
                          valueListenable: appValueNotifier.valueNotifier,
                          builder: (context, value, child) {
                            return Text(
                              'SUMMONER\'S RIFT',
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontFamily: 'beaufortforlol',
                                fontSize: 21,
                                color: AppTheme.lightText,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                            );
                          },
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Container(
                    width: AppBar().preferredSize.height - 8,
                    height: AppBar().preferredSize.height - 8,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 15.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child:  DropdownBelow(
                    itemWidth: 140,
                    itemTextstyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black26),
                    boxTextstyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0XFFbbbbbb)),
                    boxPadding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    boxWidth: 140,
                    boxHeight: 45,
                    // hint: Padding(
                    //   padding: const EdgeInsets.only(top: 1.5, right: 5.0),
                    //   child: Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Container(
                    //       child: FutureBuilder(
                    //         future: languages,
                    //         builder: (context, snapshot) {
                    //           if(snapshot.hasData) {
                    //             return Text(snapshot.data,
                    //               textAlign: TextAlign.right,
                    //               style: TextStyle(
                    //                 fontFamily: 'language',
                    //                 color: Colors.white38,
                    //                 fontSize: 14,
                    //               ),
                    //             );
                    //           }
                    //           return Container();
                    //
                    //         }
                    //
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    value: null,
                    items: _dropdownTestItems,
                    onChanged: onChangeDropdownTests,
                  ),
                  onTap: () {
                    //Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem> items = List();
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword']),
        ),
      );
    }
    return items;
  }

  getSelectedLang(index) {
    if(index.contains('english')) {
      return 'EN';
    } else if (index.contains('burmese')) {
      return 'MM';
    }
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5851001553018666/2287026456';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5851001553018666/2854836810';
    }
    return null;
  }

  var prevLang = "{no: EN, keyword: english}";
  onChangeDropdownTests(selectedTest) async{
    AppState().showAlert(context);
    setState(() {
      changingLan = true;
    });
    _setLanguage(getSelectedLang(selectedTest.toString()));
    setState(() {
      languages = _getLanguage();
    });
    Future.delayed(const Duration(milliseconds: 2500), () {

      setState(() {
        changingLan = false;
      });

    });

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
            height: 1.1,
            color: AppTheme
                .labText,
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      //print(abilityData.substring(abilityData.indexOf('<') + 8));
      if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<phydmg>') {
//        st += '(phydmg)';
        textSpan.children.add(
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                child: Icon(
                  RiftPlusIcons.mana,
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
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
                padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                child: Icon(
                  RiftPlusIcons.shield,
                  color: AppTheme.shield,
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
              height: 1.1,
              color: AppTheme.shieldBreak,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.speed,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.criticalStrike,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.magicPenetration,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.shield,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.magicDamage,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.abilityPower,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.health,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.physicalDamage,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtpd>') + 8);
      } else if (abilityData.substring(indexOfDef, indexOfDef + 8) == '<[txtmn>') {
        var inner = '';
        inner += abilityData.substring(abilityData.indexOf('<[txtmn>') + 8, abilityData.indexOf('<]txtmn>'));
        textSpan.children.add(
          TextSpan(
            text: inner,
            style: TextStyle(
              fontFamily: 'spiegel',
              fontSize: 15,
              height: 1.1,
              color: AppTheme.mana,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.coolDown,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.attackSpeed,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              color: AppTheme.wildCores,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
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
              height: 1.1,
              fontSize: 12,
              color: AppTheme.labText,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        abilityData = abilityData.substring(abilityData.indexOf('<]txtmm>') + 8);
      }


    }
    textSpan.children.add(
      TextSpan(
        text: abilityData,
        style: TextStyle(
          fontFamily: 'spiegel',
          height: 1.1,
          fontSize: 15,
          color: AppTheme
              .labText,
          letterSpacing: 0,
          fontWeight: FontWeight.w600,
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
  ItemsPros(snapshot) {
    Column column = Column(
      children: [
        SizedBox()
      ],
    );
    snapshot.data.documents.map<Widget>((document) {
      column.children.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top:5.0, bottom:0.0),
              child: Container(
                child: RichText(
                    text: modifyDesc(document['text'])
                ),
              ),
            ),
          )
      );
    }).toList();
    return column;
//    if(widget.id.contains('physical')&&widget.id.contains('basic')) {
//      return StreamBuilder(
//          stream: Firestore.instance.collection('items').document('physical').collection('basic').snapshots(),
//          builder: (context, snapshot) {
//          return Align(
//            alignment: Alignment.centerLeft,
//            child: Padding(
//              padding: const EdgeInsets.only(left: 20.0, top:15.0, bottom:0.0),
//              child: Container(
//                child: RichText(
//                    text: TextSpan(
//                        style: Theme.of(context).textTheme.body1,
//                        children: [
//                          WidgetSpan(
//                            child: Padding(
//                              padding: const EdgeInsets.only(right: 5.0),
//                              child: Icon(
//                                RiftPlusIcons.cooldown,
//                                color: AppTheme.coolDown2,
//                                size: 15,
//                              ),
//                            ),
//                          ),
//                          TextSpan(
//                            text: 'asefasf',
//                            style: TextStyle(
//                              fontFamily: 'spiegel',
//                              fontSize: 15,
//                              color: AppTheme
//                                  .labTextActive,
//                              letterSpacing: 0,
//                              fontWeight: FontWeight.w600,
//                            ),
//                          ),
//                        ]
//                    )
//                ),
//              ),
//            ),
//        );
//      },
//    );
//    }

  }

  List<Widget> getWidgets() {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(getWidget(i));
    }
    return _generalWidgets;
  }

  Widget getWidget(int widgetNumber) {
//    setState(() {
//      tabIndex = widgetNumber;
//    });
    if (widgetNumber == 0) {
      return MLLaningScreen();
    } else if (widgetNumber == 1) {
      return MLBuffsScreen();
    } else {
      return MLVisionScreen();
    }
  }

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this);
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      _tabs.add(getTab(i));
    }
    return _tabs;
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



}
