import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';

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
          width: width(context) * 0.005,
        ),
      ];

      // Add filled stars
      for (int i = 1; i <= int.parse(job!.prestige ?? "0"); i++) {
        output.add(
          const Icon(Icons.star, size: 10),
        );
        output.add(
          SizedBox(
            width: width(context) * 0.005,
          ),
        );
      }

      // Add empty stars
      for (num i = index; i > 0; i -= 1) {
        output.add(
          const Icon(Icons.star_border_outlined, size: 10),
        );
        output.add(
          SizedBox(
            width: width(context) * 0.005,
          ),
        );
      }
      return output;
    }

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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width(context),
                  child: Row(
                    children: [
                      Text(
                        job!.title.toString().length > 30
                            ? job?.title.toString().substring(0, 26) ??
                                "No Jobs Available"
                            : job?.title.toString() ?? "No Jobs Available",
                        style: darkHeaderTextStyle.copyWith(color: darkAccent),
                      ),
                      // Display bookmark icon if job is flagged
                      if (job?.flagged == null || job?.flagged == true)
                        const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.bookmark,
                              color: brightAccent,
                              size: 36,
                            ),
                          ),
                        )
                      else
                        Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(job?.company.toString() ?? "",
                    style: darkAccentHeaderTextStyle),
                const SizedBox(height: 5),
                Row(children: buildPrestige()),
                // Display job prestige stars
                const SizedBox(height: 10),
                Text(
                  job!.description.toString() ?? "",
                  style: blackBodyTextStyle,
                  maxLines: 11,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
