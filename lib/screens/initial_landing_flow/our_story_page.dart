import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/text.dart';

import '../../constants/device.dart';

class OurStoryPage extends StatefulWidget {
  const OurStoryPage({super.key});

  @override
  State<OurStoryPage> createState() => _OurStoryPageState();
}

class _OurStoryPageState extends State<OurStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6b8dcf),
      body: Column(
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
                        "Our Story",
                        style:
                            italicAnnouncementTextStyle.copyWith(fontSize: 36),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width(context) * 0.8,
                    child: Text(
                      "Why did I Build InternHS",
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
                  SizedBox(
                    height: 200,
                    child: Image.asset("lib/assets/images/arnav_linkedin.png"),
                  ),
                  SizedBox(height: height(context) * 0.025),
                  SizedBox(
                    width: width(context) * 0.35,
                    child: Text(
                      "Arnav Palawat || Founder of InternHS",
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
                        "I founded InternHS upon recalling countless hours spent scouring platforms like Indeed.com and LinkedIn in pursuit of internships tailored for high school students, only to encounter the discouraging phrase \"Currently Enrolled in an Undergraduate Program.\" After investing numerous hours in this quest, I came to the profound realization that this was a pervasive challenge in need of a solution. Motivated by the belief that I could make a meaningful difference, I embarked on creating InternHS. My vision was clear: to empower fellow high schoolers facing similar hurdles, offering them opportunities and support in navigating the professional landscape.",
                        style: blackBodyTextStyle.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )
                  .animate()
                  .fade(
                    duration: const Duration(milliseconds: 1000),
                  )
                  .slideX(
                      begin: 0.25,
                      end: 0,
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.ease),
            ),
          ),
        ],
      ),
    );
  }
}
