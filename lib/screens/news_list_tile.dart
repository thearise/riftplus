import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../apptheme.dart';
import 'article_image.dart';

import 'article.dart';

class NewsListTile extends StatefulWidget {
  final String article;
  final Color color;

  NewsListTile({this.article, this.color = Colors.indigoAccent});

  @override
  _NewsListTileState createState() => _NewsListTileState();
}

class _NewsListTileState extends State<NewsListTile>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ResponsiveGridRow(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveGridCol(
              xs: 6,
              md: 6,
              // child: Container()
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:8, top:8.0, right: 10.0, bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      child: AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 300),
                        child: ArticleImage(article: parseData(widget.article, 'image')),
                        // child: ArticleImage(article: widget.article),
                      ),
                    ),
                  ),


                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  //     padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  //     decoration: BoxDecoration(
                  //       color: widget.color.withOpacity(.8),
                  //       borderRadius: BorderRadius.all(Radius.circular(20)),
                  //     ),
                  //     child: Text(
                  //       widget.article.source ?? '',
                  //       maxLines: 1,
                  //       textAlign: TextAlign.end,
                  //       style: TextStyle(
                  //           fontFamily: 'Times New Roman',
                  //           color: Colors.white.withOpacity(.8),
                  //           fontSize: 14.0),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
          ),
          ResponsiveGridCol(
            xs: 6,
            md: 6,
            child: Container(
              height: 120,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0, bottom: 4.0, left: 5.0, right: 5.0),
                      child: Text(
                        parseData(widget.article, 'title'),
                        textScaleFactor: 1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'beaufortforlol',
                          fontSize: 16,
                          color: AppTheme.lightText,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w700,

                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                   Expanded(
                       child: Padding(
                         padding: const EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                         child: Align(
                           alignment: Alignment.topLeft,
                           child: Text(widget.article,
                             textAlign: TextAlign.left,
                             style: TextStyle(
                               fontSize: 13,
                               fontFamily: 'spiegel',
                               color: AppTheme.labTextActive,
                             ),
                             overflow: TextOverflow.ellipsis,
                             maxLines: 2,
                   ),
                         ),
                       ))

                ],
              ),
            ),
          )
          // Stack(
          //   fit: StackFit.loose,
          //   alignment: Alignment.bottomLeft,
          //   children: <Widget>[
          //     AnimatedSize(
          //       vsync: this,
          //       duration: Duration(milliseconds: 300),
          //       child: ArticleImage(article: widget.article),
          //     ),
          //     // Positioned(
          //     //   top: 0,
          //     //   right: 0,
          //     //   child: Container(
          //     //     margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          //     //     padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          //     //     decoration: BoxDecoration(
          //     //       color: widget.color.withOpacity(.8),
          //     //       borderRadius: BorderRadius.all(Radius.circular(20)),
          //     //     ),
          //     //     child: Text(
          //     //       widget.article.source ?? '',
          //     //       maxLines: 1,
          //     //       textAlign: TextAlign.end,
          //     //       style: TextStyle(
          //     //           fontFamily: 'Times New Roman',
          //     //           color: Colors.white.withOpacity(.8),
          //     //           fontSize: 14.0),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),



          // Container(
          //   alignment: Alignment.bottomLeft,
          //   // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          //   // decoration: BoxDecoration(
          //   //   color: Colors.black.withOpacity(.5),
          //   // ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       // Text(
          //       //   widget.article.title ?? '',
          //       //   style: TextStyle(color: Colors.white, fontSize: 15.0),
          //       //
          //       // ),
          //       Text(widget.article.author ?? '',
          //           style: TextStyle(
          //               color: Colors.white.withOpacity(0.6), fontSize: 14.0)),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  String parseData(value, type) {
    if (type == 'image') {
      return value.split('~')[0];
    } else if (type == 'title') {
      return value.split('~')[1];
    }
  }
}
