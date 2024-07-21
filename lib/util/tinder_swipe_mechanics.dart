import 'dart:js' as js;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:internhs/screens/authentication_flow/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import 'job.dart';
import 'tinder_card.dart';

class TinderSwiper extends StatefulWidget {
  List<Job>? jobs;
  final Function() onSwipeCallback; // Callback function

  TinderSwiper({super.key, required this.jobs, required this.onSwipeCallback});

  @override
  State<TinderSwiper> createState() => _TinderSwiperState();
}

class _TinderSwiperState extends State<TinderSwiper> {
  final CardSwiperController controller = CardSwiperController();
  bool disable = false;

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_keyboardCallback);
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
    setState(() {
      widget.onSwipeCallback(); // Call the callback on each swipe
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return CardSwiper(
        isLoop: false,
        controller: controller,
        cardsCount: widget.jobs != null && widget.jobs!.isNotEmpty
            ? widget.jobs!.length
            : 1,
        onSwipe: onSwipe,
        numberOfCardsDisplayed: widget.jobs != null && widget.jobs!.isNotEmpty
            ? (widget.jobs!.length >= 3 ? 3 : widget.jobs!.length)
            : 1,
        backCardOffset: Offset(2.w, 4.h),
        padding: EdgeInsets.fromLTRB(1.67.w, 2.96.h, 1.67.w, 2.96.h),
        isDisabled: disable,
        cardBuilder: (context, index, horizontalThresholdPercentage,
            verticalThresholdPercentage) {
          if (widget.jobs != null &&
              widget.jobs!.isNotEmpty &&
              index < widget.jobs!.length) {
            return TinderCard(widget.jobs?[index]);
          } else {
            return Container(
              width: 35.w,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: lightBackgroundColor,
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
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(1.11.w, 1.97.h, 1.11.w, 1.97.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No more available Internships",
                          style: TextStyle(
                            color: darkTextColor,
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
          }
        },
      );
    });
  }
}
