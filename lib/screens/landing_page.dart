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
    return Container(
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
    );
  }

  // Header widget
  Widget buildHeader() {
    return Center(
      child: Row(
        children: [
          const SizedBox(
            width: 35,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundColor,
        child: Column(
          children: [
            // Space Above Header
            SizedBox(
              height: height(context) * 0.015,
            ),
            buildHeader(),
          ],
        ),
      ),
    );
  }
}
