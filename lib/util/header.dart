import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/screens/account_page.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';
import 'package:internhs/screens/opportunities_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
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
        width: 9.w,
        height: 6.h,
        padding: EdgeInsets.symmetric(horizontal: 1.66.w, vertical: 1.7.h),
        decoration: ShapeDecoration(
          color: darkAccent,
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
        child: Center(
          child: AutoSizeText(
            'Login',
            maxLines: 1,
            minFontSize: 0,
            style: lightButtonTextStyle.copyWith(
              fontSize: height(context) * 12 / 814,
            ),
          ),
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
        width: 9.w,
        height: 6.h,
        padding: EdgeInsets.symmetric(horizontal: 1.66.w, vertical: 1.7.h),
        decoration: ShapeDecoration(
          color: darkAccent,
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
        child: Center(
          child: AutoSizeText(
            'Account',
            maxLines: 1,
            minFontSize: 0,
            style: lightButtonTextStyle.copyWith(
              fontSize: height(context) * 12 / 814,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Function to create styled text widgets
    Widget text(String text) {
      return AutoSizeText(
        text,
        minFontSize: 0,
        maxLines: 1,
        style: lightHeaderTextStyle.copyWith(
            fontSize: height(context) * 18 / 814 > width(context) * 18 / 1440
                ? width(context) * 18 / 1440
                : height(context) * 18 / 814),
      );
    }

    return LayoutBuilder(builder: (context, _) {
      return Center(
        child: Row(
          children: [
            SizedBox(width: 5.w),
            Material(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: Container(
                height: 13.22.h,
                width: 93.75.w,
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
                      padding:
                          EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                      child: Image.asset(
                        'lib/assets/images/internhs-header.png',
                        height: 13.22.h,
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
                                LandingAgent(index: 0),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: text("Home"),
                    ),
                    SizedBox(width: 5.w),
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
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                LandingAgent(index: 1),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: text("Pricing"),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                LandingAgent(index: 2),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: text("Our Story"),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                LandingAgent(index: 3),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: text("Contact Us"),
                    ),
                    SizedBox(width: 5.w),
                    _auth.currentUser != null
                        ? buildAccountButton()
                        : buildLoginButton(),
                    SizedBox(width: 5.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
