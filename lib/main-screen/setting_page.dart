import 'package:appkhaosat/login-screen/login_screen.dart';
import 'package:appkhaosat/main-screen/components/widget/table_cell.dart';
import 'package:appkhaosat/main-screen/constants/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/navigation_drawer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> logout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await _auth.signOut();

  await prefs.setBool('isLoggedIn', false);
  await prefs.remove('uid');
  await prefs.remove('email');

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
}

late BuildContext? menuScreenContext2;

class SettingPage extends StatefulWidget {
  const SettingPage(
      {final Key? key,
        required this.menuScreenContext,
        required this.onScreenHideButtonPressed,
        this.hideStatus = false})
      : super(key: key);
  final BuildContext menuScreenContext;
  final VoidCallback onScreenHideButtonPressed;
  final bool hideStatus;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingPage> {
  late bool isLoggedIn;
  bool switchValueOne = false;
  bool switchValueTwo = false;

  void initState() {
    setState(() {
      switchValueOne = true;
      switchValueTwo = false;
      isLoggedIn = true;
    });
    super.initState();
  }
  void _handleLogout() async {
    // Xóa thông tin đăng nhập
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
    await prefs.setBool('isLoggedIn',false);


    // Điều hướng đến trang "/" và loại bỏ mọi màn hình sau đó
    Navigator.of(widget.menuScreenContext).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("SETTTINGS",
                            style: TextStyle(
                                color: NowUIColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Đây là page cài đặt",
                            style:
                            TextStyle(color: NowUIColors.time, fontSize: 14)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Lưu đăng nhập",
                            style: TextStyle(color: NowUIColors.text)),
                        Switch.adaptive(
                          value: isLoggedIn,
                          onChanged: (bool newValue) =>
                              setState(() => isLoggedIn = newValue),
                          activeColor: NowUIColors.primary,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: (){
                            _handleLogout();
                          },
                          child: Text(
                            'Đăng xuất',
                            style: TextStyle(color: NowUIColors.text),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 36.0),


                  ],
                ),
              ),
            )));
  }
}