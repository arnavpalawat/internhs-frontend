import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:internhs/constants/text.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../util/build_prefs.dart';
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
  bool google = false;
  @override
  void initState() {
    super.initState();
    signedInWithGoogle();
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

  Future<void> resetPassword(String? email) async {
    try {
      email != null
          ? FirebaseAuth.instance.sendPasswordResetEmail(email: email ?? "")
          : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signedInWithGoogle() async {
    var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        FirebaseAuth.instance.currentUser?.email ?? "");
    if (methods.contains('google.com')) {
      setState(() {
        google = true;
      });
    }
  }

  Widget buildButton(Color color, String text) {
    return Column(
      children: [
        Container(
          width: width(context) * 0.5,
          height: height(context) * 0.06,
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
              Center(
                child: Text(
                  text,
                  style: lightButtonTextStyle.copyWith(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildOperations(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        width: MediaQuery.of(context).size.width * 579 / 1280,
        height: MediaQuery.of(context).size.height * 592 / 832,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Operations and Preferences",
                style: announcementTextStyle.copyWith(fontSize: 36),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    google
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    const Text("Change Email"),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: darkAccent,
                                        borderRadius:
                                            BorderRadius.circular(180),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                            padding: const EdgeInsets.all(6),
                                            onPressed: () =>
                                                changeEmail(context),
                                            icon: const Icon(
                                              Icons.email_outlined,
                                              color: lightTextColor,
                                            )),
                                      ),
                                    )
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
                          )
                        : Container(),
                    Column(
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
                              const Text("Change Password"),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: darkAccent,
                                  borderRadius: BorderRadius.circular(180),
                                ),
                                child: Center(
                                  child: IconButton(
                                      padding: const EdgeInsets.all(6),
                                      onPressed: () =>
                                          sendPasswordChangeEmail(context),
                                      icon: const Icon(
                                        Icons.lock_outline,
                                        color: lightTextColor,
                                      )),
                                ),
                              )
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
                    ),
                    Column(
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
                              const Text("Sign Out"),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: darkAccent,
                                  borderRadius: BorderRadius.circular(180),
                                ),
                                child: Center(
                                  child: IconButton(
                                      padding: const EdgeInsets.all(6),
                                      onPressed: () => signOut(),
                                      icon: const Icon(
                                        Icons.logout,
                                        color: lightTextColor,
                                      )),
                                ),
                              )
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
                    ),
                    SizedBox(
                      height: height(context) * 0.4,
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteAccount();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: buildButton(brightAccent, "Delete"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeEmail(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Email"),
          content: Container(
            height: height(context) * 0.2,
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration:
                      const InputDecoration(hintText: "Enter new email"),
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Enter current password",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(
                    email: user?.email ?? "",
                    password: passwordController.text);

                try {
                  await user!.reauthenticateWithCredential(cred);
                  await user.verifyBeforeUpdateEmail(emailController.text);
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(user.uid)
                      .update({'email': emailController.text});
                } catch (e) {
                  print('Error updating email: $e');
                }
              },
              child: const Text("Change"),
            ),
          ],
        );
      },
    );
  }

  void sendPasswordChangeEmail(BuildContext context) {
    // Implement your send password change email logic here
    print("Password change email sent");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password change email sent")),
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
                    child: buildPrefs(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildOperations(context),
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
