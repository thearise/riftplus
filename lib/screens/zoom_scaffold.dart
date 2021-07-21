import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riftplus02/icon_fonts/rift_plus_icons_icons.dart';
import 'package:riftplus02/screens/runesNSpells.dart';
import 'package:riftplus02/screens/screen01.dart';
import 'package:riftplus02/screens/tabItem.dart';

import '../apptheme.dart';
import 'bottomNavigation.dart';
import 'itemsHome.dart';
import 'mapLanes.dart';

class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  static int currentTab = 0;

  int shweIndex = 0;

  createContentDisplay() {
    return zoomAndSlideContent(new Container(
      child: new WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
          !await tabs[currentTab].key.currentState.maybePop();
          if (isFirstRouteInCurrentTab) {
            // if not on the 'main' tab
            if (currentTab != 0) {
              // select 'main' tab
              _selectTab(0);
              // back button handled by app
              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        // this is the base scaffold
        // don't put appbar in here otherwise you might end up
        // with multiple appbars on one screen
        // eventually breaking the app


        child: Scaffold(
            backgroundColor: AppTheme.secBgColor,
            // indexed stack shows only one child
            body: Stack(
              children: [

                IndexedStack(
                  index: currentTab,
                  children: tabs.map((e) => e.page).toList(),
                ),
              ],
            ),
            // Bottom navigation


            // bottomNavigationBar: Theme(
            //   data: ThemeData(
            //     splashColor: Colors.transparent,
            //     highlightColor: Colors.transparent,
            //   ),
            //   child: BottomNavigation(
            //     onSelectTab: _selectTab,
            //     tabs: tabs,
            //   ),
            // )

            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: AppTheme.secBgColor,
                  border: Border(top: BorderSide(color: AppTheme.activeIcon, width: 1.0))),
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: new Theme(
                    // data: ThemeData(
                    //   splashColor: Colors.transparent,
                    //   highlightColor: Colors.transparent,
                    //   primaryColor: Colors.red,
                    // ),
                  data: Theme.of(context).copyWith(
                    // sets the background color of the `BottomNavigationBar`
                      canvasColor: AppTheme.secBgColor,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    onTap: (int index) {
                      _selectTab(index);
                      setState(() {
                        shweIndex = index;
                      });
                    }, //
                    items: [
                      BottomNavigationBarItem(
                        icon: shweIndex == 0? Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.champion,
                            color: AppTheme.activeIcon,
                            size: 25,
                          ),
                        ):Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.champion,
                            color: AppTheme.normalIcon,
                            size: 25,
                          ),
                        ),
                        title: Text(''),
                      ),

                      BottomNavigationBarItem(
                        icon: shweIndex == 1? Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.items,
                            color: AppTheme.activeIcon,
                            size: 26,
                          ),
                        ):Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.items,
                            color: AppTheme.normalIcon,
                            size: 26,
                          ),
                        ),
                        title: Text(''),
                      ),

                      BottomNavigationBarItem(
                        icon: shweIndex == 2? Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.runebeta,
                            color: AppTheme.activeIcon,
                            size: 24,
                          ),
                        ):Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.runebeta,
                            color: AppTheme.normalIcon,
                            size: 24,
                          ),
                        ),
                        title: Text(''),
                      ),

                      BottomNavigationBarItem(
                        icon: shweIndex == 3? Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.map,
                            color: AppTheme.activeIcon,
                            size: 23,
                          ),
                        ):Padding(
                          padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                          child: Icon(
                            RiftPlusIcons.map,
                            color: AppTheme.normalIcon,
                            size: 23,
                          ),
                        ),
                        title: Text(''),
                      ),
                    ],
                    // new new
                    // items: [
                    //   new BottomNavigationBarItem(
                    //     icon: shweIndex == 0? Padding(
                    //       padding: const EdgeInsets.only(right: 6, bottom: 0.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.activeIcon,
                    //         size: 25,
                    //       ),
                    //     ):Padding(
                    //       padding: const EdgeInsets.only(right: 6, bottom: 0.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.normalIcon,
                    //         size: 25,
                    //       ),
                    //     ),
                    //     title: Text(''),
                    //   ),
                    //   new BottomNavigationBarItem(
                    //     icon: shweIndex == 1? Padding(
                    //       padding: const EdgeInsets.only(right: 38, bottom: 15.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.activeIcon,
                    //         size: 25,
                    //       ),
                    //     ):Padding(
                    //       padding: const EdgeInsets.only(right: 38, bottom: 15.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.normalIcon,
                    //         size: 25,
                    //       ),
                    //     ),
                    //     title: Text(''),
                    //   ),
                    //   new BottomNavigationBarItem(
                    //     icon: shweIndex == 2? Padding(
                    //       padding: const EdgeInsets.only(right: 35, bottom: 15.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.activeIcon,
                    //         size: 25,
                    //       ),
                    //     ):Padding(
                    //       padding: const EdgeInsets.only(right: 35, bottom: 15.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.normalIcon,
                    //         size: 25,
                    //       ),
                    //     ),
                    //     title: Text(''),
                    //   ),
                    //   new BottomNavigationBarItem(
                    //     icon: shweIndex == 3? Padding(
                    //       padding: const EdgeInsets.only(right: 25, bottom: 15.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.activeIcon,
                    //         size: 25,
                    //       ),
                    //     ):Padding(
                    //       padding: const EdgeInsets.only(right: 25, bottom: 15.0),
                    //       child: Icon(
                    //         RiftPlusIcons.items,
                    //         color: AppTheme.normalIcon,
                    //         size: 25,
                    //       ),
                    //     ),
                    //     title: Text(''),
                    //   )
                    // ],
                  ),
                ),
              ),
            ),


        ),

        // child: ChangeNotifierProvider(
        //   create: (context) => menuController,
        //   child: ZoomScaffold(
        //     menuScreen: MenuScreen(),
        //     contentScreen: Layout(
        //         contentBuilder: (cc) => Container(
        //           color: Colors.grey[200],
        //           child: Container(
        //             color: Colors.grey[200],
        //           ),
        //         )),
        //   ),
        // )
      ),
      // child: new Scaffold(
      //   backgroundColor: AppTheme.secBgColor,
      //
      //   // indexed stack shows only one child
      //   body: Stack(
      //     children: [
      //
      //       IndexedStack(
      //         index: currentTab,
      //         children: tabs.map((e) => e.page).toList(),
      //       ),
      //     ],
      //   ),
      //   // Bottom navigation
      //   bottomNavigationBar: Theme(
      //     data: ThemeData(
      //       splashColor: Colors.transparent,
      //       highlightColor: Colors.transparent,
      //     ),
      //     child: BottomNavigation(
      //       onSelectTab: _selectTab,
      //       tabs: tabs,
      //     ),
      //   ),
      // )

    ));
  }

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Champions",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: ScreenOne(),
    ),
    TabItem(
      tabName: "Items",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: ItemsHome(),
    ),
    TabItem(
      tabName: "Settings",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: RunesNSpells(),
    ),
    TabItem(
      tabName: "Settings",
      icon: Icon(
        RiftPlusIcons.wild_cores,
      ),
      page: MapLanes(),
    ),
  ];

  // _ZoomScaffoldState() {
  //   // indexing is necessary for proper funcationality
  //   // of determining which tab is active
  //   tabs.asMap().forEach((index, details) {
  //     details.setIndex(index);
  //   });
  // }

  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: false).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: false).percentOpen);
        break;
    }

    // final slideAmount = 275.0 * (slidePercent);
    final slideAmount = MediaQuery.of(context).size.width * 0.8 * (slidePercent);
    final contentScale = 1.0 - (0 * scalePercent);
    final cornerRadius =
        16.0 * Provider.of<MenuController>(context, listen: false).percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 2.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        // child: new ClipRRect(
        //     borderRadius: new BorderRadius.circular(cornerRadius),
        //     child: content),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(0),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Provider.of<MenuController>(context, listen: false));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
