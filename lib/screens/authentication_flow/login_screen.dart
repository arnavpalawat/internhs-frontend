import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/screens/authentication_flow/sign_up_screen.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../util/loading.dart';
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
  bool isLoading = false;

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

  // Method to handle Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      await _authInstance.signInWithPopup(authProvider).whenComplete(() =>
          _authInstance.currentUser != null
              ? _navigateToOpportunitiesPage()
              : ());
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to handle Email/Password Sign-In
  Future<void> _loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
      if (_authInstance.currentUser != null) {
        _navigateToOpportunitiesPage();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to show error dialog
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

  // Method to navigate to Opportunities Page
  void _navigateToOpportunitiesPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OpportunitiesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, _) {
        return Stack(
          children: <Widget>[
            _buildBackground(),
            _buildMainContent(),
          ],
        );
      }),
    );
  }

  // Build background widget
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

  // Build main content widget
  Widget _buildMainContent() {
    return Column(
      children: [
        SizedBox(height: 6.h),
        Center(
          child: Container(
            width: 56.w,
            height: 89.h,
            clipBehavior: Clip.antiAlias,
            decoration: authBoxDecorations,
            child: isLoading
                ? buildLoadingIndicator(context, darkBackgroundColor)
                : Column(
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
        ).animate().fade(duration: const Duration(milliseconds: 1000)).slideY(
              begin: 0.25,
              end: 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.ease,
            ),
      ],
    );
  }

  // Build header widget
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

  // Build avatar widget
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

  // Get avatar size
  double _getAvatarSize() {
    return height(context) * 48 / 814 > width(context) * 48 / 1440
        ? width(context) * 48 / 1440
        : height(context) * 48 / 814;
  }

  // Build title widget
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

  // Build sign up link widget
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
                    style: authTextStyle.copyWith(fontSize: _getFontSize(16)),
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

  // Get font size based on context dimensions
  double _getFontSize(double baseSize) {
    return height(context) * baseSize / 814 > width(context) * baseSize / 1440
        ? width(context) * baseSize / 1440
        : height(context) * baseSize / 814;
  }

  // Build login platforms widget
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
            style: authTextStyle.copyWith(fontSize: _getFontSize(16)),
          )
        ],
      ),
    );
  }

  // Build divider widget
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

  // Build single divider widget
  SizedBox _buildSingleDivider() {
    return SizedBox(
      width: width(context) * 224.5 / 1240,
      child: Divider(height: height(context) * 2 / 840),
    );
  }

  // Build credentials text widget
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

  // Build authentication fields widget
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

  // Build field title widget
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

  // Build email field widget
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

  // Build password field widget
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

  // Update field filled state
  void _updateFieldFilledState() {
    setState(() {
      fieldFilled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  // Build create account button widget
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
