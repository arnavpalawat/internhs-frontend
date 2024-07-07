import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/device.dart';
import '../../util/footer.dart';
import '../opportunities_page.dart';

class WhatWeDoPage extends StatefulWidget {
  const WhatWeDoPage({super.key});

  @override
  State<WhatWeDoPage> createState() => _WhatWeDoPageState();
}

class _WhatWeDoPageState extends State<WhatWeDoPage>
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
    ).drive(Tween<double>(begin: 0, end: 3.125.w));

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

  Widget buildButton() {
    return MouseRegion(
      onEnter: _onGSHover,
      onExit: _onGSExit,
      child: Column(
        children: [
          Container(
            width: 9.2.w + _animationGS.value,
            height: 5.h,
            padding: EdgeInsets.symmetric(horizontal: .86.w),
            decoration: ShapeDecoration(
              color: darkTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  "Get Started",
                  minFontSize: 0,
                  maxLines: 1,
                  style: lightButtonTextStyle.copyWith(
                      fontSize: height(context) * 16 / 814),
                ),
                const Spacer(),
                hovering
                    ? AnimatedOpacity(
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
      backgroundColor: lightBackgroundColor,
      body: LayoutBuilder(builder: (context, _) {
        return SizedBox(
          height: height(context),
          width: width(context),
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 60.w,
                          ),
                          SizedBox(
                            child: Image.asset(
                              "lib/assets/images/what-we-do-vector.png",
                              scale: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15.h),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  1.4.w, 2.25.h, 1.4.w, 2.25.h),
                              child: AutoSizeText(
                                "What We Do",
                                maxLines: 1,
                                minFontSize: 0,
                                style: italicAnnouncementTextStyle.copyWith(
                                    fontSize: height(context) * 36 / 814),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80.w,
                            child: AutoSizeText(
                              "From interest to Innovation",
                              minFontSize: 0,
                              maxLines: 1,
                              style: announcementTextStyle.copyWith(
                                  fontSize: height(context) * 48 / 814),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 48, 20),
                            child: SizedBox(
                              width: 80.w,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "InternHS offers a ",
                                      style: announcementBodyTextStyle.copyWith(
                                          fontSize: height(context) * 24 / 814),
                                    ),
                                    TextSpan(
                                      text: "Completely Free ",
                                      style: announcementBodyTextStyle.copyWith(
                                          fontSize: height(context) * 24 / 814,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          "AI Based Service for High School \nStudents to ",
                                      style: announcementBodyTextStyle.copyWith(
                                          fontSize: height(context) * 24 / 814,
                                          height: 1.5),
                                    ),
                                    TextSpan(
                                      text:
                                          "experience the workplace by finding and recommending \nthem internships.",
                                      style: announcementBodyTextStyle.copyWith(
                                          fontSize: height(context) * 24 / 814,
                                          height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const OpportunitiesPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  child: buildButton()),
                            ],
                          ),
                          const Footer(),
                        ],
                      ),
                    ],
                  ),
                ],
              ).animate().fade(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeInOutCubicEmphasized),
            ],
          ),
        );
      }),
    );
  }
}
