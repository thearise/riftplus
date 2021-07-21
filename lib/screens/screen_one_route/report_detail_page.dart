import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apptheme.dart';
import '../app.dart';
class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({Key key, this.name}) : super(key: key);
  final String name;
  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage>  with TickerProviderStateMixin{
  final myController = TextEditingController();
  var reporting = false;
  String _enteredText = '';
  var limits = false;
  var specials = false;
  static final validCharacters = RegExp(r'^[a-zA-Z0-9 \nေဆတနမအပကငသစဟေျိ်ါ့ြုူးရဖထခလဘညာဋဍဈဝဣဩဤဪင်္ဥဿဏဧဗှီ္ွံဲဒဓဂဎဇဌဃဠယဉဦ၍၏၁၂၃၄၅၆၇၈၉၀၌၎င်းေ\-=@,\.]+$');
  Future languages;
  void initState() {
    languages = _getLanguage();
    super.initState();
  }

  _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getString('language');
    print(index);
    if(index == null) {
      return '_en';
    } else if(index == 'EN') {
      return '_en';
    } else if(index == 'MM') {
      return '';
    }
  }

  @override
  void dispose() {

    myController.dispose();
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
                          child: FutureBuilder(
                            future: languages,
                            builder: (context, snapshot) {
                               if(snapshot.hasData) {
                                 return Column(
                                   children: [
                                     SizedBox(height: 20,),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                       child: Text(
                                         '!REPORT ABOUT \'' + widget.name.toUpperCase() + '\'',
                                         textScaleFactor: 1,
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                           fontFamily: 'beaufortforlol',
                                           fontWeight: FontWeight.w700,
                                           fontSize: 18,
                                           letterSpacing: 0.3,
                                           color: AppTheme.labTextActive,
                                         ),

                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0, top:15, bottom:10),
                                       child: Text(
                                         snapshot.data=='_en'?'We appreciate your reports to our communities for Rift Plus to be a better supportive guide.':
                                         'အကြံပေးချင်တာ ဖြစ်ဖြစ်၊ အဆင်မပြေတာ ဖြစ်ဖြစ် တခုခုတောင်းဆိုချင်ပါက ကျတော်တို့ ဆီကို report တင်ပြီးတောင်းဆိုလို့ ရပါတယ်ခင်ဗျာ။',
                                         textScaleFactor: 1,
                                         style: TextStyle(
                                           fontFamily: 'spiegel',
                                           fontSize: 14,
                                           height: 1.5,
                                           color: AppTheme
                                               .labTextActive2,
                                           letterSpacing: 0.3,
                                         ),
                                         textAlign: TextAlign.center,
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                       child: Row(
                                         children: [
                                           (limits&&specials)||(limits&&!specials)?Text(
                                             'Exceed limits',
                                             textScaleFactor: 1,
                                             style: TextStyle(
                                               fontFamily: 'spiegel',
                                               fontSize: 12,
                                               color: AppTheme
                                                   .criticalStrike,
                                               letterSpacing: 0.3,
                                             ),
                                             textAlign: TextAlign.left,
                                           ):Container(),
                                           (!limits&&specials)?Text(
                                             'No special key',
                                             textScaleFactor: 1,
                                             style: TextStyle(
                                               fontFamily: 'spiegel',
                                               fontSize: 12,
                                               color: AppTheme
                                                   .criticalStrike,
                                               letterSpacing: 0.3,
                                             ),
                                             textAlign: TextAlign.left,
                                           ):Container(),
                                           Expanded(
                                             child: Text(
                                               '${_enteredText.length.toString()} / 500',
                                               textScaleFactor: 1,
                                               style: TextStyle(
                                                 fontFamily: 'spiegel',
                                                 fontSize: 12,
                                                 color: AppTheme
                                                     .labTextActive2,
                                                 letterSpacing: 0.3,
                                               ),
                                               textAlign: TextAlign.right,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                       child: Card(
                                           color: Colors.black54,
                                           child: Padding(
                                             padding: EdgeInsets.all(8.0),
                                             child: Theme(
                                               data: Theme.of(context).copyWith(textSelectionTheme: TextSelectionThemeData(
                                                   selectionColor: AppTheme.activeIcon)),
                                               child: TextField(
                                                 controller: myController,
                                                 onChanged: (value) {
                                                   setState(() {
                                                     _enteredText = value;
                                                   });
                                                   if(value.length>500) {
                                                     setState(() {
                                                       limits = true;
                                                     });
                                                   } else {
                                                     setState(() {
                                                       limits = false;
                                                     });
                                                   }
                                                   if(!validCharacters.hasMatch(value) && value.length>0) {
                                                     setState(() {
                                                       specials = true;
                                                     });
                                                   } else {
                                                     setState(() {
                                                       specials = false;
                                                     });
                                                   }
                                                 },
                                                 style: TextStyle(
                                                   fontFamily: 'spiegel',
                                                   fontSize: 16,
                                                   color: AppTheme
                                                       .labTextActive2,
                                                   letterSpacing: 0.3,
                                                 ),
                                                 maxLines: 4,
                                                 cursorColor: AppTheme.activeIcon,
                                                 decoration: InputDecoration.collapsed(
                                                     hintText: "Enter reports here...",
                                                     hintStyle: TextStyle(
                                                       fontFamily: 'spiegel',
                                                       fontSize: 15,
                                                       color: AppTheme
                                                           .labTextActive2,
                                                       letterSpacing: 0.3,
                                                     )
                                                 ),
                                               ),
                                             ),
                                           )
                                       ),
                                     ),
                                     SizedBox(
                                       height: 10,
                                     ),
                                     AbsorbPointer(
                                       absorbing: reporting,
                                       child: Row(
                                         children: [
                                           Expanded(
                                             child: SizedBox(),
                                           ),
                                           RaisedGradientButton(
                                               child: Text(
                                                 'Cancel',
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
                                               child: reporting?Container(
                                                 width: 52,
                                                 height: 21,
                                                 child: Center(child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                                     child: CupertinoActivityIndicator(radius: 10,))),
                                               ):Text(
                                                 'Report',
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
                                                 if(!limits&&myController.text.length>0&&!specials) {
                                                   createReport(widget.name, myController.text);
                                                 }
                                               }
                                           ),
                                           Expanded(
                                               child: SizedBox()
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(
                                       height: 25,
                                     )
                                   ],
                                 );
                               }
                               return Container();
                            }
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


  Future<http.Response> createReport(String about, String desc) async {
    // print('shwwwwwww' + desc);
    // return http.post(
    //   Uri.parse('https://hninsunyein.me/rift_plus/rift_plus/api/createReport.php'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'desc': desc,
    //   }),
    // );
    setState(() {
      reporting = true;
    });

    String url = "https://hninsunyein.me/rift_plus/rift_plus/api/createReport.php";
    print('shwwww' + desc);
    var response = await http.post(url, body: {
      "desc":about + ' - ' + desc,
    });

    // var body = jsonDecode(response.body);

    if(response.statusCode == 200){
      Navigator.pop(context);
      debugPrint("Data posted successfully");
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(milliseconds: 2500), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              backgroundColor: AppTheme.secBgColor,
              title: Text(
                'REPORTED SUCCESSFULLY',
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
                      'Thanks for your reports to our communities.',
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
            );
          }
      );
    }else{
      Navigator.pop(context);
      debugPrint("Something went wrong! Status Code is: ${response.statusCode}");
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(milliseconds: 2500), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              backgroundColor: AppTheme.secBgColor,
              title: Text(
                'SOMETHING WENT WRONG',
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
                      'Please try agian later.',
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
            );
          }
      );
    }




    setState(() {
      reporting = false;
    });
  }





}