import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';

import 'constants/colors.dart';
import 'constants/device.dart';
import 'constants/text.dart';

class BuildHeader extends StatefulWidget {
  final Widget button;
  const BuildHeader({super.key, required this.button});

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  @override
  Widget build(BuildContext context) {
    Widget text(String text) {
      return GradientAnimationText(
        text: Text(
          text,
          style: headerTextStyle.copyWith(fontSize: height(context) * 0.03),
        ),
        colors: headerTextColors,
        duration: const Duration(seconds: 12),
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
                text("Home"),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                text("Our Story"),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                text("Opportunities"),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                text("Pricing"),
                SizedBox(
                  width: width(context) * 0.05,
                ),
                widget.button,
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
