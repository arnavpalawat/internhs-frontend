import 'dart:js' as js;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/util/header.dart';
import 'package:internhs/util/job.dart';
import 'package:internhs/util/tinder_swipe_mechanics.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'authentication_flow/login_screen.dart';

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  late Future<Stream<List<String>>> _wishlistedStream;
  List<Job> jobs = [];
  List<Job> originalJobs = [];
  bool first = true;
  late Future<List<Job>> jobsFuture;
  final Timestamp currentDate = Timestamp.now();
  late Timestamp threeMonthsAgo;

  @override
  void initState() {
    threeMonthsAgo = Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(
        currentDate.millisecondsSinceEpoch - (3 * 30 * 24 * 60 * 60 * 1000)));

    jobsFuture = fetchJobs();
    _wishlistedStream = _fetchWishlistStream();
    super.initState();
  }

  // Fetch wishlist stream for the current user
  Future<Stream<List<String>>> _fetchWishlistStream() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      // Fetch all jobs from the 'jobs' collection
      QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
      originalJobs = querySnapshot.docs
          .map((doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
          .toList();

      // Return a stream of wishlisted job IDs for the current user
      return _firestore
          .collection('user')
          .doc(currentUser.uid)
          .collection("wishlisted")
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => doc['jobId'] as String).toList());
    } else {
      // Return an empty stream if there is no authenticated user
      return Stream.value([]);
    }
  }

  // Get all Jobs in a Future snapshot
  Future<List<Job>> getAllJobs() async {
    // Fetch all documents from the 'jobs' collection
    QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();

    // Convert the documents to a list of Job objects
    List<Job> rJobs = querySnapshot.docs
        .map((doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
        .toList();

    // Return the list of Job objects
    return rJobs;
  }

  Future<List<Job>> fetchJobs() async {
    try {
      // Fetch all documents from the 'jobs' collection
      QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
      List<Job> rJobs = querySnapshot.docs
          .map((doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
          .toList();

      FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        // Fetch wishlisted jobs for the current user
        QuerySnapshot wishlistSnapshot = await _firestore
            .collection('user')
            .doc(currentUser.uid)
            .collection('wishlisted')
            .get();

        // Fetch unliked jobs for the current user
        QuerySnapshot unlikedSnapshot = await _firestore
            .collection('user')
            .doc(currentUser.uid)
            .collection('unliked')
            .get();

        // Extract job IDs from wishlisted and unliked jobs
        List<String> wishlistedJobIds =
            wishlistSnapshot.docs.map((doc) => doc['jobId'] as String).toList();
        List<String> unlikedJobIds =
            unlikedSnapshot.docs.map((doc) => doc['jobId'] as String).toList();

        // Filter out wishlisted and unliked jobs
        List<Job> filteredJobs =
            rJobs.where((job) => !wishlistedJobIds.contains(job.id)).toList();
        filteredJobs = filteredJobs
            .where((job) => !unlikedJobIds.contains(job.id))
            .toList();
        List<Job> filteredList = [];

        filteredList = filteredJobs
            .where((jobF) => jobF.date!.compareTo(threeMonthsAgo) > 0)
            .toList();

        rJobs = filteredList;
      }

      return rJobs;
    } catch (e) {
      print('Error fetching jobs: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Function to build the search text field
    TextFormField buildTextFormField() {
      return TextFormField(
        onChanged: (text) {
          setState(() {
            if (text.isNotEmpty) {
              setState(() {
                jobs = originalJobs
                    .where(
                      (job) => job.title.toString().toLowerCase().contains(
                            text.toLowerCase(),
                          ),
                    )
                    .toList();
              });
            } else {
              jobs = originalJobs;
            }
          });
        },
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        style: authTextStyle.copyWith(
          fontSize: height(context) * 20 / 840,
          height: 1,
        ),
        decoration: textFieldDecoration.copyWith(
          filled: true,
          hintText: "Search for a Title: ",
          hintStyle: darkButtonTextStyle.copyWith(
              fontSize: height(context) * 16 / 814 > width(context) * 16 / 1440
                  ? width(context) * 16 / 1440
                  : height(context) * 16 / 814,
              height: 0),
          fillColor: lightBackgroundColor,
          suffixIcon: Icon(
            Icons.search,
            color: brightAccent,
            size: height(context) * 25 / 814 > width(context) * 25 / 1440
                ? width(context) * 25 / 1440
                : height(context) * 25 / 814,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: lightBackgroundColor),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBackgroundColor),
            borderRadius: BorderRadius.circular(25.7),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 0.814.h), // Adjust the vertical padding as needed
        ),
      );
    }

    // Function to build the wishlist widget
    Widget buildWishlist() {
      FirebaseAuth _auth = FirebaseAuth.instance;
      // Check if there is a user
      if (_auth.currentUser == null) {
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
                    "Login to Unlock your \n Personalized Intership Wishlist",
                    style: darkHeaderTextStyle.copyWith(
                      fontSize: height(context) * 25 / 814 >
                              width(context) * 25 / 1440
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
        // Convert Future<Stream> to Stream
        return Container(
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
          width: 35.w,
          height: 75.h,
          decoration: authBoxDecorations,
          child: FutureBuilder(
            future: _wishlistedStream,
            builder: (context, wishlistFutureSnapshot) {
              if (wishlistFutureSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.twoRotatingArc(
                    color: darkTextColor,
                    size: height(context) * 20 / 814 > width(context) * 20 / 814
                        ? width(context) * 20 / 814
                        : height(context) * 20 / 814,
                  ),
                );
              } else if (wishlistFutureSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${wishlistFutureSnapshot.error}'),
                );
              } else if (!wishlistFutureSnapshot.hasData) {
                return const Center(
                  child: Text('No Wishlisted Jobs'),
                );
              } else {
                /// Get all jobs
                return FutureBuilder(
                  future: getAllJobs(),
                  builder: (context, allJobSnapshot) {
                    if (allJobSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.twoRotatingArc(
                          color: darkTextColor,
                          size: height(context) * 20 / 814 >
                                  width(context) * 20 / 814
                              ? width(context) * 20 / 814
                              : height(context) * 20 / 814,
                        ),
                      );
                    } else if (allJobSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${allJobSnapshot.error}'),
                      );
                    } else if (!allJobSnapshot.hasData ||
                        allJobSnapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No Wishlisted Jobs'),
                      );
                    } else {
                      return

                          /// Stream of Data containing wishlist
                          FutureBuilder(
                        future: getAllJobs(),
                        builder: (context, jobSnapshot) {
                          bool wishlisted = true;

                          if (jobSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LoadingAnimationWidget.twoRotatingArc(
                                color: darkTextColor,
                                size: height(context) * 20 / 814 >
                                        width(context) * 20 / 814
                                    ? width(context) * 20 / 814
                                    : height(context) * 20 / 814,
                              ),
                            );
                          } else if (jobSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${jobSnapshot.error}'),
                            );
                          } else if (!jobSnapshot.hasData ||
                              jobSnapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No Wishlisted Jobs'),
                            );
                          } else {
                            return StreamBuilder(
                              stream: wishlistFutureSnapshot.data,
                              builder: (context, streamSnapshot) {
                                bool wishlisted = true;

                                if (streamSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingAnimationWidget.twoRotatingArc(
                                    color: darkTextColor,
                                    size: height(context) * 20 / 814 >
                                            width(context) * 20 / 814
                                        ? width(context) * 20 / 814
                                        : height(context) * 20 / 814,
                                  );
                                } else if (streamSnapshot.hasError) {
                                  return Center(
                                    child:
                                        Text('Error: ${streamSnapshot.error}'),
                                  );
                                } else if (!streamSnapshot.hasData ||
                                    streamSnapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text('No Wishlisted Jobs'),
                                  );
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: streamSnapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Job? job = jobSnapshot.data?.firstWhere(
                                        (element) =>
                                            element.id ==
                                            streamSnapshot.data?[index],
                                      );

                                      return GestureDetector(
                                        onTap: () {
                                          js.context.callMethod(
                                            'open',
                                            [
                                              job?.link ?? "indeed.com",
                                            ],
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 9.35.h,
                                              decoration: authBoxDecorations,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                      .556.w,
                                                      .983.h,
                                                      .556.w,
                                                      .983.h,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AutoSizeText(
                                                          job?.title.length > 26
                                                              ? "${job?.title.substring(0, 24)}..."
                                                              : "${job?.title}",
                                                          minFontSize: 0,
                                                          maxLines: 1,
                                                          style: darkHeaderTextStyle.copyWith(
                                                              fontSize: height(
                                                                              context) *
                                                                          25 /
                                                                          814 >
                                                                      width(context) *
                                                                          25 /
                                                                          1440
                                                                  ? width(context) *
                                                                      25 /
                                                                      1440
                                                                  : height(
                                                                          context) *
                                                                      25 /
                                                                      814),
                                                        ),
                                                        AutoSizeText(
                                                            "@ ${job?.company.length > 58 ? "${job?.company.substring(0, 50)}..." : job?.company}",
                                                            minFontSize: 0,
                                                            maxLines: 1,
                                                            style:
                                                                darkAccentHeaderTextStyle
                                                                    .copyWith(
                                                              fontSize: height(
                                                                              context) *
                                                                          16 /
                                                                          814 >
                                                                      width(context) *
                                                                          16 /
                                                                          1440
                                                                  ? width(context) *
                                                                      16 /
                                                                      1440
                                                                  : height(
                                                                          context) *
                                                                      16 /
                                                                      814,
                                                            )),
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
                                                          .doc(_auth
                                                              .currentUser?.uid)
                                                          .collection(
                                                              "wishlisted")
                                                          .doc(job?.id)
                                                          .delete();
                                                    },
                                                    child: wishlisted
                                                        ? Icon(
                                                            Icons.favorite,
                                                            color: brightAccent,
                                                            size: height(context) *
                                                                        20 /
                                                                        814 >
                                                                    width(context) *
                                                                        20 /
                                                                        1440
                                                                ? width(context) *
                                                                    20 /
                                                                    1440
                                                                : height(
                                                                        context) *
                                                                    20 /
                                                                    814,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_border_outlined,
                                                            color: darkTextColor
                                                                .withOpacity(
                                                                    0.6),
                                                            size: height(context) *
                                                                        20 /
                                                                        814 >
                                                                    width(context) *
                                                                        20 /
                                                                        814
                                                                ? width(context) *
                                                                    20 /
                                                                    814
                                                                : height(
                                                                        context) *
                                                                    20 /
                                                                    814,
                                                          ),
                                                  ),
                                                  SizedBox(width: .5.w),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: darkAccent,
                                                    size: height(context) *
                                                                18 /
                                                                814 >
                                                            width(context) *
                                                                18 /
                                                                1440
                                                        ? width(context) *
                                                            18 /
                                                            1440
                                                        : height(context) *
                                                            18 /
                                                            814,
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
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        );
      }
    }

    return Scaffold(
      body: LayoutBuilder(builder: (context, _) {
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
              SizedBox(
                width: width(context),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 1.5.h),
                      // Header section
                      const BuildHeader(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 85.h,
                                width: width(context),
                                child: FutureBuilder<List<Job>>(
                                  future: jobsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: LoadingAnimationWidget
                                            .twoRotatingArc(
                                          color: lightBackgroundColor,
                                          size: height(context) * 20 / 814 >
                                                  width(context) * 20 / 814
                                              ? width(context) * 20 / 814
                                              : height(context) * 20 / 814,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                        child: Text('No jobs available'),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (first) {
                                        originalJobs = snapshot.data!;
                                        jobs = originalJobs;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (_) {
                                            setState(
                                              () {
                                                first = false;
                                              },
                                            );
                                          },
                                        );
                                      }
                                      return Column(
                                        children: [
                                          // Swiper and Wishlist
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            2.1.w,
                                                            3.7.h,
                                                            3.7.h,
                                                            0.w),
                                                    child: SizedBox(
                                                      width: 32.w,
                                                      height: 6.h,
                                                      child:
                                                          buildTextFormField(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 65.h,
                                                    width: 37.w,
                                                    child: TinderSwiper(
                                                        jobs: jobs),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: 60.h,
                                                    child: buildWishlist(),
                                                  ),
                                                  SizedBox(
                                                    height: 2.5.h,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
