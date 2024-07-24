import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/text.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> with SingleTickerProviderStateMixin {
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
    ).drive(Tween<double>(begin: 0, end: 1.04.w));

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
            width: 8.1.w + _animationGS.value,
            height: 4.5.h,
            padding: EdgeInsets.symmetric(horizontal: 1.66.w),
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  "Email Us",
                  maxLines: 1,
                  minFontSize: 0,
                  style: lightButtonTextStyle.copyWith(
                      fontSize: height(context) * 15 / 814 >
                              width(context) * 15 / 1440
                          ? width(context) * 15 / 1440
                          : height(context) * 15 / 814),
                ),
                const Spacer(),
                hovering
                    ? AnimatedOpacity(
                        opacity: hovering ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: _animationGS.value > 0
                            ? Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: lightTextColor,
                                size: _animationGS.value > 10
                                    ? height(context) * 15 / 814 >
                                            width(context) * 15 / 1440
                                        ? width(context) * 15 / 1440
                                        : height(context) * 15 / 814
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

  void sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'xyz@email.com',
      queryParameters: {
        'subject': 'Hello from Flutter!',
        'body': 'This is a test email sent from my Flutter app.',
      },
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Center(
                child: SizedBox(
                  width: 70.w,
                  child: const Divider(
                    color: darkTextColor,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(.55.w, 0.h, .55.w, .982.h),
                  child: AutoSizeText(
                    "Contact",
                    maxLines: 1,
                    minFontSize: 0,
                    style: italicAnnouncementTextStyle.copyWith(
                        fontSize: height(context) * 36 / 814 >
                                width(context) * 36 / 1440
                            ? width(context) * 36 / 1440
                            : height(context) * 36 / 814),
                  ),
                ),
              ),
              SizedBox(
                width: 80.w,
                child: AutoSizeText(
                  "Need Help? Contact InternHS @",
                  minFontSize: 0,
                  maxLines: 1,
                  style: announcementTextStyle.copyWith(
                      fontSize: height(context) * 48 / 814 >
                              width(context) * 48 / 1440
                          ? width(context) * 48 / 1440
                          : height(context) * 48 / 814),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                      child: AutoSizeText(
                        "arnavpalawat@gmail.com",
                        maxLines: 1,
                        minFontSize: 0,
                        style: italicAnnouncementTextStyle.copyWith(
                            fontSize: height(context) * 24 / 814 >
                                    width(context) * 24 / 1440
                                ? width(context) * 24 / 1440
                                : height(context) * 24 / 814),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendEmail();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                      child: buildButton(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Based In: ",
                              style: italicAnnouncementTextStyle.copyWith(
                                  fontSize: height(context) * 24 / 814 >
                                          width(context) * 24 / 1440
                                      ? width(context) * 24 / 1440
                                      : height(context) * 24 / 814),
                            ),
                            TextSpan(
                              text: "Westford, MA",
                              style: italicAnnouncementTextStyle.copyWith(
                                  fontSize: height(context) * 24 / 814 >
                                          width(context) * 24 / 1440
                                      ? width(context) * 24 / 1440
                                      : height(context) * 24 / 814,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    });
  }
}
