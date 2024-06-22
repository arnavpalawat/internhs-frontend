import 'package:flutter/material.dart';
import 'package:internhs/screens/initial_landing_flow/landing_page.dart';
import 'package:internhs/screens/initial_landing_flow/our_story_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/device.dart';
import '../../util/header.dart';

class LandingAgent extends StatefulWidget {
  const LandingAgent({Key? key}) : super(key: key);

  @override
  State<LandingAgent> createState() => _LandingAgentState();
}

class _LandingAgentState extends State<LandingAgent> {
  final PageController _pageController = PageController();
  int ind = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  PageView _pageView() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemCount: 2,
      physics: BouncingScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          ind = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        print(index);
        switch (index) {
          case (0):
            return LandingPage(
              pageController: _pageController,
            );

          case (1):
            return const OurStoryPage();
          default:
            return LoadingAnimationWidget.twoRotatingArc(
              color: Colors.white,
              size: 15,
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Expanded(child: _pageView()),
            Positioned(
              left: 0,
              top: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: height(context) * 0.015,
                  ),
                  const BuildHeader(),
                  SizedBox(
                    height: height(context) * 0.015,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
