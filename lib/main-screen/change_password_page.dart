import 'package:appkhaosat/main-screen/change_password_page.dart';
import 'package:appkhaosat/main-screen/components/widget/card-horizontal.dart';
import 'package:appkhaosat/main-screen/components/widget/card-small.dart';
import 'package:appkhaosat/main-screen/components/widget/card-square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/navigation_drawer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> changePassword(
    BuildContext context, String currentPassword, String newPassword) async {
  try {
    final user = _auth.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user?.email ?? '', password: currentPassword);
    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        Fluttertoast.showToast(msg: 'Thay đổi mật khẩu thành công.');
        Navigator.pop(context);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: 'Password cant be changed + ${error.toString()}');
        print(error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: 'Mật khẩu hiện tại sai , vui lòng kiểm tra lại');
    });
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(msg: 'Lỗi không xác định.');
  } catch (e) {
    print(e);
    Fluttertoast.showToast(msg: 'Lỗi không xác định.');
  }
}

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

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    final Key? key,
  }) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _passwordController = TextEditingController();

  final _confirmpasswordController = TextEditingController();
  // String? passwordInputValidator(value) {
  //   if (value == null ||
  //       _confirmpasswordController.text != _passwordController.text) {
  //     return 'Password doesnt match';
  //   }
  // }

  Widget MakeInput(label, obscureText, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          autovalidateMode: AutovalidateMode.always,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
              border: OutlineInputBorder(borderSide: BorderSide()),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2.0),
              )),
          validator: (value) {
            // add your custom validation here.
            if (value == null) {
              return 'Please enter some text';
            }
            if (value.length < 6) {
              return 'Must be more than 5 charater';
            }
            return null;
          },
        )
      ],
    );
  }

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Thay đổi mật khẩu"),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 88, 169, 212),
              automaticallyImplyLeading: false,
            ),
            body: Form(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MakeInput('Type your current password', true,
                        _passwordController),
                    const SizedBox(
                      height: 10.0,
                    ),
                    MakeInput('Type your new password', true,
                        _confirmpasswordController),
                    ElevatedButton(
                      onPressed: () {
                        changePassword(context, _passwordController.text,
                            _confirmpasswordController.text);
                      },
                      child: Text(
                        "Change your new password",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
