import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/screens/authentication_flow/sign_up_screen.dart';
import 'package:internhs/screens/opportunities_page.dart';

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
    ).drive(Tween<double>(begin: 0, end: 45));

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
      width: width(context) * 0.88,
      height: height(context) * 0.59,
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Establishing teens \n',
              style: announcementTextStyle,
            ),
            TextSpan(
              text: 'initiative ',
              style: italicAnnouncementTextStyle,
            ),
            TextSpan(
              text: 'into competitive \n',
              style: announcementTextStyle,
            ),
            TextSpan(
              text: 'workplaces, one ',
              style: announcementTextStyle,
            ),
            TextSpan(
              text: 'internship\n',
              style: italicAnnouncementTextStyle,
            ),
            TextSpan(
              text: 'at a time',
              style: announcementTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBodyText() {
    return SizedBox(
      width: width(context) * 0.88,
      height: height(context) * 0.1,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Through robust AI recommendation algorithms, and \n',
            style: bodyTextStyle,
          ),
          Text(
            'tailored recommendations. We guide the next generation \n',
            style: bodyTextStyle,
          ),
          Text(
            'of employees as early as high school.',
            style: bodyTextStyle,
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
            width: width(context) * 0.144 +
                (text == "Get Started" ? _animationGS.value : 0),
            height: height(context) * 0.089,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
                Text(
                  text,
                  style: buttonTextStyle,
                ),
                const Spacer(),
                if (text == "Get Started")
                  AnimatedOpacity(
                    opacity: hovering ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: _animationGS.value > 0
                        ? Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: _animationGS.value > 10 ? 25.0 : 0.0,
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
        width: width(context),
        height: height(context),
        child: Column(
          children: [
            SizedBox(height: height(context) * 0.115),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Stack(
                children: [
                  Positioned(
                    left: width(context) * 0.4,
                    top: height(context) * 0.15,
                    child: Image.asset(
                      "lib/assets/images/landing-vector.png",
                      scale: 0.75,
                    ),
                  ),
                  Column(
                    children: [
                      buildAnnouncement(),
                      buildBodyText(),
                      SizedBox(height: height(context) * 0.015),
                      SizedBox(
                        width: width(context) * 0.88,
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
                              child: buildButton(accentColor, "Get Started"),
                            ),
                            SizedBox(width: width(context) * 0.01),
                            GestureDetector(
                              onTap: () {
                                widget.pageController.animateToPage(
                                  1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOutCubicEmphasized,
                                );
                              },
                              child: buildButton(headerColor, "Our Story"),
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
