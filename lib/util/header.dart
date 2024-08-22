import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internhs/constants/device.dart';
import 'package:internhs/screens/account_page.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';
import 'package:internhs/screens/opportunities_page.dart';
import 'package:internhs/screens/wishlist_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/text.dart';
import '../screens/authentication_flow/login_screen.dart';

class BuildHeader extends StatefulWidget {
  const BuildHeader({super.key});

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  // Function to build navigation button
  Widget buildNavigationButton(String label, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => targetPage,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } catch (e) {
          // Handle navigation error
          debugPrint('Navigation error: $e');
        }
      },
      child: Container(
        width: 9.w,
        height: 6.h,
        padding: EdgeInsets.symmetric(horizontal: 1.66.w, vertical: 1.7.h),
        decoration: ShapeDecoration(
          color: darkAccent,
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
        child: Center(
          child: AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: 0,
            style: lightButtonTextStyle.copyWith(
              fontSize: height(context) * 12 / 814,
            ),
          ),
        ),
      ),
    );
  }

  // Function to create styled text widgets
  Widget buildHeaderText(String text) {
    return GestureDetector(
      onTap: () {
        // Define navigation based on the text label
        switch (text) {
          case 'Home':
            navigateToPage(const LandingAgent(index: 0));
            break;
          case 'Opportunities':
            navigateToPage(const OpportunitiesPage());
            break;
          case 'Pricing':
            navigateToPage(const LandingAgent(index: 1));
            break;
          case 'Our Story':
            navigateToPage(const LandingAgent(index: 2));
            break;
          case 'Contact Us':
            navigateToPage(const LandingAgent(index: 3));
            break;
        }
      },
      child: AutoSizeText(
        text,
        minFontSize: 0,
        maxLines: 1,
        style: lightHeaderTextStyle.copyWith(
          fontSize: height(context) * 18 / 814 > width(context) * 18 / 1440
              ? width(context) * 18 / 1440
              : height(context) * 18 / 814,
        ),
      ),
    );
  }

  // Function to handle navigation with error handling
  void navigateToPage(Widget page) {
    try {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } catch (e) {
      // Handle navigation error
      debugPrint('Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Row(
            children: [
              SizedBox(width: 5.w),
              Material(
                color: Colors.transparent,
                child: Container(
                  height: 13.22.h,
                  width: 93.75.w,
                  decoration: ShapeDecoration(
                    shadows: [
                      BoxShadow(
                        color: darkTextColor.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: headerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                  ),
                  // Header items
                  child: !isMobile
                      ? Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  1.4.w, 2.25.h, 1.4.w, 2.25.h),
                              child: Image.asset(
                                'lib/assets/images/internhs-header.png',
                                height: 13.22.h,
                              ),
                            ),
                            const Spacer(),
                            buildHeaderText("Home"),
                            SizedBox(width: 5.w),
                            buildHeaderText("Opportunities"),
                            SizedBox(width: 5.w),
                            buildHeaderText("Pricing"),
                            SizedBox(width: 5.w),
                            buildHeaderText("Our Story"),
                            SizedBox(width: 5.w),
                            buildHeaderText("Contact Us"),
                            SizedBox(width: 5.w),
                            auth.currentUser != null
                                ? buildNavigationButton(
                                    'Account', const AccountPage())
                                : buildNavigationButton(
                                    'Login', const LoginPage()),
                            SizedBox(width: 5.w),
                          ],
                        )
                      : Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  1.4.w, 2.25.h, 1.4.w, 2.25.h),
                              child: Image.asset(
                                'lib/assets/images/internhs-header.png',
                                height: 13.22.h,
                              ),
                            ),
                            const Spacer(),
                            opportunityScreen == 1 || opportunityScreen == 2
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: brightAccent,
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            opportunityScreen == 1
                                                ? const WishlistPage()
                                                : const OpportunitiesPage(),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            opportunityScreen == 0
                                ? SizedBox(width: 5.w)
                                : const SizedBox(),
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                            ),
                            SizedBox(width: 5.w),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: headerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                  child: Image.asset(
                    'lib/assets/images/internhs-header.png',
                    height: 13.22.h,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: buildHeaderText(context, 'Home'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LandingAgent(index: 0)),
            ),
          ),
          ListTile(
            title: buildHeaderText(context, 'Opportunities'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OpportunitiesPage()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: auth.currentUser != null
                  ? buildNavigationButton(
                      context, 'Account', const AccountPage())
                  : buildNavigationButton(context, 'Login', const LoginPage()),
            ),
          ),
        ],
      ),
    );
  }

  // Function to create styled text widgets
  Widget buildHeaderText(BuildContext context, String text) {
    return AutoSizeText(
      text,
      minFontSize: 0,
      maxLines: 1,
      style: isMobile
          ? darkHeaderTextStyle.copyWith(
              fontSize: height(context) * 48 / 814 > width(context) * 48 / 1440
                  ? width(context) * 48 / 1440
                  : height(context) * 48 / 814)
          : lightHeaderTextStyle.copyWith(
              fontSize: height(context) * 18 / 814 > width(context) * 18 / 1440
                  ? width(context) * 18 / 1440
                  : height(context) * 18 / 814,
            ),
    );
  }

  // Function to build navigation button
  Widget buildNavigationButton(
      BuildContext context, String label, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => targetPage,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } catch (e) {
          // Handle navigation error
          debugPrint('Navigation error: $e');
        }
      },
      child: Container(
        width: 9.w,
        height: 6.h,
        padding: EdgeInsets.symmetric(horizontal: 1.66.w, vertical: 1.7.h),
        decoration: ShapeDecoration(
          color: darkAccent,
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
        child: Center(
          child: AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: 0,
            style: lightButtonTextStyle.copyWith(
              fontSize: height(context) * 12 / 814,
            ),
          ),
        ),
      ),
    );
  }
}
