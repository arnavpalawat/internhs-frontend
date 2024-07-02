import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/firebase/user.dart' as db;
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';

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

  // Sign in with Google method
  Future<void> _signInWithGoogle() async {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      UserCredential userCredential =
          await _authInstance.signInWithPopup(authProvider);

      if (userCredential.user != null) {
        // Add user details to Firestore
        db.User user = db.User(
          email: userCredential.user!.email!,
          uid: userCredential.user!.uid,
        );
        await user.addToFirestore();

        // Navigate after successful sign-in
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OpportunitiesPage(),
          ),
        );
      } else {
        if (kDebugMode) {
          print("No user is signed in.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Create user with email and password method
  Future<void> _createUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Add user details to Firestore
        db.User user = db.User(
          email: email,
          uid: userCredential.user!.uid,
        );
        await user.addToFirestore();
      }

      // Navigate after successful sign-up
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OpportunitiesPage(),
        ),
      );

      if (kDebugMode) {
        print(
            "Sign Up Successful: User created with email $email and password $password");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating user: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Method to build login with Google button
    Widget buildLoginPlatforms() {
      return GestureDetector(
        onTap: _signInWithGoogle,
        child: Container(
          width: MediaQuery.of(context).size.width * 528 / 1250,
          height: MediaQuery.of(context).size.height * 70 / 840,
          decoration: BoxDecoration(
            color: Colors.white,
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
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 15 / 840),
                child: Image.asset("lib/assets/images/google.png"),
              ),
              Text(
                "Sign Up With Google",
                style: authTextStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 16 / 840),
              )
            ],
          ),
        ),
      );
    }

    // Method to build create account button
    Widget buildCreateAccount() {
      return GestureDetector(
        onTap: () {
          _createUser(_emailController.text, _passwordController.text);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 528 / 1240,
          height: MediaQuery.of(context).size.height * 64 / 840,
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
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.height * 22 / 840,
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

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                /// Background
                image: AssetImage("lib/assets/images/auth_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.56,
              height: MediaQuery.of(context).size.height * 0.95,
              clipBehavior: Clip.antiAlias,
              decoration: authBoxDecorations,
              child: Column(
                children: [
                  /// Header of Signin
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 38 / 840,
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 8 / 840),
                        child: IconButton(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        LandingAgent(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.close_outlined,
                            color: accentColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.height * 48 / 840,
                      height: MediaQuery.of(context).size.height * 48 / 840,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: authHeadingStyle.copyWith(
                        fontSize:
                            MediaQuery.of(context).size.height * 32 / 840),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 840),
                  Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 2 / 840),
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
                                pageBuilder:
                                    (context, animation1, animation2) =>
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
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                16 /
                                                840)),
                                TextSpan(
                                  text: 'Log in  ',
                                  style: authTextStyle.copyWith(
                                      decoration: TextDecoration.underline,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              16 /
                                              840),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 40 / 840,
                  ),

                  /// Login with Google button
                  buildLoginPlatforms(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 55 / 840,
                  ),

                  /// Divider
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width * 224.5 / 1240,
                          child: Divider(
                            height:
                                MediaQuery.of(context).size.height * 2 / 840,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 24 / 1240,
                        ),
                        Text(
                          "Or",
                          style: authTextStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height *
                                  16 /
                                  840),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 24 / 1240,
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width * 224.5 / 1240,
                          child: Divider(
                            height:
                                MediaQuery.of(context).size.height * 2 / 840,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 40 / 840,
                  ),

                  /// Enter credentials text
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: 'Enter your credentials to ',
                            style: authTextStyle.copyWith(
                                fontSize: MediaQuery.of(context).size.height *
                                    16 /
                                    840)),
                        TextSpan(
                          text: 'create an account.',
                          style: authTextStyle.copyWith(
                              decoration: TextDecoration.underline,
                              fontSize: MediaQuery.of(context).size.height *
                                  16 /
                                  840),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 16 / 840,
                  ),

                  /// Authentication fields
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 528 / 1240,
                        child: Text(
                          "Your Email",
                          style: authTextStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height *
                                  16 /
                                  840),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 6 / 840,
                      ),

                      /// Email Field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 528 / 1240,
                        height: MediaQuery.of(context).size.height * 56 / 840,
                        child: TextFormField(
                          onChanged: (_) {
                            setState(() {
                              fieldFilled = _emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty;
                            });
                          },
                          controller: _emailController,
                          decoration: textFieldDecoration,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 16 / 840,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 528 / 1240,
                        child: Text(
                          "Your Password",
                          style: authTextStyle.copyWith(
                              fontSize: MediaQuery.of(context).size.height *
                                  16 /
                                  840),
                          textAlign: TextAlign.start,
                        ),
                      ),

                      /// Password Field
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 6 / 840,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 528 / 1240,
                        height: MediaQuery.of(context).size.height * 56 / 840,
                        child: TextFormField(
                          onChanged: (_) {
                            setState(() {
                              fieldFilled = _emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty;
                            });
                          },
                          controller: _passwordController,
                          decoration: textFieldDecoration.copyWith(
                            suffixIcon: IconButton(
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: MediaQuery.of(context).size.height *
                                    20 /
                                    840,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 16 / 840,
                  ),

                  /// Create account button
                  buildCreateAccount(),
                ],
              ),
            ),
          )
              .animate()
              .fade(
                duration: const Duration(milliseconds: 1000),
              )
              .slideY(
                  begin: 0.25,
                  end: 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.ease),
        ],
      ),
    );
  }
}
