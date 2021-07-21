import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riftplus02/screens/article.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleImage extends StatelessWidget {
  final String article;

  ArticleImage({this.article});

  @override
  Widget build(BuildContext context) {
    if (article != null) {
      return Hero(
        tag: article,
        child: Container(
          child: Center(
            child: new AspectRatio(
              aspectRatio: 1 / 1,
              child: new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.topCenter,
                      image: new NetworkImage(article),
                    )
                ),
              ),
            ),
          ),
        ),

        // child: Container(
        //   // constraints: BoxConstraints(minHeight: 180),
        //   child: FadeInImage.memoryNetwork(
        //     fadeInDuration: Duration(milliseconds: 100),
        //     placeholder: kTransparentImage,
        //     image: article,
        //   ),
        // ),
      );
    }

    return Container(
      height: 250,
      decoration: BoxDecoration(color: Colors.black.withOpacity(.8)),
    );
  }
}
