import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/firebase/user.dart' as db;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/device.dart';
import '../opportunities_page.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool fieldFilled = false;
  bool obscure = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      UserCredential userCredential =
          await _authInstance.signInWithPopup(authProvider);

      if (userCredential.user != null) {
        db.User user = db.User(
          email: userCredential.user!.email!,
          uid: userCredential.user!.uid,
        );
        await user.addToFirestore();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OpportunitiesPage(),
          ),
        );
      } else {
        _showErrorDialog("No user is signed in.");
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _createUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        db.User user = db.User(
          email: email,
          uid: userCredential.user!.uid,
        );
        await user.addToFirestore();
      }

      Navigator.pop(context);

      if (kDebugMode) {
        print(
            "Sign Up Successful: User created with email $email and password $password");
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, _) {
        return Stack(
          children: <Widget>[
            _buildBackground(),
            Column(
              children: [
                SizedBox(height: 6.h),
                Center(
                  child: Container(
                    width: 56.w,
                    height: 87.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: authBoxDecorations,
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildAvatar(),
                        SizedBox(height: .94.h),
                        _buildTitle(),
                        SizedBox(height: .94.h),
                        _buildLoginLink(),
                        SizedBox(height: .47.h),
                        _buildLoginPlatforms(),
                        SizedBox(height: height(context) * 55 / 840),
                        _buildDivider(context),
                        SizedBox(height: height(context) * 40 / 840),
                        _buildCredentialsText(),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 16 / 840),
                        _buildAuthFields(),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 16 / 840),
                        _buildCreateAccountButton(),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: const Duration(milliseconds: 1000))
                    .slideY(
                      begin: 0.25,
                      end: 0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.ease,
                    ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/images/auth_background.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      children: [
        SizedBox(height: 5.71.h),
        const Spacer(),
        Padding(
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
          child: IconButton(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LoginPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            icon: Icon(
              Icons.close_outlined,
              color: darkAccent,
              size: height(context) * 20 / 814 > width(context) * 20 / 1440
                  ? width(context) * 20 / 1440
                  : height(context) * 20 / 814,
            ),
          ),
        )
      ],
    );
  }

  Center _buildAvatar() {
    return Center(
      child: Container(
        width: _getAvatarSize(),
        height: _getAvatarSize(),
        decoration: const ShapeDecoration(
          color: Color(0xFFC4C4C4),
          shape: OvalBorder(),
        ),
      ),
    );
  }

  double _getAvatarSize() {
    return height(context) * 48 / 814 > width(context) * 48 / 1440
        ? width(context) * 48 / 1440
        : height(context) * 48 / 814;
  }

  Text _buildTitle() {
    return Text(
      'Create an account',
      textAlign: TextAlign.center,
      style: authHeadingStyle.copyWith(
        fontSize: height(context) * 32 / 814 > width(context) * 32 / 1440
            ? width(context) * 32 / 1440
            : height(context) * 32 / 814,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: .24.h, horizontal: .139.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LoginPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Already have an account?  ',
                    style: authTextStyle.copyWith(
                      fontSize: _getFontSize(16),
                    ),
                  ),
                  TextSpan(
                    text: 'Log in  ',
                    style: authTextStyle.copyWith(
                      decoration: TextDecoration.underline,
                      fontSize: _getFontSize(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getFontSize(double baseSize) {
    return height(context) * baseSize / 814 > width(context) * baseSize / 1440
        ? width(context) * baseSize / 1440
        : height(context) * baseSize / 814;
  }

  Widget _buildLoginPlatforms() {
    return GestureDetector(
      onTap: _signInWithGoogle,
      child: Container(
        width: 42.24.w,
        height: 8.33.h,
        decoration: BoxDecoration(
          color: lightBackgroundColor,
          border: Border.all(
            color: const Color(0xFF333333),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(90),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 15 / 840),
              child: Image.asset("lib/assets/images/google.png"),
            ),
            Text(
              "Sign Up With Google",
              style: authTextStyle.copyWith(
                fontSize: _getFontSize(16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSingleDivider(),
          SizedBox(width: width(context) * 24 / 1240),
          Text(
            "Or",
            style: authTextStyle.copyWith(fontSize: height(context) * 16 / 840),
          ),
          SizedBox(width: width(context) * 24 / 1240),
          _buildSingleDivider(),
        ],
      ),
    );
  }

  SizedBox _buildSingleDivider() {
    return SizedBox(
      width: width(context) * 224.5 / 1240,
      child: Divider(
        height: height(context) * 2 / 840,
      ),
    );
  }

  Widget _buildCredentialsText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Enter your credentials to ',
            style: authTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height * 16 / 840,
            ),
          ),
          TextSpan(
            text: 'create an account.',
            style: authTextStyle.copyWith(
              decoration: TextDecoration.underline,
              fontSize: MediaQuery.of(context).size.height * 16 / 840,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAuthFields() {
    return Column(
      children: [
        _buildFieldTitle("Your Email"),
        SizedBox(height: MediaQuery.of(context).size.height * 6 / 840),
        _buildEmailField(),
        SizedBox(height: MediaQuery.of(context).size.height * 16 / 840),
        _buildFieldTitle("Your Password"),
        SizedBox(height: MediaQuery.of(context).size.height * 6 / 840),
        _buildPasswordField(),
      ],
    );
  }

  SizedBox _buildFieldTitle(String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 528 / 1240,
      child: Text(
        title,
        style: authTextStyle.copyWith(
          fontSize: MediaQuery.of(context).size.height * 16 / 840,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  SizedBox _buildEmailField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 528 / 1240,
      height: MediaQuery.of(context).size.height * 56 / 840,
      child: TextFormField(
        onChanged: (_) => _updateFieldFilledState(),
        controller: _emailController,
        decoration: textFieldDecoration,
      ),
    );
  }

  SizedBox _buildPasswordField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 528 / 1240,
      height: MediaQuery.of(context).size.height * 56 / 840,
      child: TextFormField(
        onChanged: (_) => _updateFieldFilledState(),
        controller: _passwordController,
        decoration: textFieldDecoration.copyWith(
          suffixIcon: IconButton(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              size: MediaQuery.of(context).size.height * 20 / 840,
            ),
            onPressed: () {
              setState(() {
                obscure = !obscure;
              });
            },
          ),
        ),
        obscureText: obscure,
      ),
    );
  }

  void _updateFieldFilledState() {
    setState(() {
      fieldFilled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Widget _buildCreateAccountButton() {
    return GestureDetector(
      onTap: () {
        _createUser(_emailController.text, _passwordController.text);
      },
      child: Container(
        width: 42.58.w,
        height: 7.62.h,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color:
              fieldFilled ? const Color(0xFF111111) : const Color(0x40111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Create an account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: lightTextColor,
                fontSize: _getFontSize(22),
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
