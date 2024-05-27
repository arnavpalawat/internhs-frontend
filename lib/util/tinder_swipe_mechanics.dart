import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:internhs/util/tinder_card.dart';

import 'job.dart';

class TinderSwiper extends StatefulWidget {
  final List<Job> jobs;
  const TinderSwiper({super.key, required this.jobs});

  @override
  State<TinderSwiper> createState() => _TinderSwiperState();
}

class _TinderSwiperState extends State<TinderSwiper> {
  final CardSwiperController controller = CardSwiperController();
  late final cards;
  @override
  void initState() {
    cards = widget.jobs.map(TinderCard.new).toList();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
    ) {
      debugPrint(
        'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
      );
      if (direction.name == "right") {}
      return true;
    }

    bool onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
    ) {
      debugPrint(
        'The card $currentIndex was undod from the ${direction.name}',
      );
      return true;
    }

    return Flexible(
      child: CardSwiper(
        controller: controller,
        cardsCount: widget.jobs.length,
        onSwipe: onSwipe,
        onUndo: onUndo,
        numberOfCardsDisplayed: 3,
        backCardOffset: const Offset(20, 20),
        padding: const EdgeInsets.all(24.0),
        cardBuilder: (
          context,
          index,
          horizontalThresholdPercentage,
          verticalThresholdPercentage,
        ) =>
            TinderCard(
          widget.jobs[index],
        ),
      ),
    );
  }
}
