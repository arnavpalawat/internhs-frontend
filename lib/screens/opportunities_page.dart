import 'dart:js' as js;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/colors.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/screens/authentication_flow/login_screen.dart';
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
  bool jobFetchComplete = false;
  late Stream<List<String>> _wishlistedStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Job> jobs = [];
  List<Job> originalJobs = [];

  List<Job> wishlistedJobs = [];
  List<Job> originalWishlist = [];
  bool initialAddition = false;

  /// Get Jobs
  Future<List<Job>> fetchJobs() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('jobs').get();
      List<Job> jobs = querySnapshot.docs
          .map((doc) => Job.fromFirebase(doc.data() as Map<String, dynamic>))
          .toList();

      // Fetch wishlisted and unliked jobs for the user
      if (_auth.currentUser?.uid == null) {
        setState(() {
          jobFetchComplete = true;
        });

        return jobs;
      } else {
        originalJobs = jobs;
        QuerySnapshot wishlistSnapshot = await _firestore
            .collection('user')
            .doc(_auth.currentUser?.uid)
            .collection('wishlisted')
            .get();
        QuerySnapshot unlikedSnapshot = await _firestore
            .collection('user')
            .doc(_auth.currentUser?.uid)
            .collection('unliked')
            .get()
            .whenComplete(() {
          setState(() {
            jobFetchComplete = true;
          });
        });

        // Get list of job IDs wishlisted by the user
        List<String> wishlistedJobIds =
            wishlistSnapshot.docs.map((doc) => doc['jobId'] as String).toList();

        // Get list of job IDs unliked by the user
        List<String> unlikedJobIds =
            unlikedSnapshot.docs.map((doc) => doc.id).toList();

        // Filter out wishlisted and unliked jobs
        List<Job> filteredJobs = jobs.where((job) {
          // Include jobs that are not wishlisted or unliked by the user
          return !wishlistedJobIds.contains(job.id) &&
              !unlikedJobIds.contains(job.id);
        }).toList();

        return filteredJobs;
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
    }
  }

  Stream<List<String>> _fetchWishlistStream() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      return _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection("wishlisted")
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => doc['jobId'] as String).toList());
    } else {
      return Stream.value([]);
    }
  }

  Widget card(String text) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blue,
      child: Text(text),
    );
  }

  Widget buildWishlist() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) {
      return !jobFetchComplete
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: width(context) * 0.25,
                height: height(context) * 0.75,
                decoration: authBoxDecorations,
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.black.withOpacity(0.6),
                  size: 20,
                ),
              ),
            )
          : GestureDetector(
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
                    SizedBox(
                      width: width(context) * 0.005,
                    ),
                    const Center(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: width(context) * 0.005,
                    ),
                  ],
                ),
              ),
            );
    } else {
      return !jobFetchComplete
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: width(context) * 0.25,
                height: height(context) * 0.75,
                decoration: authBoxDecorations,
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.black.withOpacity(0.6),
                  size: 20,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(8.0),
              width: width(context) * 0.25,
              height: height(context) * 0.75,
              decoration: authBoxDecorations,
              child: StreamBuilder<List<String>>(
                  stream: _wishlistedStream,
                  builder: (context, snapshot) {
                    bool wishlisted = true;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display loading animation while fetching jobs
                      return LoadingAnimationWidget.twoRotatingArc(
                        color: Colors.black.withOpacity(0.6),
                        size: 20,
                      );
                    } else if (snapshot.hasError) {
                      // Display error message if fetching fails
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // Display message if no jobs available
                      return const Center(
                        child: Text('No Wishlisted Jobs'),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            // Get wishlisted job
                            Job job = originalJobs.firstWhere((element) =>
                                element.id == snapshot.data?[index]);
                            return GestureDetector(
                              onTap: () {
                                js.context.callMethod(
                                    'open', [job.link ?? "indeed.com"]);
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(job.title.length > 30
                                              ? "${job.title.toString().substring(0, 26)}... \n @ ${job.company.length > 26 ? "${job.company.toString().substring(0, 22)}..." : job.company}"
                                              : job.title +
                                                  "\n @ ${job.company}"),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              wishlisted = false;
                                            });
                                            _firestore
                                                .collection('user')
                                                .doc(_auth.currentUser?.uid)
                                                .collection("wishlisted")
                                                .doc(job.id)
                                                .delete();
                                            _firestore
                                                .collection('user')
                                                .doc(_auth.currentUser?.uid)
                                                .collection("unliked")
                                                .add(
                                              {"jobId": job.id},
                                            );
                                          },
                                          child: wishlisted
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.pinkAccent,
                                                )
                                              : Icon(
                                                  Icons
                                                      .favorite_border_outlined,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                        ),
                                        SizedBox(
                                          width: width(context) * 0.005,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        SizedBox(
                                          width: width(context) * 0.005,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height(context) * 0.005,
                                  ),
                                  SizedBox(
                                    width: width(context) * 0.225,
                                    child: Divider(
                                      height: height(context) * 0.01,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
            );
    }
  }

  @override
  void initState() {
    _wishlistedStream = _fetchWishlistStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextFormField buildTextFormField() {
      return TextFormField(
        onEditingComplete: () {
          setState(
            () {
              _searchController.text.toString() == ""
                  ? jobs = originalJobs.where(
                      (element) {
                        return element.field == _searchController.text;
                      },
                    ).toList()
                  : jobs = originalJobs;
            },
          );
        },
        controller: _searchController,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        style: authTextStyle.copyWith(
            fontSize: height(context) * 20 / 840, height: 1.5),
        decoration: textFieldDecoration.copyWith(
          filled: true,
          hintText: "Search for a Field (Exact Field): ",
          fillColor: Colors.white,
          suffixIcon: const Icon(
            Icons.search,
            color: headerColor,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
        ),
      );
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
                SizedBox(
                  height: height(context) * 0.015,
                ),
                // Header section
                const BuildHeader(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Space Below Header
                        SizedBox(
                          height: height(context) * 0.015,
                        ),
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
                              width: width(context) * 0.25,
                              child: FutureBuilder<List<Job>>(
                                future: fetchJobs(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display loading animation while fetching jobs
                                    return Center(
                                      child:
                                          LoadingAnimationWidget.twoRotatingArc(
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Display error message if fetching fails
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    // Display message if no jobs available
                                    return const Center(
                                      child: Text('No jobs available'),
                                    );
                                  } else {
                                    if (initialAddition == false) {
                                      jobs = originalJobs;
                                      initialAddition = true;
                                    }

                                    // Display TinderSwiper with fetched jobs
                                    return TinderSwiper(jobs: jobs);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: height(context) * 0.05,
                        ),
                        buildWishlist(),
                      ],
                    )
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
          ],
        ),
      ),
    );
  }
}
