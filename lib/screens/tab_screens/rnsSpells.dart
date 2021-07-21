import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:riftplus02/interceptor/dio_connectivity_request_retrier.dart';
import 'package:riftplus02/interceptor/retry_interceptor.dart';
// import 'package:riftplus02/models/championslist.dart';
// import 'package:riftplus02/models/championstabdata.dart';
import 'package:riftplus02/screens/screen_one_route/baron_lane.dart';
// import 'package:riftplus02/screens/screen_one_route/champion_route.dart';
import 'package:riftplus02/screens/screen_one_route/dragon_lane.dart';
import 'package:riftplus02/screens/screen_one_route/itemsdetail_route.dart';
import 'package:riftplus02/screens/screen_one_route/jungle-lane.dart';
import 'package:riftplus02/screens/screen_one_route/mid-lane.dart';
import 'package:riftplus02/screens/screen_one_route/spellsdetail_route.dart';
import 'package:riftplus02/screens/titleView.dart';
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:riftplus02/views/championsbarview.dart';

import '../../apptheme.dart';

class Spell {
  final String id;
  final String spell_name;
  final String spell_cooldown;
  final String spell_sugg;
  final String spell_desc;
  final String spell_desc_en;
  final String spell_video;
  final String spell_image;
  Spell({this.id, this.spell_name, this.spell_cooldown, this.spell_sugg, this.spell_desc, this.spell_desc_en, this.spell_image, this.spell_video});

  factory Spell.fromJson(Map<String, dynamic> json){
    return Spell(
        id: json['id'],
        spell_name: json['spell_name'],
        spell_cooldown: json['spell_cooldown'],
        spell_sugg: json['spell_sugg'],
        spell_desc: json['spell_desc'],
        spell_desc_en: json['spell_desc_en'],
        spell_image: json['spell_image'],
        spell_video: json['spell_video']
    );
  }
}

class RNSSpells extends StatefulWidget {
  const RNSSpells({Key key}) : super(key: key);

  @override
  _RNSSpellsState createState() => _RNSSpellsState();
}

class _RNSSpellsState extends State<RNSSpells>  with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<RNSSpells>{
  @override
  bool get wantKeepAlive => true;
  Dio dio;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  bool multiple = true;
  List<Widget> listViews = <Widget>[];
  Future<List<Spell>> spells;

  bool spellsLoaded = false;

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
    addAllListData();
    super.initState();
    spells = fetchSpells();
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<List<Spell>> fetchSpells() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getAllSpells.php');
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject = json.decode(response.toString());
      Iterable list = jsonObject["flore"];
      var sps = list.map((spells) => Spell.fromJson(spells)).toList();

      Future.delayed(const Duration(milliseconds: 2500), () {

        setState(() {
          spellsLoaded = true;
        });

      });
      return sps;

    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.priBgColor,
        child: Stack(
          children: [
            !spellsLoaded?Stack(
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
            ):Container(),
            FutureBuilder(
              //stream: Firestore.instance.collection('spells').snapshots(),f
              future: spells,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder(
                    stream: _getLanguageStream2,
                    builder: (context, snapshot2) {
                      return spellsLoaded?ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:20,right: 20, top: 5, bottom: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => SpellsDetailRoute(id: snapshot.data[index].id,name: snapshot.data[index].spell_name, cooldown: snapshot.data[index].spell_cooldown, desc: snapshot2.data == 1 ? snapshot.data[index].spell_desc: snapshot.data[index].spell_desc_en, sugg: snapshot.data[index].spell_sugg, image: snapshot.data[index].spell_image, video: snapshot.data[index].spell_video))
                                        );
                                      },
                                      child: Container(
                                        //color: AppTheme.secBgColor,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ResponsiveGridRow(children: [
                                          ResponsiveGridCol(
                                              xs: 3,
                                              md: 3,
                                              child: Container(
                                                  height: 110,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 20.0, bottom: 0.0),
                                                    child: Center(
//                      decoration: BoxDecoration(
//                          border: Border(
//                            bottom: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            top: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            left: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                            right: BorderSide(color: AppTheme.borderColor, width: 1.5),
//                          )
//                      ),
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                          child: CachedNetworkImage(
                                                              imageUrl: snapshot.data[index].spell_image,
                                                              placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                                              fadeInDuration: Duration(milliseconds: 100),
                                                              fadeOutDuration: Duration(milliseconds: 10),
                                                              fadeInCurve: Curves.bounceIn
                                                          ),
                                                      ),
                                                    ),
                                                  )
                                              )
                                          ),
                                          ResponsiveGridCol(
                                            xs: 9,
                                            md: 9,
                                            child: Container(
                                              height: 110,
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
                                                      child: Text(
                                                        snapshot.data[index].spell_name,
                                                        textScaleFactor: 1,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily: 'spiegel',
                                                          fontSize: 18,
                                                          color: AppTheme.lightText,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
//                  Expanded(
//                      child: Padding(
//                        padding: const EdgeInsets.all(15.0),
//                        child: Text("This is a sample long text line we are using in our example. This is a sample long text line we are using in our example. This is a sample long text line we are using in our example.",
//                          textAlign: TextAlign.left,
//                          style: TextStyle(
//                            fontFamily: 'spiegel',
//                            color: AppTheme.labTextActive,
//                          ),
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 2,
//                  ),
//                      ))
                                                  Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:5.0, bottom: 0.0),
                                                      child: Text(
                                                        snapshot2.data == 1 ? snapshot.data[index].spell_desc: snapshot.data[index].spell_desc_en,
                                                        // snapshot.data[index].spell_desc,
                                                        textScaleFactor: 1,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          height: 1.3,
                                                          fontSize: 14,
                                                          fontFamily: 'spiegel',
                                                          color: AppTheme.labTextActive,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.bottomLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 0.0, right: 20.0, top:0.0, bottom: 0.0),
                                                          child: Text(
                                                            snapshot.data[index].spell_cooldown,
                                                            textScaleFactor: 1,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              height: 1.2,
                                                              fontSize: 14,
                                                              fontFamily: 'spiegel',
                                                              color: AppTheme.activeIcon,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                  snapshot.data.length != index+1?
                                  SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
                                          ),
                                        ),
                                      )
                                  ):SizedBox(height: 60,)
                                ],
                              );
                            }
                    ):Container();

                    },
                  );
                }
                return Container();
              },
            ),
          ],
        )
    );
  }

  Stream<int> _getLanguageStream2 = (() async* {
    //
    // yield 1;
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      // localLang = _getLanguage();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var index = prefs.getString('language');
      if(index.toString().contains('EN')) {
        yield 0;
      } else if (index.toString().contains('MM')){
        yield 1;
      }
      //yield random.nextInt(10);
    }
  })();

  Widget allChampions(BuildContext context, snapshot) {
    print(snapshot);
    return SizedBox();
//    return ListView(
//      padding: const EdgeInsets.only(top: 20.0),
//      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//    );
  }


  void addAllListData() {

//    listViews.add(
//        SizedBox(
//            child: Padding(
//              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//              child: Container(
//                decoration: BoxDecoration(
//                    border: Border(bottom: BorderSide(color: AppTheme.lineColor, width: 1.0))
//                ),
//              ),
//            )
//        )
//    );



//    listViews.add(
//      TitleView(
//        titleTxt: 'MID TIER ITEMS',
//        subTxt: 'See all',
//      ),
//    );
//    listViews.add(
//        StreamBuilder<QuerySnapshot>(
//            stream: Firestore.instance.collection('champions_type').snapshots(),
//            builder: (context, snapshot) {
//              var size = MediaQuery.of(context).size;
//
//              /*24 is for notification bar on Android*/
//              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//              final double containerHeight = size.width / 2;
//              if (!snapshot.hasData) return LinearProgressIndicator();
//              return Container(
//                  height: containerHeight,
//                  child: _buildList(context, snapshot.data.documents)
//              );
//            }
//        )
//    );

//
//
//    listViews.add(
//      TitleView(
//        titleTxt: 'UPGRADED ITEMS',
//        subTxt: 'See all',
//      ),
//    );
//    listViews.add(
//        StreamBuilder<QuerySnapshot>(
//            stream: Firestore.instance.collection('champions_type').snapshots(),
//            builder: (context, snapshot) {
//              var size = MediaQuery.of(context).size;
//
//              /*24 is for notification bar on Android*/
//              //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
//              final double containerHeight = size.width / 2;
//              if (!snapshot.hasData) return LinearProgressIndicator();
//              return Container(
//                  height: containerHeight,
//                  child: _buildList(context, snapshot.data.documents)
//              );
//            }
//        )
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
//   // final ChampionsList listData;
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


class ExpandableText extends StatefulWidget {
  const ExpandableText(
      this.text, {
        Key key,
        this.trimLines = 2,
      })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... read more" : " read less",
        style: TextStyle(
          color: colorClickableText,
          fontFamily: 'spiegel',
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: TextStyle(
              fontFamily: 'spiegel',
              color: AppTheme.labTextActive,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}




