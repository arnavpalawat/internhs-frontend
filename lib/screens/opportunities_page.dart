import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Job> jobs = [];
  List<Job> originalJobs = [];

  List<Job> wishlistedJobs = [];
  List<Job> originalWishlist = [];
  bool initialAddition = false;

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

  Future<List<String>> fetchWishlist() async {
    List<String> ids = [];
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection("wishlisted")
          .get();

      querySnapshot.docs.forEach((doc) {
        ids.add(doc['jobId']);
      });
      print(ids.length);
      return ids;
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
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
      return Container(
        child: const Text("Login please first"),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8.0),
        width: width(context) * 0.25,
        height: height(context) * 0.75,
        decoration: authBoxDecorations,
        child: FutureBuilder<List<String>>(
            future: fetchWishlist(),
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
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length - 1,
                    itemBuilder: (context, index) {
                      print(index);
                      // Get wishlisted job
                      Job job = jobs.firstWhere(
                          (element) => element.id == snapshot.data?[index]);
                      return Column(
                        children: [
                          Container(
                            height: height(context) * 0.08,
                            decoration: authBoxDecorations,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(job.title.length > 35
                                      ? "${job.title.toString().substring(0, 33)}... \n @ ${job.company.length > 35 ? "${job.company.toString().substring(0, 33)}..." : job.company}"
                                      : job.title + "\n @ ${job.company}"),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.pinkAccent,
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded)
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
                      );
                    },
                  ),
                );
              }
            }),
      );
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
                const Placeholder(//TODO: Add account screen
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
  Widget build(BuildContext context) {
    TextFormField buildTextFormField() {
      return TextFormField(
        onEditingComplete: () {
          setState(() {
            _searchController.text.toString() == ""
                ? jobs = originalJobs.where((element) {
                    return element.field == _searchController.text;
                  }).toList()
                : jobs = originalJobs;
          });
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
        child: Column(
          children: [
            SizedBox(
              height: height(context) * 0.015,
            ),
            // Header section
            BuildHeader(
              button: buildAccountButton(),
            ),
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
                          height: height(context) * 0.45,
                          width: width(context) * 0.25,
                          child: FutureBuilder<List<Job>>(
                            future: fetchJobs(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                // Display message if no jobs available
                                return const Center(
                                  child: Text('No jobs available'),
                                );
                              } else {
                                if (initialAddition == false) {
                                  originalJobs = snapshot.data!;
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
      ),
    );
  }
}
