import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/colors.dart';
import '../../constants/device.dart';

// Main 'OurStoryPage' StatefulWidget
class OurStoryPage extends StatefulWidget {
  const OurStoryPage({super.key});

  @override
  State<OurStoryPage> createState() => _OurStoryPageState();
}

// State class for 'OurStoryPage'
class _OurStoryPageState extends State<OurStoryPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: darkBackgroundColor,
        height: 100.h,
        child: Column(
          children: [
            const OurStoryHeader(),
            const OurStoryContent(),
          ],
        ),
      );
    });
  }
}

// Widget for the header part of 'OurStoryPage'
class OurStoryHeader extends StatelessWidget {
  const OurStoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 15.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                const HeaderTitle(),
                const SubTitle(),
              ],
            )
          ],
        ),
      ],
    );
  }
}

// Widget for the main title in the header
class HeaderTitle extends StatelessWidget {
  const HeaderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
      child: AutoSizeText(
        "Our Story",
        minFontSize: 0,
        maxLines: 1,
        style: italicAnnouncementTextStyle.copyWith(
          fontSize: height(context) * 36 / 814,
        ),
      ),
    );
  }
}

// Widget for the subtitle in the header
class SubTitle extends StatelessWidget {
  const SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: AutoSizeText(
        "Why did I Build InternHS",
        minFontSize: 0,
        maxLines: 1,
        style: announcementTextStyle.copyWith(
          fontSize: height(context) * 48 / 814,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

// Widget for the content part of 'OurStoryPage'
class OurStoryContent extends StatelessWidget {
  const OurStoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.w, 1.04.h, 5.89.w, 1.38.h),
      child: Center(
        child: Column(
          children: [
            const FounderImage(),
            SizedBox(height: 2.5.h),
            const FounderName(),
            const StoryDescription(),
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
              curve: Curves.ease,
            ),
      ),
    );
  }
}

// Widget for the founder image
class FounderImage extends StatelessWidget {
  const FounderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.5.h,
      child: Image.asset("lib/assets/images/arnav_linkedin.png"),
    );
  }
}

// Widget for the founder's name
class FounderName extends StatelessWidget {
  const FounderName({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35.w,
      child: AutoSizeText(
        "Arnav Palawat || Founder of InternHS",
        minFontSize: 0,
        maxLines: 1,
        style: blackBodyTextStyle.copyWith(
          fontSize: height(context) * 24 / 814,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Widget for the story description
class StoryDescription extends StatelessWidget {
  const StoryDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.89.w, 1.04.h, 5.89.w, 3.33.h),
      child: SizedBox(
        width: 85.w,
        child: AutoSizeText(
          "I founded InternHS upon recalling countless hours spent scouring platforms like Indeed.com and LinkedIn in pursuit of internships tailored for high school students, only to encounter the discouraging phrase \"Currently Enrolled in an Undergraduate Program.\" After investing numerous hours in this quest, I came to the profound realization that this was a pervasive challenge in need of a solution. Motivated by the belief that I could make a meaningful difference, I embarked on creating InternHS. My vision was clear: to empower fellow high schoolers facing similar hurdles, offering them opportunities and support in navigating the professional landscape.",
          minFontSize: 0,
          maxLines: 7,
          style: blackBodyTextStyle.copyWith(
            height: 1.5,
            fontSize: height(context) * 20 / 814,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
