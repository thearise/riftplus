import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:riftplus02/icon_fonts/riftplus-icons.dart';
import 'package:riftplus02/screens/article.dart';
import 'package:riftplus02/screens/article_image.dart';
import 'package:riftplus02/screens/logo.dart';

import '../apptheme.dart';

class NewsDetailPage extends StatelessWidget {
  final String article;
  NewsDetailPage({this.article});
  Timer _timer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0, bottom: 0.0, left: 0.0, right: 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        child: Container(
          color: AppTheme.priBgColor,
          // decoration: BoxDecoration(
          //   color: AppTheme.priBgColor,
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: Stack(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ArticleImage(article: parseData(article, 'image')),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                        decoration: BoxDecoration(
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              article,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'article',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'article',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6), fontSize: 14.0),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'article',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: RaisedButton(
                                elevation: 0,
                                child: Text(
                                  'Full article',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.indigoAccent,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //appbar
              Container(

                child: SizedBox(
                  height: AppBar().preferredSize.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15),
                        child: Container(
                          width: 35,
                          height: 35,
                          color: Colors.transparent,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius:
                              BorderRadius.circular(AppBar().preferredSize.height),
                              child: RaisedGradientButton(
                                  child: Icon(
                                    RiftPlusIcons.close,
                                    color: AppTheme.activeIcon,
                                    size: 23,
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[Color(0xFF1D232B), Color(0xFF1D232B)],
                                    begin: const FractionalOffset(0.0, 1.0),
                                    end: const FractionalOffset(0.0, 0.0),
                                  ),
                              ),
                              // child: Icon(
                              //   RiftPlusIcons.close,
                              //   color: AppTheme.activeIcon,
                              //   size: 22,
                              // ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 15),
                        child: Container(
                          width: 35,
                          height: 35,
                          color: Colors.transparent,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius:
                              BorderRadius.circular(AppBar().preferredSize.height),
                              child: RaisedGradientButton(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Icon(
                                    RiftPlusIcons.save,
                                    color: AppTheme.activeIcon,
                                    size: 25,
                                  ),
                                ),
                                gradient: LinearGradient(
                                  colors: <Color>[Color(0xFF1D232B), Color(0xFF1D232B)],
                                  begin: const FractionalOffset(0.0, 1.0),
                                  end: const FractionalOffset(0.0, 0.0),
                                ),
                              ),
                              // child: Icon(
                              //   RiftPlusIcons.close,
                              //   color: AppTheme.activeIcon,
                              //   size: 22,
                              // ),
                              onTap: () {
                                // Navigator.pop(context);
                                _saveNetworkImage(context, parseData(article, 'image'));

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  void _saveNetworkImage(context, image) async {
    String path =
        image;
    GallerySaver.saveImage(path).then((bool success) {
      // setState(() {
      //   print('Image is saved');
      // });
      showDialog(
          context: context,
          builder: (BuildContext builderContext) {
            _timer = Timer(Duration(seconds: 5), () {
              Navigator.of(context).pop();
            });

            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Title'),
              content: SingleChildScrollView(
                child: Text('Content'),
              ),
            );
          }
      ).then((val){
        if (_timer.isActive) {
          _timer.cancel();
        }
      });
    });
  }
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
    this.width,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
          top: BorderSide(color: AppTheme.borderColor, width: 1),
          left: BorderSide(color: AppTheme.borderColor, width: 1),
          right: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 2.0),
              child: Center(
                child: child,
              ),
            )),
      ),
    );
  }
}
