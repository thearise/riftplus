import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:riftplus02/custom_drawer/drawer_user_controller.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/screens/app.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
import 'package:riftplus02/screens/screen01_01.dart';
// import 'package:riftplus02/screens/screen01_02.dart';
import 'package:riftplus02/screens/screen01_assasin.dart';
import 'package:riftplus02/screens/screen01_controller.dart';
import 'package:riftplus02/screens/screen01_fighter.dart';
import 'package:riftplus02/screens/screen01_mage.dart';
import 'package:riftplus02/screens/screen01_maskman.dart';
import 'package:riftplus02/screens/screen01_tank.dart';
import 'package:riftplus02/screens/zoom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
// import 'package:riftplus02/screens/screen_one_route/champion_route.dart';
// import 'package:riftplus02/views/championsbarview.dart';

import 'package:appodeal_flutter/appodeal_flutter.dart';

import '../apptheme.dart';
import '../fintness_app_theme.dart';
import 'dropdown_below.dart';
// import 'homescreen.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key key}) : super(key: key);

  // method() => createState().methodInPage2();

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne>  with TickerProviderStateMixin{
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return MailPage();
  }




}

// class RootScaffold {
//   static openDrawer(BuildContext context) {
//     final ScaffoldState scaffoldState =
//     context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
//     scaffoldState.openDrawer();
//   }
//
//   static ScaffoldState of(BuildContext context) {
//     final ScaffoldState scaffoldState =
//     context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
//     return scaffoldState;
//   }
// }





class MailPage extends StatefulWidget {
  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> with TickerProviderStateMixin{
  GlobalKey _one = GlobalKey();
  GlobalKey _globOne = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  final String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};



  // final DrawerUserController ani= new DrawerUserController();

  var currentIndex;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  AnimationController animationController;
  bool multiple = true;
  Widget tabBodyInner = Container(
    color: FitnessAppTheme.background,
  );
  final int _startingTabCount = 7;
  TabController _tabController2;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _generalWidgets = List<Widget>();
  bool changingLan = false;
  int tabIndex;
  var preferences;
  var prevLang = "{no: EN, keyword: english}";




  @override
  void initState() {





    // print("Widget.id" + widget.data.toString());
    _tabs = getTabs(_startingTabCount);
    _tabController2 = getTabController();
    //_tabController2.index = 0;
    // championsTabDataList.forEach((ChampionsTabData tab) {
    //   tab.isSelected = false;
    // });
    // championsTabDataList[0].isSelected = true;
    _tabController2.addListener(_handleTabSelection);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    tabBodyInner = ScreenOneAssasin();
    currentIndex = 0;
    _initStreamPref();
    languages = _getLanguage();

    super.initState();
    //Start showcase view after current widget frames are drawn.
    // WidgetsBinding.instance!.addPostFrameCallback((_) =>
    //     ShowCaseWidget.of(context)!
    //         .startShowCase([_one, _two, _three, _four, _five]));


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
  void _handleTabSelection() {
    setState(() {
      currentIndex = _tabController2.index;
    });
//    if (_tabController2.) {
//      print('changed');
////      switch (_tabController2.index) {
////        case 0:
////          print('case1');
////          break;
////        case 1:
////          print('case2');
////          break;
////      }
//    }
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
    animationController.dispose();
    _tabController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: false,
      right: false,
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
                  tabs: [
                    Tooltip(
                      verticalOffset: -69,
                      child: Tab(
                        icon: currentIndex == 0 ? Icon(
                          RiftPlusIcons.allroles,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.allroles,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'All',
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
                    Tooltip(
                      child: Tab(
                        icon: currentIndex == 1 ? Icon(
                          RiftPlusIcons.fighter,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.fighter,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'Fighter',
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
                      verticalOffset: -69,
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
                    Tooltip(
                      verticalOffset: -69,
                      child: Tab(
                        icon: currentIndex == 2 ? Icon(
                          RiftPlusIcons.tank,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.tank,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'Tank',
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
                    Tooltip(
                      verticalOffset: -69,
                      child: Tab(
                        icon: currentIndex == 3 ? Icon(
                          RiftPlusIcons.mage,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.mage,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'Mage',
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
                    Tooltip(
                      verticalOffset: -69,
                      child: Tab(
                        icon: currentIndex == 4 ? Icon(
                          RiftPlusIcons.assasin,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.assasin,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'Assassin',
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
                    Tooltip(
                      verticalOffset: -69,
                      child: Tab(
                        icon: currentIndex == 5 ? Icon(
                          RiftPlusIcons.support,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.support,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'Support',
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
                    Tooltip(
                      verticalOffset: -69,
                      child: Tab(
                        icon: currentIndex == 6 ? Icon(
                          RiftPlusIcons.marksman,
                          size: 22,
                          color: AppTheme.activeIcon,
                        ): Icon(
                          RiftPlusIcons.marksman,
                          size: 22,
                          color: AppTheme.normalIcon,
                        ),
                      ),
                      message: 'Marksman',
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
                  controller: _tabController2,
                ),
              ),
              Container(
//            decoration: BoxDecoration(
//                border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 1.0))),
//                child: TabBarView(
//                  controller: _tabController,
//                  children: getWidgets(),
//                ),
//            child: SizedBox(
//              height: 50,
//              child: Padding(
//                padding:
//                const EdgeInsets.only(left: 8, right: 8, top: 0),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Row(
//                        children: [
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/all_icon.png',
//                              height: 25,),
//                          ),
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/fighter_icon.png',
//                              height: 25,),
//                          ),
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/tank_icon.png',
//                              height: 25,),
//                          ),
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/mage_icon.png',
//                              height: 25,),
//                          ),
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/assasin_icon.png',
//                              height: 25,),
//                          ),
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/controller_icon.png',
//                              height: 25,),
//                          ),
//                          Expanded(
//                            child: Image.asset(
//                              'assets/images/championroleicons/marksman_icon.png',
//                              height: 25,),
//                          ),
//                        ],
//                      )
//                    ),
//                  ],
//                ),
//              ),
//            ),
              ),
//          ChampionsBarView(
//            championsTabDataList: championsTabDataList,
//            addClick: () {},
//            changeIndex: (int index) {
//              print(index);
//              if (index == 0) {
//                animationController.reverse().then<dynamic>((data) {
//                  if (!mounted) {
//                    return;
//                  }
//                  setState(() {
//                    tabBodyInner = ScreenOneOne();
//                  });
//                });
//              } else if (index == 1) {
//                animationController.reverse().then<dynamic>((data) {
//                  if (!mounted) {
//                    return;
//                  }
//                  setState(() {
//                    tabBodyInner = ScreenOneTwo();
//                  });
//                });
//              }
//            },
//          ),
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
              )
//          tabBodyInner
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
              child: Container(
                child: Container(
                  height: 50,
                  // color: Colors.black,
                  child: Container(
                    child: AppodealBanner(),
                    // child: FacebookBannerAd(
                    //   placementId: Platform.isAndroid ? "708437736767412_840270023584182" : "708437736767412_840257316918786",
                    //   // bannerSize: BannerSize.STANDARD,
                    //   listener: (result, value) {
                    //     switch (result) {
                    //       case BannerAdResult.ERROR:
                    //         print("Error: $value");
                    //         break;
                    //       case BannerAdResult.LOADED:
                    //         print("Loaded: $value");
                    //         break;
                    //       case BannerAdResult.CLICKED:
                    //         print("Clicked: $value");
                    //         break;
                    //       case BannerAdResult.LOGGING_IMPRESSION:
                    //         print("Logging Impression: $value");
                    //         break;
                    //     }
                    //   },
                    // ),
                  )
                ),
                // color: AppTheme.thirdBgColor,
    //             child: Align(
    //               alignment: Alignment.bottomCenter,
    // // UnityAds.isReady(placementId: 'video_placement_id');
    // //             child: CustomUnityBanner('Banner_iOS'),
    //               child: Transform.translate(
    //                 offset: Offset(-141, 5),
    //                 child: Transform.scale(
    //                   scale: 0.8,
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(right: 28.0),
    //                     child: UnityBannerAd(
    //                       placementId: 'Banner_iOS',
    //                       listener: (state, args) {
    //                         print('Banner Listener: $state => $args');
    //                       },
    //                       size: BannerSize(),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),


                // child: Platform.isIOS?UiKitView(
                //   viewType: viewType,
                //   layoutDirection: TextDirection.ltr,
                //   creationParams: creationParams,
                //   creationParamsCodec: const StandardMessageCodec(),
                // ):AndroidView(
                //   viewType: viewType,
                //   layoutDirection: TextDirection.ltr,
                //   creationParams: creationParams,
                //   creationParamsCodec: const StandardMessageCodec(),
                // ),
                // child: Container()
              ),
            ),
          ),
        ],
      ),
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
      return ScreenOneOne();
    } else if (widgetNumber == 1){
      return ScreenOneFighter();
    } else if (widgetNumber == 2){
      return ScreenOneTank();
    } else if (widgetNumber == 3){
      return ScreenOneMage();
    } else if (widgetNumber == 4){
      return ScreenOneAssasin();
    } else if (widgetNumber == 5){
      return ScreenOneController();
    } else if (widgetNumber == 6){
      return ScreenOneMaskman();
    }
//    return Center(
//      child: Text("Widget nr: $widgetNumber"),
//    );
  }

  _setLanguage(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', index);
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
                        // child: Icon(
                        //   RiftPlusIcons.inbox,
                        //   color: AppTheme.activeIcon,
                        //   size: 27,
                        // ),
                        child: Container(),
                        onTap: () {
                          // DrawerUserController().me;
                          // _drawerKey.currentState.openDrawer();
                          // RootScaffold.openDrawer(context);

                          //Provider.of<MenuController>(context, listen: false).toggle();
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
                          'CHAMPIONS',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontFamily: 'beaufortforlol',
                            fontSize: 21,
                            color: AppTheme.lightText,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
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
              padding: const EdgeInsets.only(top: 8.0, right: 0.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child:  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6.0, top: 2.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0, bottom: 5.0),
                          child: DropdownBelow(
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
                        ),
                      ),

                    ],
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


  onChangeDropdownTests(selectedTest) async{
    // setState(() {
    //   _selectedTest = getSelectedLang(selectedTest.toString());
    // });
    // print('ASHINE ' + selectedTest.toString());
    //
    // print('ASHINE 2 ' + prevLang);

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


    // prevLang = selectedTest.toString();

  }

  // CustomUnityBanner(placeId) async {
  //   return ;
  // }
}


class MailTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[200],
                  ),
                  child: Center(
                    child: Container(),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'mail.sender',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'mail.sub',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'mail.msg',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                'mail.date',
                style: TextStyle(
                ),
              ),
              Icon(
                Icons.star_border,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}





