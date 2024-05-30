import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/screens/authentication_flow/login_screen.dart';
import 'package:internhs/screens/authentication_flow/sign_up_screen.dart';

import '../util/header.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  bool hovering = false;
  late AnimationController _controllerGS;
  late Animation<double> _animationGS;

  @override
  void initState() {
    super.initState();
    // Initialize Animate controller
    _controllerGS = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationGS = CurvedAnimation(
      parent: _controllerGS,
      curve: Curves.easeInOut,
    ).drive(Tween<double>(begin: 0, end: 45));

    _controllerGS.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controllerGS.dispose();
    super.dispose();
  }

  void _onGSHover(PointerEvent details) {
    _controllerGS.forward();
    hovering = true;
  }

  void _onGSExit(PointerEvent details) {
    hovering = false;
    _controllerGS.reverse();
  }

  // Login Button
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

  // Announcement Widget
  Widget buildAnnouncement() {
    return SizedBox(
      width: width(context) * 0.88,
      height: height(context) * 0.59,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Establishing teens \n',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),
            // Italic
            TextSpan(
              text: 'initiative ',
              style: italicAnnouncementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),
            TextSpan(
              text: 'into competitive \n',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),
            TextSpan(
              text: 'workplaces, one',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),
            // Italic
            TextSpan(
              text: ' internship\n',
              style: italicAnnouncementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),
            TextSpan(
              text: 'at a time',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),
          ],
        ),
      ),
    );
  }

  // Body text
  Widget buildBodyText() {
    return SizedBox(
      width: width(context) * 0.88,
      height: height(context) * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Through robust AI recommendation algorithms, and \n',
            style: bodyTextStyle.copyWith(fontSize: height(context) * 24 / 840),
            textAlign: TextAlign.left,
          ),
          Text(
            'tailored recommendations. We guide the next generation \n',
            style: bodyTextStyle.copyWith(fontSize: height(context) * 24 / 840),
            textAlign: TextAlign.left,
          ),
          Text(
            'of employees as early as high school.',
            style: bodyTextStyle.copyWith(fontSize: height(context) * 24 / 840),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget buildButton(Color color, String text) {
    // Post animation Icon
    Widget buildIcon({required double size}) {
      return SizedBox(
        width: size, // Adjust the width to accommodate the icon
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: size,
          ),
        ),
      );
    }

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
                  borderRadius: BorderRadius.circular(8)),
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
                Center(
                  child: Text(
                    text,
                    style: buttonTextStyle.copyWith(
                        fontSize: height(context) * 25 / 840),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(), // Adjust the space between text and icon
                text == "Get Started"
                    ? AnimatedOpacity(
                        opacity: hovering ? 1 : 0,
                        duration: 200.ms,
                        child: _animationGS.value > 0
                            ? buildIcon(
                                    size: _animationGS.value > 10 ? 25.0 : 0.0)
                                .animate()
                                .fadeIn()
                            : Container(
                                width: 0,
                              ),
                      )
                    : Container(
                        width: 0,
                      ),
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
        height: double.infinity,
        decoration: backgroundColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                left: width(context) * 0.45,
                top: height(context) * 0.3,
                child: Image.asset(
                  "lib/assets/images/landing-vector.png",
                  scale: 0.75,
                ),
              ),
              Column(
                children: [
                  // Space Above Header
                  SizedBox(
                    height: height(context) * 0.015,
                  ),
                  BuildHeader(
                    button: buildLoginButton(),
                  ),
                  // Space Below Header
                  SizedBox(
                    height: height(context) * 0.015,
                  ),
                  Column(
                    children: [
                      buildAnnouncement(),
                      buildBodyText(),
                      SizedBox(
                        height: height(context) * 0.015,
                      ),
                      // Build Buttons
                      SizedBox(
                        width: width(context) * 0.88,
                        child: Row(
                          children: [
                            GestureDetector(
                              child: buildButton(accentColor, "Get Started"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const SignUpPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: width(context) * 0.01,
                            ),
                            // TODO: Go to our story
                            GestureDetector(
                                child: buildButton(headerColor, "Our Story"))
                          ],
                        ),
                      )
                    ],
                  )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 1000))
                      .slideY(
                          begin: 0.25,
                          end: 0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.ease),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
