import 'package:appkhaosat/login-screen/login_screen.dart';
import 'package:appkhaosat/main-screen/SurveyPage.dart';
import 'package:appkhaosat/main-screen/account_page.dart';
import 'package:appkhaosat/main-screen/components/model/navigation_item.dart';
import 'package:appkhaosat/main-screen/components/provider/navigationprovider.dart';
import 'package:appkhaosat/main-screen/create_page.dart';
import 'package:appkhaosat/main-screen/main_page.dart';
import 'package:appkhaosat/main-screen/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
   return MaterialApp(
      title: 'App khảo sát',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      initialRoute: "/",
      routes: routes,
    );
  }
}

Map<String, WidgetBuilder> routes = {

  "/home": (final context) => main_page(menuScreenContext: context),
  "/create": (final context) => MyQuizPage(),

};



