import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internhs/screens/account_page.dart';
import 'package:internhs/screens/landing_page.dart';
import 'package:internhs/screens/opportunities_page.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../constants/text.dart';
import '../screens/authentication_flow/login_screen.dart';

class BuildHeader extends StatefulWidget {
  const BuildHeader({super.key});

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Widget buildLoginButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to login screen
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        width: width(context) * 0.09,
        height: height(context) * 0.06,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: ShapeDecoration(
          color: accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: whiteButtonTextStyle.copyWith(
                  fontSize: height(context) * 16 / 840),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccountButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to account screen
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const AccountPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        width: width(context) * 0.09,
        height: height(context) * 0.06,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: ShapeDecoration(
          color: accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Account',
              style: whiteButtonTextStyle.copyWith(
                  fontSize: height(context) * 16 / 840),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Function to create styled text widgets
    Widget text(String text) {
      return Text(
        text,
        style: headerTextStyle.copyWith(fontSize: height(context) * 0.03),
      );
    }

    return Center(
      child: Row(
        children: [
          SizedBox(
            width: width(context) * 0.05,
          ),
          Container(
            height: height(context) * 0.1322,
            width: width(context) * 0.9375,
            decoration: ShapeDecoration(
              color: headerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
            ),
            // Header items
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'lib/assets/images/internhs-header.png',
                    height: height(context) * 0.1322,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Navigate to LandingPage
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const LandingPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: text("Home"),
                ),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                text("Our Story"),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to OpportunitiesPage
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const OpportunitiesPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: text("Opportunities"),
                ),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                text("Pricing"),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                _auth.currentUser != null
                    ? buildAccountButton()
                    : buildLoginButton(),
                SizedBox(
                  width: width(context) * 0.05,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
