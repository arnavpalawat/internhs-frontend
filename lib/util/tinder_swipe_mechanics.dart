import 'dart:js' as js;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:internhs/screens/authentication_flow/login_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import 'api_service.dart';
import 'job.dart';
import 'tinder_card.dart';

class TinderSwiper extends StatefulWidget {
  final List<Job>? jobs;

  TinderSwiper({
    super.key,
    required this.jobs,
  });

  @override
  State<TinderSwiper> createState() => _TinderSwiperState();
}

class _TinderSwiperState extends State<TinderSwiper> {
  final CardSwiperController controller = CardSwiperController();
  bool disable = false;
  List<Job> recommendedJobs = [];
  bool recommendLoading = true;
  int cardsGoneThrough = 0;
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_keyboardCallback);
    fetchRecommendations();
  }

  @override
  void dispose() {
    controller.dispose();
    RawKeyboard.instance.removeListener(_keyboardCallback);
    super.dispose();
  }

  @override
  void didUpdateWidget(TinderSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.jobs != oldWidget.jobs) {
      setState(() {
        setState(() {
          widget.jobs;
        });
      });
    }
  }

  Future<void> fetchRecommendations() async {
    List<String> recommendedIds = [];
    List<Job> newRecommendedJobs = [];
    try {
      ApiService api = ApiService();
      recommendedIds = await api.getRecommendations(
          uid: FirebaseAuth.instance.currentUser!.uid);

      for (String id in recommendedIds) {
        try {
          if (!recommendedJobs.any((job) => job.id == id)) {
            Job job = widget.jobs!.singleWhere((element) => id == element.id);
            newRecommendedJobs.add(job);
          }
        } catch (e) {
          print("Job with id $id not found in jobs list");
        }
      }

      setState(() {
        recommendedJobs.addAll(newRecommendedJobs);
        recommendLoading = false;
      });
    } catch (e) {
      setState(() {
        recommendLoading = false;
      });
      print("Error fetching recommendations: $e");
    }
  }

  void _keyboardCallback(RawKeyEvent keyEvent) {
    if (keyEvent is! RawKeyDownEvent) return;
    switch (keyEvent.data.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        controller.swipe(CardSwiperDirection.left);
        break;
      case LogicalKeyboardKey.arrowDown:
        controller.swipe(CardSwiperDirection.bottom);
        break;
      case LogicalKeyboardKey.arrowRight:
        controller.swipe(CardSwiperDirection.right);
        break;
      case LogicalKeyboardKey.arrowUp:
        controller.swipe(CardSwiperDirection.top);
        break;
    }
  }

  void onRightSwipe(int index) async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/login');
    } else {
      CollectionReference users = FirebaseFirestore.instance.collection('user');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference docRef =
          users.doc(uid).collection("wishlisted").doc(widget.jobs?[index].id);

      await docRef
          .set({'jobId': widget.jobs?[index].id}, SetOptions(merge: true));
    }
  }

  void onLeftSwipe(int index) async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const LoginPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      CollectionReference users = FirebaseFirestore.instance.collection('user');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference docRef =
          users.doc(uid).collection("unliked").doc(widget.jobs?[index].id);

      await docRef
          .set({'jobId': widget.jobs?[index].id}, SetOptions(merge: true));
    }
  }

  void onUpSwipe(int index) async {
    js.context.callMethod('open', [widget.jobs![index].link ?? "indeed.com"]);
    if (FirebaseAuth.instance.currentUser != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('user');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference docRef =
          users.doc(uid).collection("wishlisted").doc(widget.jobs?[index].id);

      await docRef
          .set({'jobId': widget.jobs?[index].id}, SetOptions(merge: true));
    }
  }

  Future<void> onDownSwipe(int index) async {
    CollectionReference jobs = FirebaseFirestore.instance.collection('jobs');
    String? id = widget.jobs?[index].id;
    if (id != null) {
      await jobs.doc(id).set({'flagged': true},
          SetOptions(merge: true)).whenComplete(() => print("complete"));
    }
  }

  void directionLogic(CardSwiperDirection direction, int index) {
    switch (direction.name) {
      case 'right':
        onRightSwipe(index);
        break;
      case 'left':
        onLeftSwipe(index);
        break;
      case 'bottom':
        onDownSwipe(index);
        break;
      case 'top':
        onUpSwipe(index);
        break;
    }
    print("cg $cardsGoneThrough");
    print("rj ${recommendedJobs.length}");

    if (recommendedJobs.length - cardsGoneThrough <= 6 &&
        FirebaseAuth.instance.currentUser != null) {
      fetchRecommendations();
    }
  }

  bool onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    cardsGoneThrough++;
    if (currentIndex == null || currentIndex >= widget.jobs!.length) {
      setState(() {
        disable = true;
      });
    }
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    directionLogic(direction, previousIndex);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return FirebaseAuth.instance.currentUser != null
          ? recommendedJobs.isNotEmpty
              ? CardSwiper(
                  isLoop: false,
                  controller: controller,
                  cardsCount: recommendedJobs.length,
                  onSwipe: onSwipe,
                  numberOfCardsDisplayed: 3,
                  backCardOffset: Offset(2.w, 4.h),
                  padding: EdgeInsets.fromLTRB(1.67.w, 2.96.h, 1.67.w, 2.96.h),
                  isDisabled: disable,
                  cardBuilder: (context, index, horizontalThresholdPercentage,
                      verticalThresholdPercentage) {
                    return TinderCard(recommendedJobs[index]);
                  },
                )
              : Center(
                  child: LoadingAnimationWidget.twoRotatingArc(
                    color: lightBackgroundColor,
                    size: height(context) * 20 / 814 > width(context) * 20 / 814
                        ? width(context) * 20 / 814
                        : height(context) * 20 / 814,
                  ),
                )
          : CardSwiper(
              isLoop: false,
              controller: controller,
              cardsCount: widget.jobs!.length,
              onSwipe: onSwipe,
              numberOfCardsDisplayed: 3,
              backCardOffset: Offset(2.w, 4.h),
              padding: EdgeInsets.fromLTRB(1.67.w, 2.96.h, 1.67.w, 2.96.h),
              isDisabled: disable,
              cardBuilder: (context, index, horizontalThresholdPercentage,
                  verticalThresholdPercentage) {
                return TinderCard(recommendedJobs[index]);
              },
            );
    });
  }
}
