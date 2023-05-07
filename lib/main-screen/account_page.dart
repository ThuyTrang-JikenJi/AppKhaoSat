import 'package:appkhaosat/main-screen/change_password_page.dart';
import 'package:appkhaosat/main-screen/components/widget/card-horizontal.dart';
import 'package:appkhaosat/main-screen/components/widget/card-small.dart';
import 'package:appkhaosat/main-screen/components/widget/card-square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
final FirebaseAuth _auth = FirebaseAuth.instance;
final user = _auth.currentUser;

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
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
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
          body: Container(
            margin: EdgeInsets.only(bottom: 50.0),
            color: Colors.white54,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 65,
                      backgroundImage: NetworkImage(user?.photoURL ??
                          'https://th.bing.com/th/id/R.499272900849b17032349eeb736e182b?rik=hVh5Yj0C0D9MfA&pid=ImgRaw&r=0'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       user?.displayName != ''
                //           ? (user?.displayName ?? '')
                //           : 'No name available',
                //       style: const TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20,
                //           color: Colors.black),
                //     )
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user?.email ?? 'No email available',
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       user?.phoneNumber ?? 'No phone number available',
                //       style: TextStyle(fontSize: 20),
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 10),
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const ListTile(
                        leading: Icon(
                          Icons.privacy_tip_sharp,
                          color: Colors.black54,
                        ),
                        title: Text(
                          'Quyền riêng tư',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ));
                      },
                      child: Card(
                        color: Colors.white70,
                        margin: const EdgeInsets.only(
                            left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.lock_open,
                            color: Colors.black54,
                          ),
                          title: Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      color: Colors.white70,
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const ListTile(
                        leading:
                            Icon(Icons.help_outline, color: Colors.black54),
                        title: Text(
                          'Giúp đỡ & Hỗ trợ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Card(
                    //   color: Colors.white70,
                    //   margin: const EdgeInsets.only(
                    //       left: 35, right: 35, bottom: 10),
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30)),
                    //   child: const ListTile(
                    //     leading: Icon(
                    //       Icons.privacy_tip_sharp,
                    //       color: Colors.black54,
                    //     ),
                    //     title: Text(
                    //       'Settings',
                    //       style: TextStyle(
                    //           fontSize: 18, fontWeight: FontWeight.bold),
                    //     ),
                    //     trailing: Icon(Icons.arrow_forward_ios_outlined),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Card(
                    //   color: Colors.white70,
                    //   margin: const EdgeInsets.only(
                    //       left: 35, right: 35, bottom: 10),
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30)),
                    //   child: const ListTile(
                    //     leading: Icon(
                    //       Icons.add_reaction_sharp,
                    //       color: Colors.black54,
                    //     ),
                    //     title: Text(
                    //       'Mời bạn',
                    //       style: TextStyle(
                    //           fontSize: 18, fontWeight: FontWeight.bold),
                    //     ),
                    //     trailing: Icon(
                    //       Icons.arrow_forward_ios_outlined,
                    //       color: Colors.black54,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Card(
                      color: Colors.white70,
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.black54,
                        ),
                        title: Text(
                          'Đăng xuất',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
