import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/screens/authentication_flow/sign_up_screen.dart';
import 'package:internhs/screens/opportunities_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LandingPage extends StatefulWidget {
  final PageController pageController;

  LandingPage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controllerGS;
  late Animation<double> _animationGS;
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    _controllerGS = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationGS = CurvedAnimation(
      parent: _controllerGS,
      curve: Curves.easeInOut,
    ).drive(Tween<double>(begin: 0.w, end: 1.75.w));

    _controllerGS.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controllerGS.dispose();
    super.dispose();
  }

  void _onGSHover(PointerEvent details) {
    _controllerGS.forward();
    setState(() {
      hovering = true;
    });
  }

  void _onGSExit(PointerEvent details) {
    _controllerGS.reverse();
    setState(() {
      hovering = false;
    });
  }

  Widget buildAnnouncement() {
    return SizedBox(
      width: 88.w,
      height: 57.h,
      child: RichText(
        maxLines: 4,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Establishing teens \n',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 80 / 814),
            ),
            TextSpan(
              text: 'initiative ',
              style: italicAnnouncementTextStyle.copyWith(
                  fontSize: height(context) * 80 / 814),
            ),
            TextSpan(
              text: 'into competitive \n',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 80 / 814),
            ),
            TextSpan(
              text: 'workplaces, one ',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 80 / 814),
            ),
            TextSpan(
              text: 'internship\n',
              style: italicAnnouncementTextStyle.copyWith(
                  fontSize: height(context) * 80 / 814),
            ),
            TextSpan(
              text: 'at a time',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 80 / 814),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBodyText() {
    return SizedBox(
      width: 88.w,
      height: 14.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Through robust AI recommendation algorithms, and \ntailored recommendations. We guide the next generation \nof employees as early as high school.',
            minFontSize: 0,
            style: announcementBodyTextStyle.copyWith(
                fontSize: height(context) * 24 / 814),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget buildButton(Color color, String text) {
    return MouseRegion(
      onEnter: text == "Get Started" ? _onGSHover : null,
      onExit: text == "Get Started" ? _onGSExit : null,
      child: Column(
        children: [
          Container(
            width: 14.4.w + (text == "Get Started" ? _animationGS.value : 0),
            height: 8.9.h,
            padding: EdgeInsets.symmetric(
              horizontal: 1.66.w,
              vertical: 1.93.h,
            ),
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360),
              ),
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
                AutoSizeText(
                  text,
                  minFontSize: 0,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: lightButtonTextStyle.copyWith(
                    fontSize:
                        height(context) * 24 / 814 > width(context) * 24 / 1440
                            ? width(context) * 24 / 1440
                            : height(context) * 24 / 814,
                  ),
                ),
                const Spacer(),
                if (text == "Get Started")
                  AnimatedOpacity(
                    opacity: hovering ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: _animationGS.value > 0
                        ? Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: lightBackgroundColor,
                            size: _animationGS.value > 10
                                ? height(context) * 24 / 814 >
                                        width(context) * 24 / 1440
                                    ? width(context) * 24 / 1440
                                    : height(context) * 24 / 814
                                : 0.0,
                          )
                        : Container(width: 0),
                  )
                else
                  Container(width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundColor,
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            SizedBox(
              height: 11.5.h,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
              child: Stack(
                children: [
                  Positioned(
                    left: 35.w,
                    top: 25.h,
                    width: 70.w,
                    height: 60.h,
                    child: Image.asset(
                      "lib/assets/images/landing-vector.png",
                      scale: 0.5,
                    ),
                  ),
                  Column(
                    children: [
                      buildAnnouncement(),
                      SizedBox(height: 1.h),
                      buildBodyText(),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 88.w,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) {
                                      return FirebaseAuth
                                                  .instance.currentUser ==
                                              null
                                          ? const SignUpPage()
                                          : const OpportunitiesPage();
                                    },
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: buildButton(brightAccent, "Get Started"),
                            ),
                            SizedBox(width: 1.w),
                            GestureDetector(
                              onTap: () {
                                widget.pageController.animateToPage(
                                  2,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOutCubicEmphasized,
                                );
                              },
                              child: buildButton(darkAccent, "Our Story"),
                            ),
                          ],
                        ),
                      ),
                    ],
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
            ),
          ],
        ),
      ),
    );
  }
}
