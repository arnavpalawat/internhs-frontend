import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/text.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../util/header.dart';
import 'initial_landing_flow/landing_agent.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _remoteController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  late Map<String, TextEditingController> findController = {
    "country": _countryController,
    "Remote": _remoteController,
    "Search Radius": _radiusController,
    "Age in Hours": _ageController
  };
  late AnimationController _controllerGS;
  late Animation<double> _animationGS;
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    _controllerGS = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationGS = CurvedAnimation(
      parent: _controllerGS,
      curve: Curves.easeInOut,
    ).drive(Tween<double>(begin: 0, end: 15));

    _controllerGS.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controllerGS.dispose();
    super.dispose();
  }

  void _onGSHover(PointerEvent details) {
    _controllerGS.forward();
    setState(() {
      hovering = true;
    });
  }

  void _onGSExit(PointerEvent details) {
    _controllerGS.reverse();
    setState(() {
      hovering = false;
    });
  }

  Widget buildButton(Color color, String text) {
    return MouseRegion(
      onEnter: text == "Sign Out" ? _onGSHover : null,
      onExit: text == "Sign Out" ? _onGSExit : null,
      child: Column(
        children: [
          Container(
            width: width(context) * 0.081 +
                (text == "Sign Out" ? _animationGS.value : 0),
            height: height(context) * 0.04,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
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
              mainAxisSize:
                  text != "Delete" ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (text == "Delete")
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        text,
                        style: buttonTextStyle.copyWith(fontSize: 15),
                      ),
                    ),
                  )
                else
                  Text(
                    text,
                    style: buttonTextStyle.copyWith(fontSize: 15),
                  ),
                const Spacer(),
                if (text == "Sign Out")
                  if (hovering)
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        opacity: hovering ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: _animationGS.value > 0
                            ? Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: _animationGS.value > 10 ? 15.0 : 0.0,
                                ),
                              )
                            : Container(width: 0),
                      ),
                    )
                  else
                    Container(
                      width: 0,
                    )
                else
                  Container(width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(
          () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => LandingAgent(
                index: 0,
              ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          ),
        );
  }

  Future<void> deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      FirebaseFirestore.instance.collection("user").doc(user?.uid).delete();
      await user?.delete().whenComplete(
            () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => LandingAgent(
                  index: 0,
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            ),
          );
    } catch (e) {
      print("Failed to delete account: $e");
      // Handle the exception here
    }
  }

  Widget _buildPref(String type, int length, BuildContext context) {
    if (type == "Remote") {
      // If type is "Remote", display a dropdown with yes or no
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text("$type: "),
                const Spacer(),
                DropdownButton<String>(
                  value: 'Yes', // Example initial value
                  onChanged: (String? newValue) {
                    // Handle dropdown value change
                  },
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
      );
    } else {
      // For other types, display a text field
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text("$type: "),
                const Spacer(),
                SizedBox(
                  width: length.toDouble(),
                  height: 30,
                  child: TextField(
                    controller:
                        TextEditingController(), // Provide your controller here
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white, height: 1),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPrefs() {
    return SizedBox(
      height: height(context) * 0.65,
      width: width(context) * 0.4,
      child: Container(
        width: width(context) * 579 / 1280,
        height: height(context) * 592 / 832,
        decoration: ShapeDecoration(
          color: whatWeDOBG,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Generate New Internships",
              style: announcementTextStyle.copyWith(fontSize: 36),
            ),
            _buildPref("Country", 182, context),
            _buildPref("Search Radius", 83, context),
            _buildPref("Remote", 83, context),
            _buildPref("Age in Hours", 132, context),
          ],
        ),
      ),
    );
  }

  Widget _buildOperations() {
    return SizedBox(
      height: height(context) * 0.65,
      width: width(context) * 0.4,
      child: Container(
        width: width(context) * 579 / 1280,
        height: height(context) * 592 / 832,
        decoration: ShapeDecoration(
          color: whatWeDOBG,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Operations and Preferences",
              style: announcementTextStyle.copyWith(fontSize: 36),
            ),
            GestureDetector(
              onTap: () {
                signOut();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildButton(headerColor, "Sign Out"),
              ),
            ),
            GestureDetector(
              onTap: () {
                deleteAccount();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildButton(Colors.black, "Delete"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: backgroundColor,
        child: Column(
          children: [
            // Space Above Header
            SizedBox(
              height: height(context) * 0.015,
            ),
            const BuildHeader(),
            // Space Below Header
            SizedBox(
              height: height(context) * 0.025,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildPrefs(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildOperations(),
                  ),
                ),
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
