import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/util/header.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/text.dart';
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

  Widget buildAccountButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to account screen
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                Placeholder(//TODO: Add account screen
                    ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        width: width(context) * 0.09,
        height: height(context) * 0.06,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: ShapeDecoration(
          color: accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Account',
              style: whiteButtonTextStyle.copyWith(
                  fontSize: height(context) * 16 / 840),
            ),
          ],
        ),
      ),
    );
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
            SizedBox(
              height: height(context) * 0.015,
            ),
            // Header section
            BuildHeader(
              button: buildAccountButton(),
            ),
            // Space Below Header
            SizedBox(
              height: height(context) * 0.015,
            ),
            // Opportunities section
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
                        // Display loading animation while fetching jobs
                        return Center(
                          child: LoadingAnimationWidget.twoRotatingArc(
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // Display error message if fetching fails
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Display message if no jobs available
                        return const Center(
                          child: Text('No jobs available'),
                        );
                      } else {
                        // Display TinderSwiper with fetched jobs
                        return TinderSwiper(jobs: snapshot.data!);
                      }
                    },
                  ),
                ),
              ],
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 1000))
                .slideY(
                    begin: 0.25,
                    end: 0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.ease),
          ],
        ),
      ),
    );
  }
}
