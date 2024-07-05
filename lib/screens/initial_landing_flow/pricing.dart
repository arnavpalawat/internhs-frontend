import 'dart:js' as js;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/colors.dart';
import '../../constants/device.dart';
import '../../constants/text.dart';

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightBackgroundColor,
      height: 100.h,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                          child: AutoSizeText(
                            "Pricing",
                            minFontSize: 0,
                            style: italicAnnouncementTextStyle.copyWith(
                                fontSize: height(context) * 36 / 814),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        child: AutoSizeText(
                          "Donate to InternHS",
                          minFontSize: 0,
                          style: announcementTextStyle.copyWith(
                              fontSize: height(context) * 48 / 814),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.w, 1.04.h, 5.89.w, 1.38.h),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 2.5.h),
                      SizedBox(
                        width: 35.w,
                        child: AutoSizeText(
                          "Free Forever!",
                          minFontSize: 0,
                          style: blackBodyTextStyle.copyWith(
                              fontSize: height(context) * 24 / 814,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(5.89.w, 1.04.h, 5.89.w, 3.33.h),
                        child: SizedBox(
                          width: 85.w,
                          child: AutoSizeText(
                            "InternHS runs exclusively on donations from our ecstatic users. \n We urge that if InternHS helped you get the internship of your dream in High school \n that you donate: We accept donations via both Cashapp and Venmo through the below links",
                            maxLines: 3,
                            minFontSize: 0,
                            style: blackBodyTextStyle.copyWith(
                                height: 1.5,
                                fontSize: height(context) * 20 / 814),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.5.h,
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                js.context.callMethod(
                                  'open',
                                  ["https://cash.app/\$arnavpalawat"],
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30.h,
                                    width: 17.5.w,
                                    decoration: const BoxDecoration(
                                      color: lightBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          1.4.w, 2.25.h, 1.4.w, 2.25.h),
                                      child: Image.asset(
                                          "lib/assets/images/cashapp.png"),
                                    ),
                                  ),
                                  AutoSizeText(
                                    "Cashapp",
                                    minFontSize: 0,
                                    style: darkHeaderTextStyle.copyWith(
                                        fontSize: height(context) * 25 / 814),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                js.context.callMethod('open',
                                    ["https://www.venmo.com/u/arnavpalawat"]);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 30.h,
                                    width: 17.5.w,
                                    decoration: const BoxDecoration(
                                      color: lightBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          1.4.w, 2.25.h, 1.4.w, 2.25.h),
                                      child: Image.asset(
                                          "lib/assets/images/venmo.png"),
                                    ),
                                  ),
                                  AutoSizeText(
                                    "Venmo",
                                    minFontSize: 0,
                                    style: darkHeaderTextStyle.copyWith(
                                        fontSize: height(context) * 25 / 814),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fade(
                        duration: const Duration(milliseconds: 1000),
                      )
                      .slideX(
                          begin: -0.25,
                          end: 0,
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.ease),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
