import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
              ],
            ),
          ),
          const SizedBox(
            width: 35,
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
            const SizedBox(
              height: 19,
            ),
            buildHeader(),
          ],
        ),
      ),
    );
  }
}
