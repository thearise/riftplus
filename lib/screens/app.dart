import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:connectivity/connectivity.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/main.dart';
import 'package:riftplus02/screens/reloadListView.dart';
import 'package:riftplus02/screens/runesNSpells.dart';
import 'package:riftplus02/screens/screen01.dart';
import 'package:http/http.dart' as http;
import 'package:riftplus02/screens/screen_one_route/champion_route_test.dart';
import 'package:riftplus02/screens/screen_one_route/dragon_lane.dart';
import 'package:riftplus02/screens/zoom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../apptheme.dart';
import 'ConnectionStatusSingleton.dart';
import 'article.dart';
import 'itemsHome.dart';
import 'mapLanes.dart';
import 'menu_page.dart';
import 'news_detail.dart';
import 'news_list_tile.dart';
import 'screen_one_route/combo_video_route.dart';
import 'tabItem.dart';
import 'bottomNavigation.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
// import 'screens.dart';

Future<Ads> fetchAds() async {
  final response =
  await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/mainAds.php');

  // Use the compute function to run parsePhotos in a separate isolate.
  print('HERE ' + response.statusCode.toString());
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Ads.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
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

Future<Infos> fetchInfos() async {
  final response =
  await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getConfig.php');

  // Use the compute function to run parsePhotos in a separate isolate.
  print('HERE ' + response.statusCode.toString());
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Infos.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Infos {
  final String app_update;
  final String ios_app_update;
  final String main_ads;
  final String innerbots_ads;
  final String more_ads;
  final String version_code;
  final String whats_new;
  final String android_url;
  final String android_url2;
  final String ios_url;
  final String ios_url2;
  final String is_skipable;
  final String interInt;
  final String interInt2;

  Infos({this.app_update, this.ios_app_update, this.main_ads, this.innerbots_ads, this.more_ads, this.version_code, this.whats_new, this.android_url, this.android_url2, this.ios_url, this.ios_url2, this.is_skipable, this.interInt, this.interInt2});

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
        app_update: json['app_update'],
        ios_app_update: json['ios_app_update'],
        main_ads: json['main_ads'],
        innerbots_ads: json['innerbots_ads'],
        more_ads: json['more_ads'],
        version_code: json['version_code'],
        whats_new: json['whats_new'],
        android_url: json['android_url'],
        android_url2: json['android_url2'],
        ios_url: json['ios_url'],
        ios_url2: json['ios_url2'],
        is_skipable: json['is_skipable'],
        interInt: json['interInt'],
        interInt2: json['interInt2']
    );
  }
}


class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> with TickerProviderStateMixin<App>{
  var tthighLight = false;
  var langTt = true;
  var pressTt = false;
  var ttPressC = 0;
  // @override
  // bool get wantKeepAlive => true;
  GlobalKey<AppState> langKey = GlobalKey();
  GlobalKey _globOne = GlobalKey();
  GlobalKey _globTwo = GlobalKey();

  String abc = "bb";

  callback(newAbc) {
    setState(() {
      abc = newAbc;
    });
  }



  // FacebookAudienceNetwork.init(
  //   // testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
  //   // iOSAdvertiserTrackingEnabled: true //default false
  // );

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  Future<Infos> infos;
  Future<Infos> infos2;
  Future<Ads> ads;
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  bool later = false;
  static int currentTab = 0;
  static double gloAdsInt = 0;
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';
  StreamSubscription _connectionChangeStream;

  // static AdmobInterstitial interstitialAd;
  static var data;

  bool internet = true;
  bool langChanging = false;
  MenuController menuController;
  static int interIntGlob = 10;
  static MyAppSettings locSettings;
  @override
  void initState() {
    super.initState();
    // Appodeal.setAppKeys(
    //     androidAppKey: 'a8381f5f6a2794a69600c0db8f90e4bc6f101d047d9dce08',
    //     iosAppKey: '9e3c378eb61f2bdb8071023cc063e1af7045d64ff41d0848');
    //
    // // Defining the callbacks
    // Appodeal.setBannerCallback((event) => print('Banner ad triggered the event $event'));
    // Appodeal.setInterstitialCallback((event) => print('Interstitial ad triggered the event $event'));
    // Appodeal.setRewardCallback((event) => print('Reward ad triggered the event $event'));
    // Appodeal.setNonSkippableCallback((event) => print('Non-skippable ad triggered the event $event'));
    //
    // // Request authorization to track the user
    // Appodeal.requestIOSTrackingAuthorization().then((_) async {
    //   // Set interstitial ads to be cached manually
    //   await Appodeal.setAutoCache(AdType.INTERSTITIAL, false);
    //
    //   // Initialize Appodeal after the authorization was granted or not
    //   await Appodeal.initialize(
    //       hasConsent: true,
    //       adTypes: [AdType.BANNER, AdType.INTERSTITIAL, AdType.REWARD, AdType.NON_SKIPPABLE],
    //       testMode: false);
    //
    //   setState(() => this.isAppodealInitialized = true);
    //   print('appodeal2 shwe');
    //
    // });


    FacebookAudienceNetwork.init(
        testingId: "0363a064-bf86-4c56-9e04-c26b20b9ba98", //optional
        iOSAdvertiserTrackingEnabled: true //default false
    );








    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    WidgetsFlutterBinding.ensureInitialized();
    // Admob.initialize(testDeviceIds: ['b23595b61cbdc55f38d866d533222ed5']);

    // FacebookAudienceNetwork.init(
    //   testingId: Platform.isAndroid? "3b446e6e-dc91-4503-9348-2d02c85ef584":"dae9c80a-8efa-ca08-8d0c-a0cd9ff3d5e1", //optional
    //   iOSAdvertiserTrackingEnabled: true //default false
    // );

    // Admob.initialize();
    // Admob.requestTrackingAuthorization();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    infos = fetchInfos();
    ads = fetchAds();

    infos.then((val) {
      print('shining star ' + val.interInt2);
      setState(() {
        interIntGlob = int.parse(val.interInt2);
      });

    });




    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkFirstSeen();

      // Future.delayed(Duration(milliseconds: 2500), () {
      //   ShowCaseWidget.of(context).startShowCase([_globOne]);
      // });

    });

    // interstitialAd = AdmobInterstitial(
    //   adUnitId: getInterstitialAdUnitId(),
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) interstitialAd.load();
    //     handleEvent(event, args, 'Interstitial');
    //   },
    // );
    // interstitialAd.load();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }


  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new Home()));
    } else {
      await prefs.setBool('seen', true);
      setState(() {
        tthighLight = true;
      });
      // ShowCaseWidget.of(context).startShowCase([_globOne]);
      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  static int alreadyShow = 2;

  increaseGloAdsInt(num) async {
    gloAdsInt += num;

    // print('shining star ' + infos2.data.interInt.toString());

    print('Glo Ads Int ' + gloAdsInt.toString());
    print('Already show ' + alreadyShow.toString());
    if (gloAdsInt >= interIntGlob) {
      print('inter pya ');
      gloAdsInt = 0;


      FacebookInterstitialAd.loadInterstitialAd(
        placementId: "326003882589802_328521285671395",
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            print('loaded inter 1');
            FacebookInterstitialAd.showInterstitialAd(delay: 0);
            print('loaded inter 2');
          }



        },
      );

      // var isReady = await Appodeal.isReadyForShow(AdType.INTERSTITIAL);
      // Toast.show(isReady ? 'Interstitial ad is ready' : 'Interstitial ad is NOT ready', context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      // Appodeal.show(AdType.INTERSTITIAL);
      // Random random = new Random();
      // int randomNumber = random.nextInt(3);
      //
      // print('randomNumber ' + randomNumber.toString());
      //
      // var isReady = await Appodeal.isReadyForShow(AdType.INTERSTITIAL);
      // var isReady1 = await Appodeal.isReadyForShow(AdType.NON_SKIPPABLE);
      // var isReady2 = await Appodeal.isReadyForShow(AdType.REWARD);
      //
      //
      // await Appodeal.show(AdType.INTERSTITIAL);

      // if(randomNumber==0) {
      //   if(isReady) {
      //     await Appodeal.show(AdType.INTERSTITIAL);
      //   } else {
      //     await Appodeal.show(AdType.REWARD);
      //   }
      //
      // } else if(randomNumber==1) {
      //   if(isReady1) {
      //     await Appodeal.show(AdType.REWARD);
      //   } else {
      //     await Appodeal.show(AdType.NON_SKIPPABLE);
      //   }
      //
      // } else if(randomNumber==2) {
      //   if(isReady2) {
      //     await Appodeal.show(AdType.REWARD);
      //   } else {
      //     await Appodeal.show(AdType.NON_SKIPPABLE);
      //   }
      // }


      // if (await interstitialAd.isLoaded) { // Google Inter
      //   print('shwe gyi yay.....1');
      //   // interstitialAd.show();
      //
      // } else {
      //   print('shwe gyi error.....2');
      //   // }
      //
      //   // UnityAds.showVideoAd(
      //   //   placementId: Platform.isIOS?'Interstitial_iOS':'Interstitial_Android',
      //   //   listener: (state, args) =>
      //   //       print('Interstitial Video Listener: $state => $args'),
      //   // );
      //
      //
      //   print('inter pya 2');
      // }
    }
  }


  void goPosPrefDetail(String pos) {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => DragonLane(desc: ''))
    );
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5851001553018666/4988464928';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5851001553018666/4629657684';
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-5851001553018666/2287026456';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5851001553018666/2854836810';
    }
    return null;
  }

  // void handleEvent(
  //     AdmobAdEvent event, Map<String, dynamic> args, String adType) {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       break;
  //     case AdmobAdEvent.opened:
  //       break;
  //     case AdmobAdEvent.closed:
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       break;
  //     case AdmobAdEvent.rewarded:
  //       break;
  //     default:
  //   }
  // }


  void connectionChanged(dynamic hasConnection) {
    print('CHANGED                      CHANGED' + hasConnection.toString());
    setState(() {
      //isOffline = !hasConnection;
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result.toString();
    });
    print("Connection Status " + result.toString());
  }



  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Champions",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: ScreenOne(),
    ),
    TabItem(
      tabName: "Items",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: ItemsHome(),
    ),
    TabItem(
      tabName: "Settings",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: RunesNSpells(),
    ),
    TabItem(
      tabName: "Settings",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: MapLanes(),
    ),
  ];


  AppState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }



  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  void dispose() {
    menuController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  var gg = 'gg';

  void disGloTab(BuildContext context) {
    // setState(() {
    //   gg = 'nogg';
    // });
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - 60),
          child: Container(
            color: Colors.black54,
          ),
        );
      });

    // setState(() {
    //   gg = 'gg wp';
    // });
  }

  void disGloTabOff() {
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.of(context).pop(true);
    });
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 2500), () {
            Navigator.of(context).pop(true);
          });
          return AbsorbPointer(
            child: SafeArea(
              top: true,
              bottom: true,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                title: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                              child: CupertinoActivityIndicator(radius: 12,)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text('Changing Language',
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
              ),
            ),
          );
        });
  }

  var state = '';

  disBotTabBar(BuildContext context) {
    // Navigator.push(
    //   context, FadeRoute(page: ComboVideoRoute()),
    // );

    setState(() {
      state = 'set';
    });
    // showDialog(
    //   barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return AbsorbPointer(
    //         child: Container(
    //           color: Colors.yellow,
    //           child: SafeArea(
    //             top: true,
    //             bottom: true,
    //             child: AlertDialog(
    //               backgroundColor: Colors.transparent,
    //               title: Stack(
    //                 children: [
    //                   Positioned.fill(
    //                     child: Container(
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(bottom: 80.0),
    //                         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
    //                             child: CupertinoActivityIndicator(radius: 12,)),
    //                       ),
    //                     ),
    //                   ),
    //                   Align(
    //                     alignment: Alignment.center,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 25.0),
    //                       child: Text('Changing Language',
    //                         textScaleFactor: 1,
    //                         style: const TextStyle(
    //                             fontSize: 15,
    //                             fontFamily: 'spiegel',
    //                             color: Colors.white54,
    //                             height: 1.3,
    //                             fontWeight: FontWeight.w300
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }

  Future<List<Article>> fetchNews(BuildContext context) async {
    String url = 'assets/data/general.json';
    String jsonString = await DefaultAssetBundle.of(context).loadString(url);

    List<dynamic> articlesData = json.decode(jsonString)['articles'];

    return articlesData.map((item) => Article.fromJson(item)).toList();
    // newsapi.org request
    //
    //String base = 'https://newsapi.org/v2';
    //String url = '$base/top-headlines?country=us&apiKey=$apiKey${category != null ? '&category=' + category.id : ''}';
    //final response = await http.get(url);
    //
    //if (response.statusCode == 200) {
    //  List<dynamic> articlesData = json.decode(response.body)['articles'];
    //  return articlesData.map((item) => Article.fromJson(item)).toList();
    //} else {
    //  throw Exception('Failed to load post');
    //}
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<CountriesData> sendCountriesDataRequest(int page) async {
    try {
      String url = Uri.encodeFull(
          'https://api.worldbank.org/v2/country?page=$page&format=json');
      http.Response response = await http.get(url);
      return CountriesData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return CountriesData.withError(
            'Please check your internet connection.');
      } else {
        print(e.toString());
        return CountriesData.withError('Something went wrong.');
      }
    }
  }

  List<dynamic> listItemsGetter(CountriesData countriesData) {
    List<String> list = [];
    countriesData.countries.forEach((value) {
      list.add(value['name']);
    });
    return list;
  }

  Widget listItemBuilder(value, int index) {
    // return ListTile(
    //   leading: Text(index.toString()),
    //   title: Text(value),
    // );
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => NewsDetailPage(article: article)),
      //   );
      // },
      onTap: () {
        Navigator.push(context, SlideTopRoute(page: NewsDetailPage(article: value)));
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              color: AppTheme.priBgColor,
              // decoration: BoxDecoration(boxShadow: [
              //   BoxShadow(
              //       color: Colors.black.withOpacity(0.3), blurRadius: 1)
              // ]),
              child: NewsListTile(
                  article: value),
            ),
          ),
          // snapshot.data.length != index+1?
          // SizedBox(
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          //       child: Container(
          //         decoration: BoxDecoration(
          //             border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
          //         ),
          //       ),
          //     )
          // ):SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      // child: CircularProgressIndicator(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
            child: CupertinoActivityIndicator(radius: 12,)),
      ),
    );
  }

  Widget errorWidgetMaker(CountriesData countriesData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(countriesData.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text('Retry'),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(CountriesData countriesData) {
    return Center(
      child: Text('No countries in the list'),
    );
  }

  int totalPagesGetter(CountriesData countriesData) {
    return countriesData.total;
  }

  bool pageErrorChecker(CountriesData countriesData) {
    return countriesData.statusCode != 200;
  }

  @override
  Widget build(BuildContext context) {
    String version = "200";
    String ios_version = "220";
    // WillPopScope handle android back btn
    return Scaffold(
      body: Stack(
        children: [
          // ChangeNotifierProvider(
          //   create: (context) => menuController,
          //   child: ZoomScaffold(
          //     menuScreen: MenuScreen(),
          //     contentScreen: Layout(
          //         contentBuilder: (cc) => Container(
          //           color: Colors.grey[200],
          //           child: Container(
          //             color: Colors.grey[200],
          //           ),
          //         )),
          //   ),
          // ),
          WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
              !await tabs[currentTab].key.currentState.maybePop();
              if (isFirstRouteInCurrentTab) {
                // if not on the 'main' tab
                if (currentTab != 0) {
                  // select 'main' tab
                  _selectTab(0);
                  // back button handled by app
                  return false;
                }
              }
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },
            // this is the base scaffold
            // don't put appbar in here otherwise you might end up
            // with multiple appbars on one screen
            // eventually breaking the app


            child: Scaffold(
                backgroundColor: AppTheme.secBgColor,
                // indexed stack shows only one child
                body: Stack(
                  children: [
                    langChanging?Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                          child: CupertinoActivityIndicator(radius: 12,)),
                    ):Container(),
                    IndexedStack(
                      index: currentTab,
                      children: tabs.map((e) => e.page).toList(),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 2.0),
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       child: AdmobBanner(
                    //         adUnitId: getBannerAdUnitId(),
                    //         adSize: AdmobBannerSize.SMART_BANNER(context),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                // Bottom navigation
                bottomNavigationBar: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigation(
                    onSelectTab: _selectTab,
                    tabs: tabs,
                  ),
                )
            ),
          ),
          Visibility(
            visible: tthighLight,
            child: GestureDetector(
              onTap: () {
                if(ttPressC == 0) {
                  setState(() {
                    langTt = false;
                    pressTt = true;
                  });
                } else if(ttPressC == 1){
                  setState(() {
                    tthighLight = false;
                  });
                }
                ttPressC+=1;
              },
              child: Stack(
                children: [
                  Visibility(
                    visible: langTt,
                    child: Container(
                      color: Colors.black.withOpacity(0.85),
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
                                      'Change Burmese(မြန်မာ)\nlanguage here',
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
                  ),
                  Visibility(
                    visible: pressTt,
                    child: Container(
                      color: Colors.black.withOpacity(0.85),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border(
                                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                            top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                            left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                            right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                          )
                                      ),
                                      child: Image(
                                        image: AssetImage('assets/images/system/ahri.jpeg'),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Icon(
                                      RiftPlusIcons.mage,
                                      size: 50,
                                      color: AppTheme.activeIcon,
                                    ),
                                    SizedBox(width: 22,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border(
                                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                            top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                            left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                            right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                          )
                                      ),
                                      child: Image(
                                        image: AssetImage('assets/images/system/ahri_4.png'),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Info Tips',
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
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Long press icons or images\nto see more info',
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // SafeArea(
          //   top: true,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top:55.0, left: 0.0),
          //     child: Showcase.withWidget(
          //       key: _globTwo,
          //       height: 50,
          //       width: MediaQuery.of(context).size.width,
          //       container: Container(
          //         width: MediaQuery.of(context).size.width,
          //         child: Column(
          //           crossAxisAlignment:
          //           CrossAxisAlignment.start,
          //           children: <Widget>[
          //             Container(
          //               child: Padding(
          //                 padding: const EdgeInsets.only(top: 20),
          //                 child: Text(
          //                   'Info Tips',
          //                   textScaleFactor: 1,
          //                   style: TextStyle(
          //                     fontFamily: 'spiegel',
          //                     fontSize: 20,
          //                     color: AppTheme.blueAccent,
          //                     letterSpacing: 0.3,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Text(
          //               'Long press icons or profiles\nto see info',
          //               textScaleFactor: 1,
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 16,
          //                   height: 1.5,
          //               ),
          //               textAlign: TextAlign.left,
          //             )
          //           ],
          //         ),
          //       ),
          //       child: Container(
          //         width: MediaQuery.of(context).size.width,
          //         height: 50,
          //         color: Colors.transparent,
          //       ),
          //     ),
          //   )
          // ),
          FutureBuilder<Infos>(
            future: infos,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                if(int.parse(Platform.isAndroid? snapshot.data.app_update: snapshot.data.ios_app_update) > int.parse(Platform.isAndroid? version: ios_version) && snapshot.data.is_skipable == 'true' && !later) {
                  return Container(
                    color: Colors.black.withOpacity(0.5),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppTheme.borderColor),
                          borderRadius: BorderRadius.all(Radius.circular(0.0))),
                      backgroundColor: AppTheme.secBgColor,
                      title: Text(
                        'UPDATE AVAILABLE',
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'beaufortforlol',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0.3,
                          color: AppTheme.labTextActive,
                        ),

                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              snapshot.data.whats_new,
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontFamily: 'spiegel',
                                fontSize: 16,
                                color: AppTheme
                                    .labTextActive2,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25,),

                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                RaisedGradientButton(
                                    child: Text(
                                      'UPDATE',
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
                                      // LaunchReview.launch(androidAppId: snapshot.data.android_url,
                                      //     iOSAppId: snapshot.data.ios_url);
                                      _launchURL(Platform.isAndroid? snapshot.data.android_url2: snapshot.data.ios_url2);
                                    }
                                ),
                                // Container(
                                //
                                //   decoration: BoxDecoration(
                                //     gradient: new LinearGradient(
                                //         colors: [
                                //           const Color(0xFF4B3F2A),
                                //           const Color(0xFF13191C),
                                //         ],
                                //         begin: const FractionalOffset(0.0, 1.0),
                                //         end: const FractionalOffset(0.0, 0.0),
                                //         stops: [0.0, 1.0],
                                //         tileMode: TileMode.clamp),
                                //     border: Border(
                                //       bottom: BorderSide(color: AppTheme.borderColor, width: 1),
                                //       top: BorderSide(color: AppTheme.borderColor, width: 1),
                                //       left: BorderSide(color: AppTheme.borderColor, width: 1),
                                //       right: BorderSide(color: AppTheme.borderColor, width: 1),
                                //     ),
                                //   ),
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       LaunchReview.launch(androidAppId: "com.ethereals.riftplus02",
                                //           iOSAppId: "585027354");
                                //     },
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(left:25.0, right: 25.0, top:8.0, bottom: 10.0),
                                //       child: (
                                //           Text(
                                //             'UPDATE',
                                //             style: TextStyle(
                                //               fontFamily: 'beaufortforlol',
                                //               fontWeight: FontWeight.w700,
                                //               fontSize: 15,
                                //               letterSpacing: 0.5,
                                //               color: AppTheme.labTextActive,
                                //             ),
                                //           )
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                    child: SizedBox()
                                ),
                              ],
                            ),
                            FlatButton(
                              color: Colors.transparent,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.transparent,
                              onPressed: () {
                                /*...*/
                                setState(() {
                                  later = true;
                                });
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Remind me later',
                                      style: TextStyle(
                                        fontFamily: 'spiegel',
                                        fontSize: 16,
                                        color: AppTheme
                                            .labTextActive,
                                        letterSpacing: 0.3,
                                      ),
                                    ),

                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Transform.rotate(
                                          angle: 180 * 3.14 / 180,
                                          child: Icon(
                                            RiftPlusIcons.back,
                                            color: AppTheme.borderColor,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      // actions: <Widget>[
                      //
                      //   SizedBox(
                      //     child: Container(
                      //       color: Colors.white,
                      //       child: Text('gg'),
                      //     ),
                      //   )
                      //
                      // ],
                    ),
                  );
                } else if (int.parse(Platform.isAndroid? snapshot.data.app_update: snapshot.data.ios_app_update) > int.parse(Platform.isAndroid? version: ios_version) && snapshot.data.is_skipable == 'false') {
                  return Container(
                    color: Colors.black.withOpacity(0.5),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppTheme.borderColor),
                          borderRadius: BorderRadius.all(Radius.circular(0.0))),
                      backgroundColor: AppTheme.secBgColor,
                      title: Text(
                        'UPDATE AVAILABLE',
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'beaufortforlol',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0.3,
                          color: AppTheme.labTextActive,
                        ),

                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              snapshot.data.whats_new,
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontFamily: 'spiegel',
                                fontSize: 16,
                                color: AppTheme
                                    .labTextActive2,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25,),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(),
                                ),
                                RaisedGradientButton(
                                    child: Text(
                                      'UPDATE',
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
                                      _launchURL(Platform.isAndroid? snapshot.data.android_url2: snapshot.data.ios_url2);
                                    }
                                ),
                                Expanded(
                                    child: SizedBox()
                                ),
                              ],
                            ),
                            SizedBox(height:
                              10,)
                          ],
                        ),
                      ),
                      // actions: <Widget>[
                      //
                      //   SizedBox(
                      //     child: Container(
                      //       color: Colors.white,
                      //       child: Text('gg'),
                      //     ),
                      //   )
                      //
                      // ],
                    ),
                  );
                }
              }
              return Container(width: 0,height: 0,);
            }
          ),
          _connectionStatus == 'ConnectivityResult.none' ? Container(
            color: Colors.black.withOpacity(0.5),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              backgroundColor: AppTheme.secBgColor,
              title: Text(
                'NO INTERNET',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'beaufortforlol',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.3,
                  color: AppTheme.labTextActive,
                ),

              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Please connect to the internet provider',
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontFamily: 'spiegel',
                        fontSize: 16,
                        color: AppTheme
                            .labTextActive2,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25,),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        RaisedGradientButton(
                            child: Text(
                              'OK',
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
                              setState(() {
                                _connectionStatus = 'ok';
                              });
                            }
                        ),
                        Expanded(
                            child: SizedBox()
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // actions: <Widget>[
              //
              //   SizedBox(
              //     child: Container(
              //       color: Colors.white,
              //       child: Text('gg'),
              //     ),
              //   )
              //
              // ],
            ),
          ) : Container(),

        ],
      ),
    );




  }




  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      decoration: BoxDecoration(gradient: gradient,
          border: Border(
            bottom: BorderSide(color: AppTheme.borderColor, width: 1),
            top: BorderSide(color: AppTheme.borderColor, width: 1),
            left: BorderSide(color: AppTheme.borderColor, width: 1),
            right: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 8.0, bottom: 10.0),
              child: Center(
                child: child,
              ),
            )),
      ),
    );
  }
}


class CountriesData {
  List<dynamic> countries;
  int statusCode;
  String errorMessage;
  int total;
  int nItems;

  CountriesData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    List jsonData = json.decode(response.body);
    countries = jsonData[1];
    total = jsonData[0]['total'];
    nItems = countries.length;
  }

  CountriesData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;

  @override
  bool get opaque => false;
  ScaleRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}


class FadeRoute extends PageRouteBuilder {
  final Widget page;
  @override
  bool get opaque => false;
  FadeRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 150),
  );
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;
  SizeRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ),
  );
}


class SlideTopRoute extends PageRouteBuilder {
  final Widget page;
  @override
  bool get opaque => false;
  SlideTopRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}