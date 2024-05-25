import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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

  // TODO: Universal Header
  // Header widget
  Widget buildHeader() {
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

            /// Header items
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
                GradientText(
                  "Home",
                  colors: headerTextColors,
                  style: headerTextStyle,
                ),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                GradientText(
                  "Our Story",
                  colors: headerTextColors,
                  style: headerTextStyle,
                ),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                GradientText(
                  "Opportunities",
                  colors: headerTextColors,
                  style: headerTextStyle,
                ),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                GradientText(
                  "Pricing",
                  colors: headerTextColors,
                  style: headerTextStyle,
                ),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                buildLoginButton(),
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

  // Announcement Widget
  Widget buildAnnouncement() {
    return SizedBox(
      width: width(context) * 0.88,
      height: height(context) * 0.59,
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Establishing teens with\n',
              style: announcementTextStyle,
            ),

            /// Italic
            const TextSpan(
              text: 'initiative ',
              style: italicAnnouncementTextStyle,
            ),
            const TextSpan(
              text: 'into competitive \n',
              style: announcementTextStyle,
            ),
            const TextSpan(
              text: 'workplaces, one',
              style: announcementTextStyle,
            ),

            /// Italic
            const TextSpan(
              text: ' internship\n',
              style: italicAnnouncementTextStyle,
            ),
            TextSpan(
              text: 'at a time',
              style: announcementTextStyle.copyWith(height: 0),
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
            shadows: [
              const BoxShadow(
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
          child: Column(
            children: [
              // Space Above Header
              SizedBox(
                height: height(context) * 0.015,
              ),
              buildHeader(),
              // Space Below Header
              SizedBox(
                height: height(context) * 0.015,
              ),
              buildAnnouncement(),
              buildBodyText(),

              // Build Buttons
              Container(
                width: width(context) * 0.88,
                child: Row(
                  children: [
                    buildButton(accentColor, "Get Started"),
                    SizedBox(
                      width: width(context) * 0.01,
                    ),
                    buildButton(headerColor, "Our Story")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
