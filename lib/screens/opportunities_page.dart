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

  Widget card(String text) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Text(text),
    );
  }

  /// Get Jobs
  Future<List<Job>> fetchJobs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
      return querySnapshot.docs
          .map((doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
    }
  }

  @override
  void initState() {
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
                    future: fetchJobs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.twoRotatingArc(
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No jobs available'),
                        );
                      } else {
                        return TinderSwiper(jobs: snapshot.data!);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
