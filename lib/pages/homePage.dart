import 'package:ecommerce_basic/tabs/homeTab.dart';
import 'package:ecommerce_basic/tabs/savedTab.dart';
import 'package:ecommerce_basic/tabs/searchTab.dart';
import 'package:ecommerce_basic/widgets/bottomTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabsPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              children: [
                HomeTab(),
                SearchTab(),
                SavedTab(),
              ],
            )
          ),
          BottomTabs(
            selectedTab: _selectedTab,
            tabClicked: (num) {
              _tabsPageController.animateToPage(
                  num,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic);
            },
          )
        ],
      )
    );
  }
}
