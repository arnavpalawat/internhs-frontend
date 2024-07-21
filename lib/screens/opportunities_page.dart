import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/util/header.dart';
import 'package:internhs/util/job.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../util/api_service.dart';
import '../util/tinder_swipe_mechanics.dart';

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Timestamp currentDate = Timestamp.now();
  late Timestamp threeMonthsAgo;

  List<Job> jobs = [];
  bool loading = true;

  List<Job> recommendJobs = [];
  bool recommendLoading = true;

  List<Job> wishlistJobs = [];

  @override
  void initState() {
    super.initState();
    threeMonthsAgo = Timestamp.fromDate(
      DateTime.fromMillisecondsSinceEpoch(
        currentDate.millisecondsSinceEpoch - (3 * 30 * 24 * 60 * 60 * 1000),
      ),
    );
    getAllJobs().whenComplete(fetchRecommendations);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchRecommendations() async {
    List<String> recommendedIds = [];
    List<Job> newRecommendedJobs = [];
    try {
      ApiService api = ApiService();
      recommendedIds = await api.getRecommendations(
          uid: FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        recommendLoading = true;
      });

      for (String id in recommendedIds) {
        try {
          if (!recommendJobs.any((job) => job.id == id)) {
            Job job = jobs.singleWhere((element) => id == element.id);
            newRecommendedJobs.add(job);
          }
        } catch (e) {
          print("Job with id $id not found in jobs list");
        }
      }

      setState(() {
        recommendJobs.addAll(newRecommendedJobs);
        recommendLoading = false;
      });
    } catch (e) {
      setState(() {
        recommendLoading = false;
      });
      print("Error fetching recommendations: $e");
    }
  }

  Future<void> getAllJobs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
      jobs = querySnapshot.docs
          .map((doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("Error fetching jobs: $e");
      setState(() {
        loading = false;
      });
    }
  }

  void _onSwipe() {
    setState(() {
      if (recommendJobs.isNotEmpty) {
        recommendJobs.removeAt(recommendJobs.length - 1);
      }

      if (recommendJobs.length <= 6) {
        fetchRecommendations();
      }
    });
    print(recommendJobs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: backgroundColor,
            child: Stack(
              children: [
                Positioned(
                  left: 5.w,
                  top: 40.h,
                  child: Image.asset(
                    "lib/assets/images/opportunities.png",
                    scale: height(context) * -2 / 814 + 3 <
                            width(context) * -2 / 1440 + 3
                        ? width(context) * -2 / 1440 + 3
                        : height(context) * -2 / 814 + 3,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 1.5.h),
                      const BuildHeader(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: recommendLoading
                                ? Center(
                                    child:
                                        LoadingAnimationWidget.twoRotatingArc(
                                      color: lightBackgroundColor,
                                      size: height(context) * 20 / 814 >
                                              width(context) * 20 / 814
                                          ? width(context) * 20 / 814
                                          : height(context) * 20 / 814,
                                    ),
                                  )
                                : SizedBox(
                                    height: 85.h,
                                    width: 37.w,
                                    child: TinderSwiper(
                                      jobs: recommendJobs.isEmpty
                                          ? jobs
                                          : recommendJobs,
                                      onSwipeCallback: _onSwipe,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 60.h,
                            // child: buildWishlist(),
                          ),
                        ],
                      ),
                    ],
                  )
                      .animate()
                      .fade(
                        duration: const Duration(milliseconds: 1000),
                      )
                      .slideY(
                        begin: 0.25,
                        end: 0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.ease,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
