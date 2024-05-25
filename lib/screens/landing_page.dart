import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';

import '../header.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Login Button
  Widget buildLoginButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Go to Login Screen
      },
      child: Container(
        width: width(context) * 0.09,
        height: height(context) * 0.06,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: ShapeDecoration(
          color: accentColor2,
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: whiteButtonTextStyle,
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
              text: 'Establishing teens with\n',
              style: announcementTextStyle.copyWith(
                  fontSize: height(context) * 0.095),
            ),

            /// Italic
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

            /// Italic
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Through robust AI recommendation algorithms, and \n',
            style: bodyTextStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            'tailored recommendations. We guide the next generation \n',
            style: bodyTextStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            'of employees as early as high school.',
            style: bodyTextStyle,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  // Button Template
  Widget buildButton(Color color, String text) {
    return Column(
      children: [
        Container(
          width: width(context) * 0.16,
          height: height(context) * 0.089,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: ShapeDecoration(
            color: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              Text(text, style: buttonTextStyle),
            ],
          ),
        ),
      ],
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
                            // TODO: Go to sign up
                            GestureDetector(
                                child: buildButton(accentColor, "Get Started")),
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
                      .fade(duration: Duration(milliseconds: 800))
                      .slideY(
                          begin: 0.5,
                          end: 0,
                          duration: Duration(milliseconds: 400),
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
