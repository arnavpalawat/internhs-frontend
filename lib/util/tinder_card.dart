import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';

import 'job.dart';

class TinderCard extends StatelessWidget {
  final Job? job;

  const TinderCard(
    this.job, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buildPrestige() {
      int index = 5 - job!.prestige;
      List<Widget> output = [
        SizedBox(
          width: width(context) * 0.005,
        ),
      ];

      for (int i = 1; i <= job!.prestige; i++) {
        output.add(
          const Icon(Icons.star, size: 10),
        );
        output.add(
          SizedBox(
            width: width(context) * 0.005,
          ),
        );
      }
      for (int i = index; i > 0; i -= 1) {
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: headerTextColors,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job?.jobTitle ?? "No Jobs Available",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  job?.companyName ?? "",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Row(children: buildPrestige()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
