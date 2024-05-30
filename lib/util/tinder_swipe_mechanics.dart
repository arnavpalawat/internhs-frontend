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

    /// What occurs on swipe
    void onRightSwipe(int index) async {
      if (auth.currentUser == null) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        CollectionReference users =
            FirebaseFirestore.instance.collection('user');
        String uid = auth.currentUser!.uid;
        DocumentReference docRef =
            users.doc(uid).collection("wishlisted").doc();

        await docRef.set({
          'jobId': widget.jobs?[index].id,
        }, SetOptions(merge: true));
      }
    }

    void onLeftSwipe(int index) async {
      if (auth.currentUser == null) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        CollectionReference users =
            FirebaseFirestore.instance.collection('user');
        String uid = auth.currentUser!.uid;
        DocumentReference docRef = users.doc(uid).collection("unliked").doc();

        await docRef.set({
          'jobId': widget.jobs?[index].id,
        }, SetOptions(merge: true));
      }
    }

    void onUpSwipe(int index) async {
      js.context.callMethod('open', [widget.jobs![index].link ?? "indeed.com"]);
    }

    Future<void> onDownSwipe(int index) async {
      CollectionReference users = FirebaseFirestore.instance.collection('jobs');
      String id = widget.jobs?[index].id;
      await users.doc(id).set({
        'flagged': true,
      }, SetOptions(merge: true)).whenComplete(() => print("complete"));
    }

    /// Compile all logic
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

    /// What occurs on user swipe
    bool onSwipe(
        int previousIndex, int? currentIndex, CardSwiperDirection direction) {
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

    if (kDebugMode) {
      print(widget.jobs?.length);
    }
    return CardSwiper(
      isLoop: false,
      controller: controller,
      cardsCount: widget.jobs != null ? widget.jobs!.length + 1 : 1,
      onSwipe: onSwipe,
      numberOfCardsDisplayed: widget.jobs != null ? 3 : 1,
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
