import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../util/job.dart';
import '../util/tinder_swipe_mechanics.dart';

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List<Job> jobs = [
  //   Job(
  //     null,
  //     companyName: 'Mckinsey',
  //     prestige: 5,
  //     jobTitle: 'Consultant',
  //     field: 'Business',
  //   ),
  //   Job(
  //     null,
  //     companyName: 'Google',
  //     prestige: 5,
  //     jobTitle: 'Software Engineer',
  //     field: 'Computer Science',
  //   ),
  //   Job(
  //     null,
  //     companyName: 'Moody Street Group',
  //     prestige: 2,
  //     jobTitle: 'Marketing Intern',
  //     field: 'Business',
  //   ),
  //   Job(
  //     null,
  //     companyName: 'Nasa',
  //     prestige: 1,
  //     jobTitle: 'Aerospace Engineer',
  //     field: 'Engineering',
  //   ),
  // ];
  Widget card(text) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Text(text),
    );
  }

  /// Get Jobs
  Future<List<Job>> fetchJobs() async {
    QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
    return querySnapshot.docs.map((doc) => Job.fromFirestore(doc)).toList();
  }

  @override
  void initState() {
    // for (Job job in jobs) {
    //   job.addJob();
    // }

    super.initState();
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
                SizedBox(
                  height: height(context) * 0.45,
                  width: width(context) * 0.25,
                  child: FutureBuilder<List<Job>>(
                    builder: (context, jobs) {
                      if (jobs.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.twoRotatingArc(
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      } else {
                        return TinderSwiper(jobs: jobs.data);
                      }
                    },
                    future: fetchJobs(),
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
