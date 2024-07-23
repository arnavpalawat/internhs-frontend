import 'dart:async';
import 'dart:js' as js;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/util/header.dart';
import 'package:internhs/util/job.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/text.dart';
import '../util/loading.dart';
import '../util/tinder_swipe_mechanics.dart';
import 'authentication_flow/login_screen.dart';

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

  List<Job> recommendedJobs = [];
  bool recommendLoading = true;

  List<String> wishlistJobs = [];
  bool loadWishlist = false;

  @override
  void initState() {
    super.initState();
    threeMonthsAgo = _calculateThreeMonthsAgo();
    _fetchAllJobs();
  }

  Timestamp _calculateThreeMonthsAgo() {
    // Calculate the timestamp for three months ago
    return Timestamp.fromDate(
      DateTime.fromMillisecondsSinceEpoch(
        currentDate.millisecondsSinceEpoch - (3 * 30 * 24 * 60 * 60 * 1000),
      ),
    );
  }

  Future<void> _fetchAllJobs() async {
    // Fetch all jobs from Firestore
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
      if (mounted) {
        setState(() {
          jobs = querySnapshot.docs
              .map(
                  (doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
              .toList();
          loading = false;
        });
      }
    } catch (e) {
      _handleError(e, "Error fetching jobs");
    }
  }

  Future<void> _fetchWishlistJobs() async {
    // Fetch wishlist jobs from Firestore
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .doc(auth.currentUser!.uid)
          .collection("wishlisted")
          .get();
      if (mounted) {
        setState(() {
          wishlistJobs = querySnapshot.docs
              .map((doc) => doc.id) // Get the document ID
              .toList()
              .cast<String>();
          wishlistJobs = List.from(wishlistJobs.reversed);
          loadWishlist = true;
        });
      }
    } catch (e) {
      _handleError(e, "Error fetching wishlist jobs");
    }
  }

  void _handleError(Object e, String message) {
    // Handle and log errors
    print("$message: $e");
    if (mounted) {
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
                _buildBackgroundImage(context),
                _buildContent(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    // Build the background image
    return Positioned(
      left: 70.w,
      top: 40.h,
      child: Image.asset(
        "lib/assets/images/opportunities.png",
        scale: height(context) * -2 / 814 + 3 < width(context) * -2 / 1440 + 3
            ? width(context) * -2 / 1440 + 3
            : height(context) * -2 / 814 + 3,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Build the main content of the page
    return Center(
      child: Column(
        children: [
          SizedBox(height: 1.5.h),
          _buildHeader(),
          loading
              ? SizedBox(
                  height: 85.h,
                  width: 100.w,
                  child: Center(
                    child: buildLoadingIndicator(context, lightBackgroundColor),
                  ),
                )
              : SizedBox(width: double.infinity, child: _buildJobContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Build the header with animations
    return const BuildHeader()
        .animate()
        .fade(
          duration: const Duration(milliseconds: 1000),
        )
        .slideY(
          begin: 0.25,
          end: 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.ease,
        );
  }

  Widget _buildJobContent() {
    // Build the job content with animations
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 85.h,
            width: 37.w,
            child: TinderSwiper(
              jobs: jobs,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 80.h,
            child: buildWishlist(jobs),
          ),
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
        );
  }

  Widget buildWishlist(List<Job> jobs) {
    // Build wishlist view
    if (auth.currentUser == null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const LoginPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
          width: 35.w,
          height: 75.h,
          decoration: authBoxDecorations,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AutoSizeText(
                  "Login to Unlock your \n Personalized Internship Wishlist",
                  style: darkHeaderTextStyle.copyWith(
                    fontSize:
                        height(context) * 25 / 814 > width(context) * 25 / 1440
                            ? width(context) * 25 / 1440
                            : height(context) * 25 / 814,
                  ),
                  minFontSize: 0,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: .5.w),
              Center(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: darkAccent,
                  size: height(context) * 20 / 814 > width(context) * 20 / 814
                      ? width(context) * 20 / 814
                      : height(context) * 20 / 814,
                ),
              ),
              SizedBox(width: .5.w),
            ],
          ),
        ),
      );
    } else {
      // Convert Future to Stream
      return Container(
        padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
        width: 35.w,
        height: 75.h,
        decoration: authBoxDecorations,
        child: FutureBuilder(
          future: _fetchWishlistJobs(),
          builder: (context, _) {
            return loadWishlist
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: wishlistJobs.length,
                    itemBuilder: (context, index) {
                      bool wishlisted = true;
                      Job? job = jobs.firstWhere(
                        (element) =>
                            element.id == wishlistJobs.elementAt(index),
                      );

                      String jobTitle = job.title.toString();
                      String jobCompany = job.company.toString();

                      return GestureDetector(
                        onTap: () {
                          js.context.callMethod(
                            'open',
                            [
                              (job.link is List)
                                  ? job.link.first
                                  : job.link ?? "indeed.com",
                            ],
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 9.35.h,
                              decoration: authBoxDecorations,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      .556.w,
                                      .983.h,
                                      .556.w,
                                      .983.h,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          jobTitle.length > 26
                                              ? "${jobTitle.substring(0, 24)}..."
                                              : jobTitle,
                                          minFontSize: 0,
                                          maxLines: 1,
                                          style: darkHeaderTextStyle.copyWith(
                                              fontSize: height(context) *
                                                          25 /
                                                          814 >
                                                      width(context) * 25 / 1440
                                                  ? width(context) * 25 / 1440
                                                  : height(context) * 25 / 814),
                                        ),
                                        AutoSizeText(
                                          "@ ${jobCompany.length > 58 ? "${jobCompany.substring(0, 50)}..." : jobCompany}",
                                          minFontSize: 0,
                                          maxLines: 1,
                                          style: darkAccentHeaderTextStyle
                                              .copyWith(
                                            fontSize: height(context) *
                                                        16 /
                                                        814 >
                                                    width(context) * 16 / 1440
                                                ? width(context) * 16 / 1440
                                                : height(context) * 16 / 814,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        wishlisted = false;
                                      });
                                      _firestore
                                          .collection('user')
                                          .doc(auth.currentUser?.uid)
                                          .collection("wishlisted")
                                          .doc(job.id)
                                          .delete();
                                    },
                                    child: wishlisted
                                        ? Icon(
                                            Icons.favorite,
                                            color: brightAccent,
                                            size: height(context) * 20 / 814 >
                                                    width(context) * 20 / 1440
                                                ? width(context) * 20 / 1440
                                                : height(context) * 20 / 814,
                                          )
                                        : Icon(
                                            Icons.favorite_border_outlined,
                                            color:
                                                darkTextColor.withOpacity(0.6),
                                            size: height(context) * 20 / 814 >
                                                    width(context) * 20 / 814
                                                ? width(context) * 20 / 814
                                                : height(context) * 20 / 814,
                                          ),
                                  ),
                                  SizedBox(width: .5.w),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: darkAccent,
                                    size: height(context) * 18 / 814 >
                                            width(context) * 18 / 1440
                                        ? width(context) * 18 / 1440
                                        : height(context) * 18 / 814,
                                  ),
                                  SizedBox(width: .5.w),
                                ],
                              ),
                            ),
                            SizedBox(height: .5.h),
                            SizedBox(
                              width: 22.5.w,
                              child: Divider(height: 1.h),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : buildLoadingIndicator(context, lightBackgroundColor);
          },
        ),
      );
    }
  }
}
