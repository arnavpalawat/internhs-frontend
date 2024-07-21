import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/util/header.dart';
import 'package:internhs/util/job.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
    getAllJobs();
  }

  @override
  void dispose() {
    super.dispose();
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
                  left: 70.w,
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
                    const BuildHeader()
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
                    !loading
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  height: 85.h,
                                  width: 37.w,
                                  child: TinderSwiper(
                                    jobs: jobs,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60.h,
                                // child: buildWishlist(),
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
                            )
                        : Center(
                            child: LoadingAnimationWidget.twoRotatingArc(
                              color: lightBackgroundColor,
                              size: height(context) * 20 / 814 >
                                      width(context) * 20 / 814
                                  ? width(context) * 20 / 814
                                  : height(context) * 20 / 814,
                            ),
                          ),
                  ],
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
