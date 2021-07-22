import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/screens/items_boots_api.dart';
import 'package:riftplus02/screens/items_defence_api.dart';
import 'package:riftplus02/screens/items_magical_api.dart';
import 'package:riftplus02/screens/items_physical_api.dart';
import 'package:riftplus02/screens/screen01_01.dart';
import 'package:riftplus02/screens/screen01_fighter.dart';
import 'package:riftplus02/screens/screen01_mage.dart';
import 'package:riftplus02/screens/screen01_tank.dart';
import 'package:riftplus02/screens/zoom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../apptheme.dart';
import '../fintness_app_theme.dart';
import 'app.dart';
import 'dropdown_below.dart';

class ItemsHome extends StatefulWidget {
  const ItemsHome({Key key}) : super(key: key);

  @override
  _ItemsHomeState createState() => _ItemsHomeState();
}

class _ItemsHomeState extends State<ItemsHome>  with TickerProviderStateMixin {
  TabController _tabController2;
  var currentIndex;
  final int _startingTabCount = 4;
  List<Tab> _tabs = List<Tab>();
  Widget tabBodyInner = Container(
    color: FitnessAppTheme.background,
  );
  List<Widget> _generalWidgets = List<Widget>();
  bool changingLan = false;
  var preferences;
  var prevLang = "{no: EN, keyword: english}";
  bool bannerLoaded=false;

  final String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  void initState() {
    _initStreamPref();
    _tabs = getTabs(_startingTabCount);
    _tabController2 = getTabController();
    _tabController2.addListener(_handleTabSelection);
    //tabBodyInner = ScreenOneOne();
    currentIndex = 0;
    super.initState();
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

  void _handleTabSelection() {
    setState(() {
      currentIndex = _tabController2.index;
    });
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
                  labelColor: AppTheme.borderColor,
                  unselectedLabelColor: AppTheme.labText,
                  tabs: [
                    Tab(
                      child: Text(
                          'PHYSICAL',
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
                          'MAGIC',
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
                          'DEFENSE',
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
                          'BOOTS',
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
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1.0)),
                  color: AppTheme.thirdBgColor,
                ),

                height: bannerLoaded? 50:0,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, 0),
                    child: Transform.scale(
                      scale: 1.04,
                      child: FacebookBannerAd(
                        placementId: Platform.isAndroid ? "YOUR_ANDROID_PLACEMENT_ID" : "326003882589802_328482025675321",
                        bannerSize: BannerSize.STANDARD,
                        listener: (result, value) {
                          switch (result) {
                            case BannerAdResult.ERROR:
                              print("Error: $value");
                              break;
                            case BannerAdResult.LOADED:
                              setState(() {
                                bannerLoaded = true;
                              });
                              print("Loaded: $value");
                              break;
                            case BannerAdResult.CLICKED:
                              print("Clicked: $value");
                              break;
                            case BannerAdResult.LOGGING_IMPRESSION:
                              print("Logging Impression: $value");
                              break;
                          }
                        },
                      ),
                    ),
                  ),
                ),
              )
          ),

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
    );
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
      return ItemsPhysicalAPI();
    } else if (widgetNumber == 1){
      return ItemsMagicalAPI();
    } else if (widgetNumber == 2){
      return ItemsDefenceAPI();
    } else if (widgetNumber == 3){
      return ItemsBootsAPI();
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
                        child: Container(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(
                          'ITEMS',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontFamily: 'beaufortforlol',
                            fontSize: 21,
                            color: AppTheme.lightText,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
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

  onChangeDropdownTests(selectedTest) async{
    // setState(() {
    //   _selectedTest = getSelectedLang(selectedTest.toString());
    // });
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

}