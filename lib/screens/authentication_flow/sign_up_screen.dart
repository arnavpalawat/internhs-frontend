import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/firebase/user.dart' as db;
import 'package:internhs/util/loading.dart';
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

  // Method to sign in with Google
  Future<void> _signInWithGoogle() async {
    try {
      final userCredential =
          await _authInstance.signInWithPopup(GoogleAuthProvider());
      if (userCredential.user != null) {
        await _addUserToFirestore(userCredential.user!);
        _navigateToOpportunitiesPage();
      } else {
        _showErrorDialog("No user is signed in.");
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  // Method to create a new user
  Future<void> _createUser(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      final userCredential = await _authInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        await _addUserToFirestore(userCredential.user!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        ).whenComplete(
          () => setState(
            () {
              isLoading = false;
            },
          ),
        );
        if (kDebugMode) {
          print(
              "Sign Up Successful: User created with email $email and password $password");
        }
      }
    } catch (e) {
      _showErrorDialog(e.toString());
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  // Method to add user to Firestore
  Future<void> _addUserToFirestore(User user) async {
    final dbUser = db.User(email: user.email!, uid: user.uid);
    await dbUser.addToFirestore();
  }

  // Method to navigate to Opportunities Page
  void _navigateToOpportunitiesPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OpportunitiesPage(),
      ),
    );
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, _) {
        return Stack(
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        );
      }),
    );
  }

  // Widget for the background
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

  // Widget for the main content
  Widget _buildContent() {
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
        ).animate().fade(duration: const Duration(milliseconds: 1000)).slideY(
              begin: 0.25,
              end: 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.ease,
            ),
      ],
    );
  }

  // Widget for the header
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
            onPressed: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const LoginPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            ),
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

  // Widget for the avatar
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

  // Method to get avatar size
  double _getAvatarSize() {
    return height(context) * 48 / 814 > width(context) * 48 / 1440
        ? width(context) * 48 / 1440
        : height(context) * 48 / 814;
  }

  // Widget for the title
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

  // Widget for the login link
  Widget _buildLoginLink() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: .24.h, horizontal: .139.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const LoginPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            ),
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

  // Method to get font size
  double _getFontSize(double baseSize) {
    return height(context) * baseSize / 814 > width(context) * baseSize / 1440
        ? width(context) * baseSize / 1440
        : height(context) * baseSize / 814;
  }

  // Widget for the login platforms
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

  // Widget for the divider
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

  // Widget for a single divider
  SizedBox _buildSingleDivider() {
    return SizedBox(
      width: width(context) * 224.5 / 1240,
      child: Divider(
        height: height(context) * 2 / 840,
      ),
    );
  }

  // Widget for the credentials text
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

  // Widget for the authentication fields
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

  // Widget for the field title
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

  // Widget for the email field
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

  // Widget for the password field
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

  // Method to update the state of fieldFilled
  void _updateFieldFilledState() {
    setState(() {
      fieldFilled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  // Widget for the create account button
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
