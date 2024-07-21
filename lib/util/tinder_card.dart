import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'job.dart';

class TinderCard extends StatelessWidget {
  final Job? job;

  const TinderCard(
    this.job, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Builds the stars representing job prestige
    List<Widget> buildPrestige() {
      // Calculate the number of empty stars
      num index = 5 - int.parse(job!.prestige ?? "0");
      List<Widget> output = [
        SizedBox(
          width: .5.w,
        ),
      ];

      // Add filled stars
      for (int i = 1; i <= int.parse(job!.prestige ?? "0"); i++) {
        output.add(
          Icon(
            Icons.star,
            size: height(context) * 10 / 814 > width(context) * 10 / 814
                ? width(context) * 10 / 814
                : height(context) * 10 / 814,
          ),
        );
        output.add(
          SizedBox(
            width: .5.h,
          ),
        );
      }

      // Add empty stars
      for (num i = index; i > 0; i -= 1) {
        output.add(
          Icon(
            Icons.star_border_outlined,
            size: height(context) * 10 / 814 > width(context) * 10 / 814
                ? width(context) * 10 / 814
                : height(context) * 10 / 814,
          ),
        );
        output.add(
          SizedBox(
            width: .5.w,
          ),
        );
      }
      return output;
    }

    return LayoutBuilder(builder: (context, _) {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: lightBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: darkTextColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack to overlap gradient and flag icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: headerTextColors,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(1.11.w, 1.97.h, 1.11.w, 1.97.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width(context),
                    child: Row(
                      children: [
                        AutoSizeText(
                          job!.title.toString().length > 30
                              ? "${job?.title.toString().substring(0, 25)}..."
                              : job?.title.toString() ?? "No Jobs Available",
                          maxLines: 1,
                          minFontSize: 0,
                          style: darkHeaderTextStyle.copyWith(
                              color: darkAccent,
                              fontSize: height(context) * 25 / 814 >
                                      width(context) * 25 / 1440
                                  ? width(context) * 25 / 1440
                                  : height(context) * 25 / 814),
                        ),
                        // Display bookmark icon if job is flagged
                        if (job?.flagged == null || job?.flagged == true)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  1.4.w, 2.25.h, 1.4.w, 2.25.h),
                              child: Icon(
                                Icons.bookmark,
                                color: brightAccent,
                                size: height(context) * 20 / 814 >
                                        width(context) * 20 / 1440
                                    ? width(context) * 20 / 1440
                                    : height(context) * 20 / 814,
                              ),
                            ),
                          )
                        else
                          Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: .61.h),
                  AutoSizeText(
                    job?.company.toString() ?? "",
                    minFontSize: 0,
                    maxLines: 1,
                    style: darkAccentHeaderTextStyle.copyWith(
                        fontSize: height(context) * 25 / 814 >
                                width(context) * 25 / 1440
                            ? width(context) * 25 / 1440
                            : height(context) * 25 / 814),
                  ),
                  SizedBox(height: .61.h),
                  Row(children: buildPrestige()),
                  // Display job prestige stars
                  SizedBox(height: 1.22.h),
                  Text(
                    job?.description?.toString() ?? "",
                    style: blackBodyTextStyle.copyWith(
                      fontSize: height(context) * 20 / 814,
                    ),
                    maxLines: 23,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
