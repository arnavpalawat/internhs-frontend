import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/screens/authentication_flow/sign_up_screen.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../opportunities_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      if (_authInstance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OpportunitiesPage(),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _loginUser(String email, String password) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_authInstance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OpportunitiesPage(),
          ),
        );
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
                    height: 89.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: authBoxDecorations,
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildAvatar(),
                        _buildTitle(),
                        SizedBox(height: .94.h),
                        _buildSignUpLink(),
                        SizedBox(height: .47.h),
                        GestureDetector(
                            onTap: _signInWithGoogle,
                            child: _buildLoginPlatforms()),
                        SizedBox(height: height(context) * 55 / 840),
                        _buildDivider(),
                        SizedBox(height: height(context) * 40 / 840),
                        _buildCredentialsText(),
                        SizedBox(height: height(context) * 16 / 840),
                        _buildAuthFields(),
                        SizedBox(height: height(context) * 16 / 840),
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
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LandingAgent(),
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
      'Log into an account',
      textAlign: TextAlign.center,
      style: authHeadingStyle.copyWith(
        fontSize: height(context) * 32 / 814 > width(context) * 32 / 1440
            ? width(context) * 32 / 1440
            : height(context) * 32 / 814,
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: .24.h, horizontal: .139.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const SignUpPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Need an account?  ',
                    style: authTextStyle.copyWith(
                      fontSize: _getFontSize(16),
                    ),
                  ),
                  TextSpan(
                    text: 'Sign Up  ',
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
    return Container(
      width: 42.24.w,
      height: 8.33.h,
      decoration: BoxDecoration(
        color: lightTextColor,
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: const BorderRadius.all(Radius.circular(90)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(1.04.w, 1.78.h, 1.04.w, 1.78.h),
            child: Image.asset("lib/assets/images/google.png"),
          ),
          Text(
            "Login With Google",
            style: authTextStyle.copyWith(
              fontSize: _getFontSize(16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
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
      child: Divider(height: height(context) * 2 / 840),
    );
  }

  Widget _buildCredentialsText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Enter your credentials to ',
            style: authTextStyle.copyWith(fontSize: height(context) * 16 / 840),
          ),
          TextSpan(
            text: 'log into an account.',
            style: authTextStyle.copyWith(
              decoration: TextDecoration.underline,
              fontSize: height(context) * 16 / 840,
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
        SizedBox(height: height(context) * 6 / 840),
        _buildEmailField(),
        SizedBox(height: height(context) * 16 / 840),
        _buildFieldTitle("Your Password"),
        SizedBox(height: height(context) * 6 / 840),
        _buildPasswordField(),
      ],
    );
  }

  SizedBox _buildFieldTitle(String title) {
    return SizedBox(
      width: width(context) * 528 / 1240,
      child: Text(
        title,
        style: authTextStyle.copyWith(fontSize: height(context) * 16 / 840),
        textAlign: TextAlign.start,
      ),
    );
  }

  SizedBox _buildEmailField() {
    return SizedBox(
      width: width(context) * 528 / 1240,
      height: height(context) * 56 / 840,
      child: TextFormField(
        onChanged: (_) => _updateFieldFilledState(),
        controller: _emailController,
        decoration: textFieldDecoration,
      ),
    );
  }

  SizedBox _buildPasswordField() {
    return SizedBox(
      width: width(context) * 528 / 1240,
      height: height(context) * 56 / 840,
      child: TextFormField(
        onChanged: (_) => _updateFieldFilledState(),
        controller: _passwordController,
        decoration: textFieldDecoration.copyWith(
          suffixIcon: IconButton(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
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
      onTap: () => _loginUser(_emailController.text, _passwordController.text),
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
              'Log into an account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: lightBackgroundColor,
                fontSize: _getFontSize(22),
                fontFamily: 'Poppins',
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
