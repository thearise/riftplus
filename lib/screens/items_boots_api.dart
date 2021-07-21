import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
// import 'package:riftplus02/screens/screen_one_route/champion_route.dart';
import 'package:riftplus02/screens/screen_one_route/itemsdetail_route.dart';
import 'package:riftplus02/screens/titleView.dart';
// import 'package:riftplus02/views/championsbarview.dart';
import 'package:http/http.dart' as http;

import '../apptheme.dart';
import '../fintness_app_theme.dart';
// import 'homescreen.dart';
import 'screen_one_route/seeall_route.dart';

class ItemsBootsAPI extends StatefulWidget {
  const ItemsBootsAPI({Key key}) : super(key: key);

  @override
  _ItemsBootsAPIState createState() => _ItemsBootsAPIState();
}


class _ItemsBootsAPIState extends State<ItemsBootsAPI>  with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<ItemsBootsAPI>{
  @override
  bool get wantKeepAlive => true;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  bool multiple = true;
  List<Widget> listViews = <Widget>[];
  Future<List<Item>> itemBaseds;
  Future<List<Item>> itemMidtiers;
  Future<List<Item>> itemUpgradeds;
  bool itemBasedsLoaded = false;
  bool itemMidtiersLoaded = false;
  bool itemUpgradedsLoaded = false;
  String itemResponse;
  Dio dio;




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
    // championsTabDataList.forEach((ChampionsTabData tab) {
    //   tab.isSelected = false;
    // });
    // championsTabDataList[0].isSelected = true;
    super.initState();
    itemBaseds = fetchItemsBased();
    itemMidtiers = fetchItemsMidtier();
    itemUpgradeds = fetchItemsUpgraded();
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<List<Item>> fetchItemsBased() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllBootslItems.php');
    if (response.statusCode == 200) {
      itemResponse = response.toString();
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject["based"];
      var itemBaseds = list.map((itemBased) => Item.fromJson(itemBased)).toList();
      setState(() {
        itemBasedsLoaded = true;
      });
      return itemBaseds;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Item>> fetchItemsMidtier() async {
    final response =
    await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllBootslItems.php');
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.body);
      Iterable list = jsonObject["advance"];
      var itemMidtiers = list.map((itemMidtier) => Item.fromJson(itemMidtier)).toList();
      setState(() {
        itemMidtiersLoaded = true;
      });
      return itemMidtiers;

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<Item>> fetchItemsUpgraded() async {
    final response =
    await http.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllBootslItems.php');
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.body);
      Iterable list = jsonObject["finished"];
      var itemUpgraded = list.map((itemUpgraded) => Item.fromJson(itemUpgraded)).toList();
      setState(() {
        itemUpgradedsLoaded = true;
      });
      return itemUpgraded;

    } else {
      throw Exception('Failed to load album');
    }
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.priBgColor,
//       child: ListView.builder(
// //            padding: EdgeInsets.only(
// //              top: AppBar().preferredSize.height +
// //                  MediaQuery.of(context).padding.top +
// //                  24,
// //              bottom: 62 + MediaQuery.of(context).padding.bottom,
// //            ),
//         itemCount: listViews.length,
//         scrollDirection: Axis.vertical,
//         itemBuilder: (BuildContext context, int index) {
//           return listViews[index];
//         },
//       ),
      child: Stack(
        children: [
          ListView(
            children: [
              FutureBuilder<List<Item>>(
                //stream: Firestore.instance.collection('items').document('physical').collection('basic').snapshots(),
                  future: itemBaseds,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 3.8;
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'BASIC ITEMS',
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
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => SeeAllRoute(item: itemResponse, id: 'based', name:'BASIC ITEMS'))
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'See all',
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              letterSpacing: 0.3,
                                              color: AppTheme.borderColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                              height: containerHeight,
                              child: GridView.builder(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 15),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  //return Text("${snapshot.data[index].name}");
                                  return Tooltip(
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
                                                          builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_name2, price:snapshot.data[index].item_price, type: snapshot.data[index].item_type, video: snapshot.data[index].item_video))
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
                                //children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 20.0,
                                  crossAxisSpacing: 20.0,
                                  childAspectRatio: 1,
                                ),
                              )
                          )
                        ],
                      );
                    }
                    return Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                        child: CupertinoActivityIndicator(radius: 12,));
                  }
              ),
              SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                      ),
                    ),
                  )
              ),
              FutureBuilder<List<Item>>(
                //stream: Firestore.instance.collection('items').document('physical').collection('basic').snapshots(),
                  future: itemMidtiers,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 3.7;
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'UPGRADED ITEMS',
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
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => SeeAllRoute(item: itemResponse, id: 'advance', name:'UPGRADED ITEMS'))
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'See all',
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              letterSpacing: 0.3,
                                              color: AppTheme.borderColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                              height: containerHeight-2.0,
                              child: GridView.builder(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 15),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  //return Text("${snapshot.data[index].name}");
                                  return Tooltip(
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
                                                          builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_name2, price:snapshot.data[index].item_price, type: snapshot.data[index].item_type, video: snapshot.data[index].item_video))
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
                                //children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 20.0,
                                  crossAxisSpacing: 20.0,
                                  childAspectRatio: 1,
                                ),
                              )
                          )
                        ],
                      );
                    }
                    return Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                        child: CupertinoActivityIndicator(radius: 12,));
                  }
              ),

              SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                      ),
                    ),
                  )
              ),
              FutureBuilder<List<Item>>(
                //stream: Firestore.instance.collection('items').document('physical').collection('basic').snapshots(),
                  future: itemUpgradeds,
                  builder: (context, snapshot) {
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double containerHeight = size.width / 2;
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'ENCHANTMENT ITEMS',
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
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => SeeAllRoute(item: itemResponse, id: 'finished', name:'ENCHANTMENT ITEMS'))
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'See all',
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontFamily: 'spiegel',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              letterSpacing: 0.3,
                                              color: AppTheme.borderColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                              height: containerHeight,
                              child: GridView.builder(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 15),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  //return Text("${snapshot.data[index].name}");
                                  return Tooltip(
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
                                                          builder: (context) => ItemsDetailRoute(id: snapshot.data[index].id,image: snapshot.data[index].item_image, name: snapshot.data[index].item_name, name2: snapshot.data[index].item_name2, price:snapshot.data[index].item_price, type: snapshot.data[index].item_type, video: snapshot.data[index].item_video))
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
                                //children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20.0,
                                  crossAxisSpacing: 20.0,
                                  childAspectRatio: 1,
                                ),
                              )
                          ),
                          SizedBox(height: 60,)
                        ],
                      );
                    }
                    return Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                        child: CupertinoActivityIndicator(radius: 12,));
                  }
              ),
            ],
          ),
          itemBasedsLoaded && itemMidtiersLoaded && itemUpgradedsLoaded ? Container():Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: AppTheme.priBgColor,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                        child: CupertinoActivityIndicator(radius: 12,)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
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
          )
        ],
      ),
    );
  }

  Widget allChampions(BuildContext context, snapshot) {
    print(snapshot);
    return SizedBox();
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
  }

}

// class ChampionsListView extends StatelessWidget {
//   const ChampionsListView(
//       {Key key,
//         this.listData,
//         this.callBack,})
//       : super(key: key);
//
//   final ChampionsList listData;
//   final VoidCallback callBack;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.5,
//       child: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//         child: Stack(
//           alignment: AlignmentDirectional.center,
//           children: <Widget>[
//             Image.asset(
//               listData.imagePath,
//               fit: BoxFit.cover,
//             ),
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 splashColor: Colors.grey.withOpacity(0.2),
//                 borderRadius:
//                 const BorderRadius.all(Radius.circular(4.0)),
//                 onTap: () {
//                   callBack();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
//
//
// }

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

class ItemMidtier {
  final String id;
  final String item_type;
  final String item_lv;
  final String item_name;
  final String item_price;
  final String item_image;
  final String item_video;

  ItemMidtier({this.id, this.item_type, this.item_lv, this.item_name, this.item_price, this.item_image, this.item_video});

  factory ItemMidtier.fromJson(Map<String, dynamic> json){
    return ItemMidtier(
        id: json['id'],
        item_type: json['item_type'],
        item_lv: json['item_lv'],
        item_name: json['item_name'],
        item_price: json['item_price'],
        item_image: json['item_image'],
        item_video: json['item_video'],
    );
  }
}



class ItemUpgraded {
  final String id;
  final String item_type;
  final String item_lv;
  final String item_name;
  final String item_price;
  final String item_image;
  final String item_video;

  ItemUpgraded({this.id, this.item_type, this.item_lv, this.item_name, this.item_price, this.item_image, this.item_video});

  factory ItemUpgraded.fromJson(Map<String, dynamic> json){
    return ItemUpgraded(
        id: json['id'],
        item_type: json['item_type'],
        item_lv: json['item_lv'],
        item_name: json['item_name'],
        item_price: json['item_price'],
        item_image: json['item_image'],
        item_video: json['item_video']
    );
  }
}