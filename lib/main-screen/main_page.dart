import 'package:appkhaosat/login-screen/login_screen.dart';
import 'package:appkhaosat/main-screen/SurveyPage.dart';
import 'package:appkhaosat/main-screen/account_page.dart';
import 'package:appkhaosat/main-screen/components/navigation_drawer.dart';
import 'package:appkhaosat/main-screen/create_page.dart';
import 'package:appkhaosat/main-screen/detail.dart';
import 'package:appkhaosat/main-screen/search_screen.dart';
import 'package:appkhaosat/main-screen/setting_page.dart';
import 'package:appkhaosat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


BuildContext? testContext;

class main_page extends StatefulWidget {
  const main_page({final Key? key, required this.menuScreenContext})
      : super(key: key);

  final BuildContext menuScreenContext;

  @override
  State<main_page> createState() => _State();
}

class _State extends State<main_page> {

  bool _hideNavBar = false;
  PersistentTabController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    this._hideNavBar = false;
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(

      body: PersistentTabView(
        context,
        controller: _controller,
        screens: screens(),
        selectedTabScreenContext: (final context) {
          testContext = context;
        },
        hideNavigationBar: _hideNavBar,

        items: _navBarsItems(),
        confineInSafeArea: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style8,
        handleAndroidBackButtonPress: true,
        hideNavigationBarWhenKeyboardShows: true,

        floatingActionButton: FloatingActionButton(
          onPressed: ()
          {
            Navigator.pushNamed(context, "/create");
          },
          child: Icon(Icons.add),
        ),

      ),
    );
  }

  List<Widget>screens(){
    return [
      Detail(menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },),
      Search_Screen(menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },),
      AccountPage(
        menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),

      SettingPage(menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },),

    ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes : {
            "/" : (final context) => LoginScreen(),
            "/home": (final context) => main_page(menuScreenContext: context),
            "/create": (final context) => MyQuizPage(),

        },
        )

      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.chart_bar_circle),
        title: ("Khảo sát"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,

      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_circle),
        title: ("Tài khoản"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes : {
          "/" : (final context) => const LoginScreen(),
          "/home": (final context) => main_page(menuScreenContext: context),
          "/create": (final context) => MyQuizPage(),

        },
      ),
      ),
    ];
  }




}


