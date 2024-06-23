import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/text.dart';

import '../../constants/device.dart';
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

  Widget buildButton() {
    return MouseRegion(
      onEnter: _onGSHover,
      onExit: _onGSExit,
      child: Column(
        children: [
          Container(
            width: width(context) * 0.142 + _animationGS.value,
            height: height(context) * 0.065,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: ShapeDecoration(
              color: Colors.black87,
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Get Started",
                  style: buttonTextStyle,
                ),
                const Spacer(),
                hovering
                    ? AnimatedOpacity(
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
      backgroundColor: const Color(0xFFbdccea),
      body: SizedBox(
        height: height(context),
        width: width(context),
        child: Column(
          children: [
            SizedBox(height: height(context) * 0.15),
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: height(context) * 0.1,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width(context) * 0.05,
                        ),
                        SizedBox(
                          child: Image.asset(
                            "lib/assets/images/what-we-do-vector.png",
                            scale: 0.75,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width(context) * 0.15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "What We Do",
                              style: italicAnnouncementTextStyle.copyWith(
                                  fontSize: 36),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width(context) * 0.8,
                          child: Text(
                            "From interest to Innovation",
                            style: announcementTextStyle.copyWith(fontSize: 48),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 48, 20),
                          child: SizedBox(
                            width: width(context) * 0.8,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "InternHS offers a ",
                                    style: bodyTextStyle,
                                  ),
                                  TextSpan(
                                    text: "Completely Free ",
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        "AI Based Service for High School Students to \n",
                                    style: bodyTextStyle.copyWith(height: 1.5),
                                  ),
                                  TextSpan(
                                    text:
                                        "experience the workplace by finding and recommending them internships. \n",
                                    style: bodyTextStyle.copyWith(height: 1.5),
                                  ),
                                  TextSpan(
                                    text:
                                        "Allowing High School students to gain real world experience in fields that they have interest in \n",
                                    style: bodyTextStyle.copyWith(height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width(context) * 0.4,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const OpportunitiesPage(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                                child: buildButton()),
                          ],
                        ),
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
      ),
    );
  }
}
