import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:http/http.dart' as http;
import '../apptheme.dart';
import 'app.dart';
import 'circular_image.dart';
import 'news_detail.dart';
import 'news_list_tile.dart';
import 'zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> with AutomaticKeepAliveClientMixin <MenuScreen> {
  @override
  bool get wantKeepAlive => true;
  final String imageUrl =
      "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  final List<MenuItem> options = [
    MenuItem(Icons.search, 'Search'),
    MenuItem(Icons.shopping_basket, 'Basket'),
    MenuItem(Icons.favorite, 'Discounts'),
    MenuItem(Icons.code, 'Prom-codes'),
    MenuItem(Icons.format_list_bulleted, 'Orders'),
  ];

  Future<CountriesData> sendCountriesDataRequest(int page) async {
    try {
      // String url = Uri.encodeFull(
      //     'https://api.worldbank.org/v2/country?page=$page&format=json');
      String url = Uri.encodeFull(
          'https://hninsunyein.me/rift_plus/rift_plus/api/getNewsByPage.php?page=' + page.toString());
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
      list.add(value['n_desc']);
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
      child: Container(
        color: AppTheme.thirdBgColor,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                // decoration: BoxDecoration(boxShadow: [
                //   BoxShadow(
                //       color: Colors.black.withOpacity(0.3), blurRadius: 1)
                // ]),
                child: NewsListTile(
                    article: value),
              ),
            ),
            SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white10, width: 1.0))
                    ),
                  ),
                )
            )
          ],
        ),
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
    return Container(
      width:  MediaQuery.of(context).size.width * 0.8,
      child: GestureDetector(
        onPanUpdate: (details) {
          //on swiping left
          if (details.delta.dx < -6) {
            Provider.of<MenuController>(context, listen: false).toggle();
          }
        },
        child: Container(
          color: AppTheme.thirdBgColor,
          child: SafeArea(
            top: true,
            bottom: true,
            left: false,
            right: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
                      color: AppTheme.thirdBgColor,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 17),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 0, bottom: 12),
                          child: Text(
                            'NEWS INBOX',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontFamily: 'beaufortforlol',
                              fontSize: 21,
                              color: Colors.white60,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppTheme.thirdBgColor,
                    child: Paginator.listView(
                      key: paginatorGlobalKey,
                      pageLoadFuture: sendCountriesDataRequest,
                      pageItemsGetter: listItemsGetter,
                      listItemBuilder: listItemBuilder,
                      loadingWidgetBuilder: loadingWidgetMaker,
                      errorWidgetBuilder: errorWidgetMaker,
                      emptyListWidgetBuilder: emptyListWidgetMaker,
                      totalItemsGetter: totalPagesGetter,
                      pageErrorChecker: pageErrorChecker,
                      scrollPhysics: BouncingScrollPhysics(),
                    ),

                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black, width: 1.0)),
                    color: AppTheme.thirdBgColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            '© Ethereal Tech Inc',
                            style: TextStyle(
                              fontFamily: 'spiegel',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white60,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          trailing: Text(
                            'Ver 2.1',
                            style: TextStyle(
                              fontFamily: 'spiegel',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white60,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}
