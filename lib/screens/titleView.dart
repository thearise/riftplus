import 'package:flutter/material.dart';
import 'package:riftplus02/screens/screen_one_route/seeall_route.dart';
import 'package:riftplus02/screens/screen_one_route/seeall_runes_route.dart';

import '../apptheme.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final String id;

  const TitleView(
      {Key key,
        this.titleTxt: "",
        this.subTxt: "",
        this.id: "",})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                titleTxt.toUpperCase(),
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
                if(this.id.contains('runes')) {
                  print('runes');
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SeeAllRunesRoute(id: this.id))
                  );
                } else {
                  print('not runes');
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SeeAllRoute(id: this.id))
                  );
                }

              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      subTxt,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'spiegel',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.5,
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
    );
  }
}
