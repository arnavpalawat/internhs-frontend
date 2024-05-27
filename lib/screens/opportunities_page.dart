import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/util/tinder_swipe_mechanics.dart';

import '../util/job.dart';

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  Widget card(text) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: height(context) * 0.45,
                  width: width(context) * 0.25,
                  child: TinderSwiper(
                    jobs: [
                      Job(
                        companyName: 'Mckinsey',
                        prestige: 5,
                        jobTitle: 'Consultant',
                        field: 'Business',
                      ),
                      Job(
                        companyName: 'Google',
                        prestige: 5,
                        jobTitle: 'Software Engineer',
                        field: 'Computer Science',
                      ),
                      Job(
                        companyName: 'Moody Street Group',
                        prestige: 2,
                        jobTitle: 'Marketing Intern',
                        field: 'Business',
                      ),
                      Job(
                        companyName: 'Nasa',
                        prestige: 1,
                        jobTitle: 'Aerospace Engineer',
                        field: 'Engineering',
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
