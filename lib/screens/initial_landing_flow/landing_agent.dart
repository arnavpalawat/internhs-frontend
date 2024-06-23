import 'package:flutter/material.dart';
import 'package:internhs/screens/initial_landing_flow/landing_page.dart';
import 'package:internhs/screens/initial_landing_flow/our_story_page.dart';
import 'package:internhs/screens/initial_landing_flow/what_we_do.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/device.dart';
import '../../util/header.dart';

class LandingAgent extends StatefulWidget {
  final int index;
  LandingAgent({Key? key, this.index = 0}) : super(key: key);

  @override
  State<LandingAgent> createState() => _LandingAgentState();
}

class _LandingAgentState extends State<LandingAgent> {
  final PageController _pageController = PageController();
  int ind = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(widget.index,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOutCubicEmphasized);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  PageView _pageView() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      clipBehavior: Clip.hardEdge,
      itemCount: 3,
      pageSnapping: false,
      physics: const BouncingScrollPhysics(),
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
            return const WhatWeDoPage();
          case (2):
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
            _pageView(),
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
