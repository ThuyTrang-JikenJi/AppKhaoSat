import 'package:appkhaosat/main-screen/main_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:appkhaosat/utils/helper_functions.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import '../../../utils/constants.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signInWithEmailAndPassword(
    BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (user != null && user.emailVerified) {
      // Lưu thông tin đăng nhập thành công
      await prefs.setString('uid', user.uid);
      await prefs.setString('email', user.email.toString());
      await prefs.setBool('isLoggedIn', true);
      // Tài khoản đã được xác thực
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: main_page(
          menuScreenContext: context,
        ),
      );
    } else {
      await user?.sendEmailVerification();
      Fluttertoast.showToast(msg: 'Hãy xác thực email trước khi đăng nhập');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-email') {
      Fluttertoast.showToast(msg: 'email không hợp lệ.');
    } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: 'Tài khoản hoặc mật khẩu không đúng.');
    }
  }
}

Future<void> signUpWithEmail(
    BuildContext context, String email, String password, String name) async {
  try {
    UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCredential != null) {
      User? user = userCredential.user;
      if (user != null) {
        // Thêm thông tin người dùng vào realtime database
        final referenceDatabase = FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(user.uid);
        referenceDatabase.set({
          'name': name,
          'email': email,
        });
        // Gửi email xác thực đến email người dùng
        await user.sendEmailVerification();

        Fluttertoast.showToast(
            msg:
                'Đăng ký thành công, xin hãy vào check mail để xác nhận tài khoản.');
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Fluttertoast.showToast(msg: 'Mật khẩu quá yếu.');
    } else if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(msg: 'Tài khoản email đã được sử dụng.');
    } else {
      Fluttertoast.showToast(msg: 'Lỗi không xác định.');
    }
  } catch (e) {
    print(e);
    Fluttertoast.showToast(msg: 'Lỗi không xác định.');
  }
}

enum Screens {
  welcomeBack,
  createAccount,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget inputField(String hint, IconData iconData) {
    switch (hint) {
      case 'Email':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: SizedBox(
            height: 50,
            child: Material(
              elevation: 8,
              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _emailController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hint,
                  prefixIcon: Icon(iconData),
                ),
              ),
            ),
          ),
        );
        break;
      case 'Password':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: SizedBox(
            height: 50,
            child: Material(
              elevation: 8,
              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hint,
                  prefixIcon: Icon(iconData),
                ),
              ),
            ),
          ),
        );
        break;
      case 'Name':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: SizedBox(
            height: 50,
            child: Material(
              elevation: 8,
              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _nameController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hint,
                  prefixIcon: Icon(iconData),
                ),
              ),
            ),
          ),
        );
        break;
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: SizedBox(
            height: 50,
            child: Material(
              elevation: 8,
              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hint,
                  prefixIcon: Icon(iconData),
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if (ChangeScreenAnimation.currentScreen == Screens.welcomeBack) {
            signInWithEmailAndPassword(
                context, _emailController.text, _passwordController.text);
          } else {
            signUpWithEmail(context, _emailController.text,
                _passwordController.text, _nameController.text);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          const SizedBox(width: 24),
          Image.asset('assets/images/google.png'),
        ],
      ),
    );
  }

  Future<void> resetPassWithEmail(BuildContext context, String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Lỗi không xác định.');
    }
  }

  TextEditingController _textFieldResetPass = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Type your email address here'),
            content: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              controller: _textFieldResetPass,
              validator: (_) =>
                  EmailValidator.validate(_textFieldResetPass.text)
                      ? null
                      : "Please enter a valid email",
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: "Enter your email address"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (!EmailValidator.validate(_textFieldResetPass.text)) {
                    Navigator.of(context).pop();
                  } else {
                    resetPassWithEmail(context, _textFieldResetPass.text);
                    Fluttertoast.showToast(msg: 'Vào email để reset password');
                    _textFieldResetPass.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          _displayDialog(context);
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    loginContent = [
      inputField('Email', Ionicons.mail_outline),
      inputField('Password', Ionicons.lock_closed_outline),
      loginButton('Log In'),
      forgotPassword(),
    ];

    createAccountContent = [
      inputField('Name', Ionicons.person_outline),
      inputField('Email', Ionicons.mail_outline),
      inputField('Password', Ionicons.lock_closed_outline),
      loginButton('Sign Up'),
      orDivider(),
      logos(),
    ];
    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 100,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
