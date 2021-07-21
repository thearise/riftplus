import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../apptheme.dart';
import '../app.dart';
import 'dragon_lane.dart';
import 'package:riftplus02/screens/screen_one_route/champion_route_test.dart';
class PosPrefInfo extends StatefulWidget {
  const PosPrefInfo({Key key, this.prContext}) : super(key: key);
  final prContext;
  @override
  _PosPrefInfoState createState() => _PosPrefInfoState();
}

class _PosPrefInfoState extends State<PosPrefInfo>  with TickerProviderStateMixin{

  void initState() {
    super.initState();
  }

  @override
  void dispose() {


    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    // showComboVideo2(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black87,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 50.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppTheme.secBgColor,
                              border: Border(
                                bottom: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                top: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                left: BorderSide(color: AppTheme.borderColor, width: 1.0),
                                right: BorderSide(color: AppTheme.borderColor, width: 1.0),
                              )
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/images/system/vision-illu.png')),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top:15, bottom:15),
                                child: Text(
                                  'We appreciate your reports to our communities for Rift Plus to be a better supportive guide.',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    fontFamily: 'spiegel',
                                    fontSize: 14,
                                    color: AppTheme
                                        .labTextActive2,
                                    letterSpacing: 0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  RaisedGradientButton(
                                      child: Text(
                                        'Okay',
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
                                        colors: <Color>[Color(0xFF111217), Color(0xFF111217)],
                                        begin: const FractionalOffset(0.0, 1.0),
                                        end: const FractionalOffset(0.0, 0.0),
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }
                                  ),
                                  SizedBox(
                                      width: 10
                                  ),
                                  RaisedGradientButton(
                                      child: Text(
                                        'Detail',
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
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => DragonLane(desc: ''))
                                        );
                                        // _ChampionRouteState().goPosPrefDetail('s');
                                        // AppState().goPosPrefDetail('2');
                                      }
                                  ),
                                  Expanded(
                                      child: SizedBox()
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





}