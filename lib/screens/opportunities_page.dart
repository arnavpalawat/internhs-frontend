import 'dart:js' as js;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/constants/text.dart';
import 'package:internhs/util/build_prefs.dart';
import 'package:internhs/util/header.dart';
import 'package:internhs/util/job.dart';
import 'package:internhs/util/tinder_swipe_mechanics.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  @override
  void initState() {
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
        rJobs = filteredJobs;
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
                    .where((job) => job.title.contains(text))
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
          height: 1.5,
        ),
        decoration: textFieldDecoration.copyWith(
          filled: true,
          hintText: "Search for a Title: ",
          fillColor: whatWeDOBG,
          suffixIcon: const Icon(
            Icons.search,
            color: headerColor,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: whatWeDOBG),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: whatWeDOBG),
            borderRadius: BorderRadius.circular(25.7),
          ),
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
            padding: const EdgeInsets.all(8.0),
            width: width(context) * 0.25,
            height: height(context) * 0.75,
            decoration: authBoxDecorations,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Login please first",
                    style: header2TextStyle,
                  ),
                ),
                SizedBox(width: width(context) * 0.005),
                const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: width(context) * 0.005),
              ],
            ),
          ),
        );
      } else {
        // Convert Future<Stream> to Stream
        return FutureBuilder(
          future: _wishlistedStream,
          builder: (context, wishlistFutureSnapshot) {
            if (wishlistFutureSnapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.black.withOpacity(0.6),
                  size: 20,
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
                        color: Colors.black.withOpacity(0.6),
                        size: 20,
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
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      width: width(context) * 0.25,
                      height: height(context) * 0.75,
                      decoration: authBoxDecorations,

                      /// Stream of Data containing wishlist
                      child: FutureBuilder(
                        future: getAllJobs(),
                        builder: (context, jobSnapshot) {
                          bool wishlisted = true;

                          if (jobSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LoadingAnimationWidget.twoRotatingArc(
                                color: Colors.black.withOpacity(0.6),
                                size: 20,
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
                                    color: Colors.black.withOpacity(0.6),
                                    size: 20,
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
                                          js.context.callMethod('open',
                                              [job?.link ?? "indeed.com"]);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: height(context) * 0.08,
                                              decoration: authBoxDecorations,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      job?.title.length > 30
                                                          ? "${job?.title.substring(0, 26)}... \n @ ${job?.company.length > 26 ? "${job?.company.substring(0, 22)}..." : job?.company}"
                                                          : "${job?.title}\n @ ${job?.company}",
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
                                                        ? const Icon(
                                                            Icons.favorite,
                                                            color: Colors
                                                                .pinkAccent,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_border_outlined,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                  ),
                                                  SizedBox(
                                                      width: width(context) *
                                                          0.005),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                  SizedBox(
                                                      width: width(context) *
                                                          0.005),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    height(context) * 0.005),
                                            SizedBox(
                                              width: width(context) * 0.225,
                                              child: Divider(
                                                  height:
                                                      height(context) * 0.01),
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
                      ),
                    );
                  }
                },
              );
            }
          },
        );
      }
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              left: width(context) * 0.05,
              top: height(context) * 0.4,
              child: Image.asset(
                "lib/assets/images/opportunities.png",
                scale: 1,
              ),
            ),
            Column(
              children: [
                SizedBox(height: height(context) * 0.015),
                // Header section
                const BuildHeader(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height(context) * 0.015),
                    // Opportunities section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: SizedBox(
                        width: width(context) * 0.25,
                        height: height(context) * 56 / 840,
                        child: buildTextFormField(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height(context) * 0.65,
                          width: width(context),
                          child: FutureBuilder<List<Job>>(
                            future: jobsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: LoadingAnimationWidget.twoRotatingArc(
                                    color: whatWeDOBG,
                                    size: 20,
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
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      setState(
                                        () {
                                          first = false;
                                        },
                                      );
                                    },
                                  );
                                }
                                return Row(
                                  children: [
                                    SizedBox(
                                        height: height(context) * 0.65,
                                        width: width(context) * 0.25,
                                        child: TinderSwiper(jobs: jobs)),
                                    SizedBox(
                                      width: width(context) * 0.025,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                            height: height(context) * 0.65,
                                            child: buildWishlist()),
                                      ],
                                    ),
                                    SizedBox(
                                      width: width(context) * 0.025,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: height(context) * 0.65,
                                          child: buildPrefs(context),
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
          ],
        ),
      ),
    );
  }
}
