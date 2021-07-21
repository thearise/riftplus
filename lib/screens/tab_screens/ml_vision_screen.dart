
import 'dart:convert';

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
// import 'package:riftplus02/screens/screen_one_route/champion_route.dart';
import 'package:riftplus02/screens/screen_one_route/itemsdetail_route.dart';
import 'package:riftplus02/screens/titleView.dart';
import 'package:riftplus02/screens/utilites/read_more_txt.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:riftplus02/views/championsbarview.dart';

import '../../apptheme.dart';
import 'ml_buffs/vision_wards.dart';


class Infos {
  final String intro;
  final String wards_n_lens;

  final String intro_en;
  final String wards_n_lens_en;

  Infos({
    this.intro,
    this.wards_n_lens,

    this.intro_en,
    this.wards_n_lens_en,
  });

  factory Infos.fromJson(Map<String, dynamic> json){
    return Infos(
      intro: json['intro'],
      wards_n_lens: json['wards_n_lens'],

      intro_en: json['intro_en'],
      wards_n_lens_en: json['wards_n_lens_en'],
    );
  }
}

class MLVisionScreen extends StatefulWidget {
  const MLVisionScreen({Key key}) : super(key: key);

  @override
  _MLVisionScreenState createState() => _MLVisionScreenState();
}

class _MLVisionScreenState extends State<MLVisionScreen>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MLVisionScreen>{
  @override
  bool get wantKeepAlive => true;
  // List<ChampionsList> championsList = ChampionsList.championsList;
  // List<ChampionsTabData> championsTabDataList = ChampionsTabData.championsTabDataList;
  bool multiple = true;
  List<Widget> listViews = <Widget>[];

  Future<Infos> infos;
  bool infosLoaded = false;
  Dio dio;


  Future<Infos> fetchVisionInfos() async {
    final response =
    await dio.get('https://hninsunyein.me/rift_plus/rift_plus/api/getVisionInfos.php');

    // Use the compute function to run parsePhotos in a separate isolate.
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Future.delayed(const Duration(milliseconds: 2500), () {

// Here you can write your code

        setState(() {
          infosLoaded = true;
        });

      });
      return Infos.fromJson(jsonDecode(response.toString()));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


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
    super.initState();
    infos = fetchVisionInfos();
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
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
          !infosLoaded?Stack(
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
            future: infos,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return StreamBuilder(
                  stream: _getLanguageStream3,
                  builder: (context, snapshot2) {
                    return infosLoaded?ListView(
                      children: [
                        Image(image: AssetImage('assets/images/system/vision-illu.png')),
                        TitleView(
                          titleTxt: 'VISION TO WINNING',
                          subTxt: '',
                          id: '',
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 5.0),
                                child: ReadMoreText(
                                  snapshot2.data == 1 ? snapshot.data.intro: snapshot.data.intro_en,
                                  trimLines: 2,
                                  textScaleFactor: 1,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'spiegel',
                                      color: AppTheme.labTextActive,
                                      height: 1.3
                                  ),
                                  colorClickableText: AppTheme.borderColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '... more',
                                  trimExpandedText: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => VisionWards())
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppTheme.secBgColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                      child: Image(image: AssetImage('assets/images/system/ability-wards.png')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                                      child: Text(
                                        'Wards & Sweeping Lens',
                                        textScaleFactor: 1,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'spiegel',
                                          fontSize: 18.5,
                                          color: AppTheme.lightText,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top:0.0, bottom: 20.0),
                                      child: Text(
                                        snapshot2.data == 1 ? snapshot.data.wards_n_lens: snapshot.data.wards_n_lens_en,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1,
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
                                  ],
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ):Container();
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Stream<int> _getLanguageStream3 = (() async* {
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