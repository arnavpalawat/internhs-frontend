import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      color: whatWeDOBG,
      height: height(context) * 1.33,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: width(context) * 0.15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height(context) * 0.15,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Pricing",
                            style: italicAnnouncementTextStyle.copyWith(
                                fontSize: 36),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width(context) * 0.8,
                        child: Text(
                          "Donate to InternHS",
                          style: announcementTextStyle.copyWith(fontSize: 48),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 48, 20),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: height(context) * 0.025),
                      SizedBox(
                        width: width(context) * 0.35,
                        child: Text(
                          "Free Forever!",
                          style: blackBodyTextStyle.copyWith(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48, 15, 48, 48),
                        child: SizedBox(
                          width: width(context) * 0.85,
                          child: Text(
                            "InternHS runs exclusively on donations from our ecstatic users. \n We urge that if InternHS helped you get the internship of your dream in High school \n that you donate: We accept donations via both Cashapp and Venmo through the below links",
                            style: blackBodyTextStyle.copyWith(height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 0.025,
                      ),
                      SizedBox(
                        width: width(context) * 0.5,
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
                                    height: height(context) * 0.3,
                                    width: width(context) * 0.175,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          "lib/assets/images/cashapp.png"),
                                    ),
                                  ),
                                  const Text(
                                    "Cashapp",
                                    style: header2TextStyle,
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
                                    height: height(context) * 0.3,
                                    width: width(context) * 0.175,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          "lib/assets/images/venmo.png"),
                                    ),
                                  ),
                                  const Text(
                                    "Venmo",
                                    style: header2TextStyle,
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
