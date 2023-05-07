import 'package:appkhaosat/main-screen/change_password_page.dart';
import 'package:appkhaosat/main-screen/components/widget/card-horizontal.dart';
import 'package:appkhaosat/main-screen/components/widget/card-small.dart';
import 'package:appkhaosat/main-screen/components/widget/card-square.dart';
import 'package:flutter/material.dart';

import 'components/navigation_drawer.dart';

final Map<String, Map<String, String>> homeCards = {
  "Ice Cream": {
    "title": "Bạn cảm thấy nơi đâu đẹp nhất",
    "image":
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  },
  "Makeup": {
    "title": "Bạn thường dùng trang điểm như thế nào?",
    "image":
        "https://images.unsplash.com/photo-1519368358672-25b03afee3bf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2004&q=80"
  },
  "Coffee": {
    "title": "Bạn thường mặc trang phục thế nào khi ra ngoài?",
    "image":
        "https://raw.githubusercontent.com/creativetimofficial/public-assets/master/now-ui-pro-react-native/bg40.jpg"
  },
  "Fashion": {
    "title": "Làm việc ngoài trời có những lợi ích gì?",
    "image":
        "https://images.unsplash.com/photo-1536686763189-829249e085ac?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=705&q=80"
  },
  "Argon": {
    "title": "Kiểu nội thất mà bạn thích",
    "image":
        "https://raw.githubusercontent.com/creativetimofficial/public-assets/master/now-ui-pro-react-native/project21.jpg"
  }
};

class AccountPage extends StatelessWidget {
  const AccountPage(
      {final Key? key,
      required this.menuScreenContext,
      required this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);
  final BuildContext menuScreenContext;
  final VoidCallback onScreenHideButtonPressed;
  final bool hideStatus;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Tài khoản"),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 88, 169, 212),
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()),
                      );
                    },
                    label: Text(
                      "Change Password",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onScreenHideButtonPressed,
                    child: Text(
                      hideStatus
                          ? "Unhide Navigation Bar"
                          : "Hide Navigation Bar",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
