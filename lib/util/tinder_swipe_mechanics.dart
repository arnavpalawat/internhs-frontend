import 'dart:js' as js;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:internhs/screens/authentication_flow/login_screen.dart';
import 'package:internhs/util/tinder_card.dart';

import '../constants/colors.dart';
import 'job.dart';

class TinderSwiper extends StatefulWidget {
  final List<Job>? jobs;

  const TinderSwiper({super.key, required this.jobs});

  @override
  State<TinderSwiper> createState() => _TinderSwiperState();
}

class _TinderSwiperState extends State<TinderSwiper> {
  final CardSwiperController controller = CardSwiperController();
  bool disable = false;
  late final List<Widget> cards;

  @override
  void initState() {
    super.initState();
    // Initialize cards with jobs or a placeholder card
    cards = widget.jobs != null
        ? widget.jobs!
            .map(
              (job) => TinderCard(job),
            )
            .toList()
        : [
            const TinderCard(null),
          ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    /// Executes when the user swipes right on a card
    void onRightSwipe(int index) async {
      if (auth.currentUser == null) {
        // Redirect to login page if user is not authenticated
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        // Save the job as wishlisted by the user
        CollectionReference users =
            FirebaseFirestore.instance.collection('user');
        String uid = auth.currentUser!.uid;
        DocumentReference docRef =
            users.doc(uid).collection("wishlisted").doc(widget.jobs?[index].id);

        await docRef.set({
          'jobId': widget.jobs?[index].id,
        }, SetOptions(merge: true));
      }
    }

    // Executes when the user swipes left on a card
    void onLeftSwipe(int index) async {
      if (auth.currentUser == null) {
        // Redirect to login page if user is not authenticated
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        // Save the job as unliked by the user
        CollectionReference users =
            FirebaseFirestore.instance.collection('user');
        String uid = auth.currentUser!.uid;
        DocumentReference docRef = users.doc(uid).collection("unliked").doc();

        await docRef.set({
          'jobId': widget.jobs?[index].id,
        }, SetOptions(merge: true));
      }
    }

    // Executes when the user swipes up on a card
    void onUpSwipe(int index) async {
      // Open the job link in a new browser tab
      js.context.callMethod('open', [widget.jobs![index].link ?? "indeed.com"]);
    }

    // Executes when the user swipes down on a card
    Future<void> onDownSwipe(int index) async {
      // Flag the job as inappropriate or spam
      CollectionReference users = FirebaseFirestore.instance.collection('jobs');
      String id = widget.jobs?[index].id;
      await users.doc(id).set({
        'flagged': true,
      }, SetOptions(merge: true)).whenComplete(() => print("complete"));
    }

    /// Combines all swipe direction logic
    void directionLogic(CardSwiperDirection direction, index) {
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
    }

    /// Handles user swipe events
    bool onSwipe(
        int previousIndex, int? currentIndex, CardSwiperDirection direction) {
      if (currentIndex == null || currentIndex >= widget.jobs!.length) {
        // Disable swipe when there are no more cards
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

    if (kDebugMode) {
      print(widget.jobs?.length);
    }
    return CardSwiper(
      isLoop: false,
      controller: controller,
      cardsCount: widget.jobs != null ? widget.jobs!.length + 1 : 1,
      onSwipe: onSwipe,
      numberOfCardsDisplayed: widget.jobs != null
          ? widget.jobs!.length > 2
              ? 3
              : widget.jobs!.length > 1
                  ? 2
                  : 1
          : 1,
      backCardOffset: const Offset(20, 20),
      padding: const EdgeInsets.all(24.0),
      isDisabled: disable,
      cardBuilder: (
        context,
        index,
        horizontalThresholdPercentage,
        verticalThresholdPercentage,
      ) {
        return index < widget.jobs!.length
            ? TinderCard(widget.jobs?[index])
            : Container(
                // Placeholder card when no more jobs are available
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: headerTextColors,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No more available Internships",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
