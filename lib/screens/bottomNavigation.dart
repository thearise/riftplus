import 'package:riftplus02/icon_fonts/riftplus-icons.dart';

import '../apptheme.dart';
import 'app.dart';
import 'package:flutter/material.dart';
import 'tabItem.dart';

class BottomNavigation extends StatelessWidget {
  var gindex = 0;
  BottomNavigation({
    this.onSelectTab,
    this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.borderColor, width: 1.0))),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.secBgColor,
          onTap: (int index) {
            onSelectTab(
              index,
            );
            gindex = index;
            print(gindex);
          },
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          // items: [
          //   new BottomNavigationBarItem (
          //      icon: Icon(
          //        RiftPlusIcons.wild_cores,
          //        size: 25,
          //        color: AppTheme.normalIcon,
          //      ),
          //      activeIcon: Icon(
          //        RiftPlusIcons.champion,
          //        size: 25,
          //        color: AppTheme.normalIcon,
          //      ),
          //      title: new Text('')),
          //   new BottomNavigationBarItem(
          //      icon: Icon(
          //        RiftPlusIcons.items,
          //        size: 25,
          //        color: AppTheme.normalIcon,
          //      ),
          //      title: new Text("")),
          //   new BottomNavigationBarItem(
          //      icon: Icon(
          //        RiftPlusIcons.runebeta,
          //        size: 25,
          //        color: AppTheme.normalIcon,
          //      ),
          //      title: new Text("")),
          //   new BottomNavigationBarItem(
          //      icon: Icon(
          //        RiftPlusIcons.map,
          //        size: 25,
          //        color: AppTheme.normalIcon,
          //      ),
          //      title: new Text("")),
          // ],
            items: tabs
                .map(
                  (e) => _buildItem(
                index: e.getIndex(),
                icon: e.icon,
                tabName: e.tabName,
              ),
            )
                .toList(),


//        onTap: (index) {
//          onSelectTab(
//            index,
//          );
//          gindex = index;
//          print(gindex);
//        },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {int index, Icon icon, String tabName}) {
    return BottomNavigationBarItem(
//      icon: new Image.asset(
//        _tabIcon(index, icon),
//        height: 50,
//        width: 50,
//      ),
      icon: _tabIcon(index, icon),
//      icon: icon,
      title: Text(
        '',
        style: TextStyle(
          fontSize: 0,
        ),
      ),
    );
  }

  Color _tabColor({int index}) {
    return AppState.currentTab == index ? AppTheme.activeIcon : AppTheme.normalIcon;
  }

  Icon _tabIcon(index, icon) {
//    return AppState.currentTab == index ? icon + 's_v2.png' : icon + '_v2.png';
    if(index==0) {
      return AppState.currentTab == index ? Icon(
        RiftPlusIcons.champion,
        color: AppTheme.activeIcon,
        size: 25,
      ): Icon(
        RiftPlusIcons.champion,
        color: AppTheme.normalIcon,
        size: 25,
      );
    } else if(index==1) {
      return AppState.currentTab == index ? Icon(
        RiftPlusIcons.items,
        color: AppTheme.activeIcon,
        size: 25,
      ): Icon(
        RiftPlusIcons.items,
        color: AppTheme.normalIcon,
        size: 25,
      );
    } else if(index==2) {
      return AppState.currentTab == index ? Icon(
        RiftPlusIcons.runebeta,
        color: AppTheme.activeIcon,
        size: 24,
      ): Icon(
        RiftPlusIcons.runebeta,
        color: AppTheme.normalIcon,
        size: 24,
      );
    } else {
      return AppState.currentTab == index ? Icon(
        RiftPlusIcons.map,
        color: AppTheme.activeIcon,
        size: 22,
      ): Icon(
        RiftPlusIcons.map,
        color: AppTheme.normalIcon,
        size: 22,
      );
    }

  }
//  Icon _tabIcon(index, icon) {
//    return
//  }
}