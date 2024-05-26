import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/firebase/user.dart' as db;
import 'package:internhs/screens/landing_page.dart';

import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  // Controllers
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // Outside Build to update the state
  bool fieldFilled = false;
  bool obscure = true;
  late User currentUser;

  /// Sign in Methods

  // Google
  Future<void> _signInWithGoogle() async {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      UserCredential userCredential =
          await _authInstance.signInWithPopup(authProvider);

      // Add user details to Firestore
      User? currentUser = userCredential.user;
      if (currentUser != null) {
        db.User user = db.User(
          email: currentUser.email!,
          uid: currentUser.uid,
        );
        await user.addToFirestore();
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

  // Email and Password
  Future<void> _createUser(String email, String password) async {
    try {
      // Check if a user with the given email already exists
      var existingUser = await _authInstance.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        if (kDebugMode) {
          print("User with email $email already exists.");
        }
        // Handle the case where the user already exists
        return;
      }

      // Create user with email and password
      UserCredential userCredential = await _authInstance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .whenComplete(() {
        // Add user details to Firestore
        db.User user = db.User(
          email: email,
          uid: _authInstance.currentUser!.uid,
        );
        user.addToFirestore();
      });

      if (kDebugMode) {
        print(
            "Sign Up Successful: User created with email $email and password $password");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      // Handle any errors that occur during the user creation process
    }
  }

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

  @override
  Widget build(BuildContext context) {
    /// Social Media Button
    Widget buildLoginPlatforms() {
      return GestureDetector(
        onTap: () {
          _signInWithGoogle();
        },
        child: Container(
          width: width(context) * 528 / 1250,
          height: height(context) * 70 / 840,
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
                padding: const EdgeInsets.all(15.0),
                child: Image.asset("lib/assets/images/google.png"),
              ),
              const Text(
                "Sign Up With Google",
                style: authTextStyle,
              )
            ],
          ),
        ),
      );
    }

    /// Create Account Button
    Widget buildCreateAccount() {
      return Container(
        width: width(context) * 528 / 1240,
        height: height(context) * 64 / 840,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color:
              fieldFilled ? const Color(0xFF111111) : const Color(0x40111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
          ],
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
              width: width(context) * 0.56,
              height: height(context) * 0.95,
              clipBehavior: Clip.antiAlias,
              decoration: authBoxDecorations,
              child: Column(
                children: [
                  /// Build Header of Signin
                  Row(
                    children: [
                      SizedBox(
                        height: height(context) * 38 / 840,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const LandingPage(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.close_outlined,
                              color: accentColor,
                            )),
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: width(context) * 48 / 1240,
                      height: width(context) * 48 / 1240,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  const Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: authHeadingStyle,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.all(2),
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
                                const TextSpan(
                                    text: 'Already have an account?  ',
                                    style: authTextStyle),
                                TextSpan(
                                  text: 'Log in  ',
                                  style: authTextStyle.copyWith(
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 40 / 840,
                  ),

                  /// Build Login with
                  buildLoginPlatforms(),
                  SizedBox(
                    height: height(context) * 55 / 840,
                  ),

                  /// Build Divider
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width(context) * 224.5 / 1240,
                          child: const Divider(
                            height: 2,
                          ),
                        ),
                        SizedBox(
                          width: width(context) * 24 / 1240,
                        ),
                        const Text(
                          "Or",
                          style: authTextStyle,
                        ),
                        SizedBox(
                          width: width(context) * 24 / 1240,
                        ),
                        SizedBox(
                          width: width(context) * 224.5 / 1240,
                          child: const Divider(
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 40 / 840,
                  ),

                  /// Build Email Signup Text
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Enter your credentials to ',
                            style: authTextStyle),
                        TextSpan(
                            text: 'create an account.',
                            style: authTextStyle.copyWith(
                                decoration: TextDecoration.underline)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height(context) * 16 / 840,
                  ),

                  /// Build authentication fields
                  Column(
                    children: [
                      SizedBox(
                        width: width(context) * 528 / 1240,
                        child: const Text(
                          "Your Email",
                          style: authTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 6 / 840,
                      ),

                      /// Email Field
                      SizedBox(
                        width: width(context) * 528 / 1240,
                        height: height(context) * 56 / 840,
                        child: TextFormField(
                          onChanged: (_) {
                            if (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              setState(() {
                                fieldFilled = true;
                              });
                            }
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              setState(() {
                                fieldFilled = false;
                              });
                            }
                          },
                          controller: _emailController,
                          decoration: textFieldDecoration,
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 16 / 840,
                      ),
                      SizedBox(
                        width: width(context) * 528 / 1240,
                        child: const Text(
                          "Your Password",
                          style: authTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      /// Password Field
                      SizedBox(
                        height: height(context) * 6 / 840,
                      ),
                      SizedBox(
                        width: width(context) * 528 / 1240,
                        height: height(context) * 56 / 840,
                        child: TextFormField(
                          onChanged: (String value) {
                            if (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              setState(() {
                                fieldFilled = true;
                              });
                            }
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              setState(() {
                                fieldFilled = false;
                              });
                            }
                          },
                          controller: _passwordController,
                          decoration: textFieldDecoration.copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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
                    height: height(context) * 16 / 840,
                  ),
                  GestureDetector(
                      onTap: () {
                        _createUser(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          // TODO: Navigate to Opportunities
                        });
                      },
                      child: buildCreateAccount()),
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
