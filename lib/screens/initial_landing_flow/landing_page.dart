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

  const LandingPage({Key? key, required this.pageController}) : super(key: key);

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
    _initAnimations();
  }

  @override
  void dispose() {
    _controllerGS.dispose();
    super.dispose();
  }

  void _initAnimations() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundColor,
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            SizedBox(height: 11.5.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 1.4.w, vertical: 2.25.h),
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
                      AnnouncementText(),
                      SizedBox(height: 1.h),
                      BodyText(),
                      SizedBox(height: 2.h),
                      ButtonRow(
                        pageController: widget.pageController,
                        animationGS: _animationGS,
                        hovering: hovering,
                        onGSHover: _onGSHover,
                        onGSExit: _onGSExit,
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
                        curve: Curves.ease,
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementText extends StatelessWidget {
  const AnnouncementText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.w,
      height: 57.h,
      child: RichText(
        maxLines: 4,
        text: TextSpan(
          children: _buildTextSpans(context),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(BuildContext context) {
    double fontSize = _calculateFontSize(context);

    return [
      TextSpan(
        text: 'Establishing teens \n',
        style: announcementTextStyle.copyWith(fontSize: fontSize),
      ),
      TextSpan(
        text: 'initiative ',
        style: italicAnnouncementTextStyle.copyWith(fontSize: fontSize),
      ),
      TextSpan(
        text: 'into competitive \n',
        style: announcementTextStyle.copyWith(fontSize: fontSize),
      ),
      TextSpan(
        text: 'workplaces, one ',
        style: announcementTextStyle.copyWith(fontSize: fontSize),
      ),
      TextSpan(
        text: 'internship\n',
        style: italicAnnouncementTextStyle.copyWith(fontSize: fontSize),
      ),
      TextSpan(
        text: 'at a time',
        style: announcementTextStyle.copyWith(fontSize: fontSize),
      ),
    ];
  }

  double _calculateFontSize(BuildContext context) {
    return height(context) * 80 / 814 > width(context) * 80 / 1440
        ? width(context) * 80 / 1440
        : height(context) * 80 / 814;
  }
}

class BodyText extends StatelessWidget {
  const BodyText({super.key});

  @override
  Widget build(BuildContext context) {
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
              fontSize: height(context) * 24 / 814,
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  final PageController pageController;
  final Animation<double> animationGS;
  final bool hovering;
  final void Function(PointerEvent) onGSHover;
  final void Function(PointerEvent) onGSExit;

  const ButtonRow({
    Key? key,
    required this.pageController,
    required this.animationGS,
    required this.hovering,
    required this.onGSHover,
    required this.onGSExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88.w,
      child: Row(
        children: [
          _buildGetStartedButton(context),
          SizedBox(width: 1.w),
          _buildOurStoryButton(context),
        ],
      ),
    );
  }

  GestureDetector _buildGetStartedButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToNextPage(context),
      child: HoverButton(
        color: brightAccent,
        text: "Get Started",
        animationGS: animationGS,
        hovering: hovering,
        onGSHover: onGSHover,
        onGSExit: onGSExit,
      ),
    );
  }

  GestureDetector _buildOurStoryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, 2),
      child: HoverButton(
        color: darkAccent,
        text: "Our Story",
        animationGS: animationGS,
        hovering: hovering,
        onGSHover: onGSHover,
        onGSExit: onGSExit,
      ),
    );
  }

  void _navigateToNextPage(BuildContext context) {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return FirebaseAuth.instance.currentUser == null
                ? const SignUpPage()
                : const OpportunitiesPage();
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } catch (e) {
      // Handle navigation error
      print("Navigation error: $e");
    }
  }

  void _navigateToPage(BuildContext context, int page) {
    try {
      pageController.animateToPage(
        page,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubicEmphasized,
      );
    } catch (e) {
      // Handle page navigation error
      print("Page navigation error: $e");
    }
  }
}

class HoverButton extends StatelessWidget {
  final Color color;
  final String text;
  final Animation<double> animationGS;
  final bool hovering;
  final void Function(PointerEvent)? onGSHover;
  final void Function(PointerEvent)? onGSExit;

  const HoverButton({
    Key? key,
    required this.color,
    required this.text,
    required this.animationGS,
    required this.hovering,
    this.onGSHover,
    this.onGSExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: text == "Get Started" ? onGSHover : null,
      onExit: text == "Get Started" ? onGSExit : null,
      child: Column(
        children: [
          _buildButtonContent(context),
        ],
      ),
    );
  }

  Container _buildButtonContent(BuildContext context) {
    return Container(
      width: 14.4.w + (text == "Get Started" ? animationGS.value : 0),
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
          ),
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
              fontSize: height(context) * 24 / 814 > width(context) * 24 / 1440
                  ? width(context) * 24 / 1440
                  : height(context) * 24 / 814,
            ),
          ),
          const Spacer(),
          if (text == "Get Started")
            _buildArrowIcon(context)
          else
            Container(width: 0),
        ],
      ),
    );
  }

  AnimatedOpacity _buildArrowIcon(BuildContext context) {
    return AnimatedOpacity(
      opacity: hovering ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: animationGS.value > 0
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              color: lightBackgroundColor,
              size: animationGS.value > 10
                  ? height(context) * 24 / 814 > width(context) * 24 / 1440
                      ? width(context) * 24 / 1440
                      : height(context) * 24 / 814
                  : 0.0,
            )
          : Container(width: 0),
    );
  }
}
