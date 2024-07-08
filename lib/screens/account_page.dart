import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internhs/constants/text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
  bool hovering = false;
  bool google = false;
  @override
  void initState() {
    super.initState();
    signedInWithGoogle();
  }

  Future<void> resetPassword(String? email) async {
    try {
      email != null
          ? FirebaseAuth.instance.sendPasswordResetEmail(email: email)
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
          width: 50.w,
          height: 6.h,
          padding: EdgeInsets.symmetric(horizontal: 1.66.w),
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
                child: AutoSizeText(
                  text,
                  maxLines: 1,
                  minFontSize: 0,
                  style: lightButtonTextStyle.copyWith(
                      fontSize: height(context) * 21 / 814 >
                              width(context) * 21 / 1440
                          ? width(context) * 21 / 1440
                          : height(context) * 21 / 814,
                      fontWeight: FontWeight.bold),
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
      () {
        if (google) {
          GoogleSignIn().signOut();
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const LandingAgent(
              index: 0,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    Future<void> deleteSubcollection(
        String userId, String subcollectionName) async {
      CollectionReference subcollection = FirebaseFirestore.instance
          .collection("user")
          .doc(userId)
          .collection(subcollectionName);

      QuerySnapshot snapshot = await subcollection.get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    try {
      if (user != null) {
        String userId = user.uid;
        if (google) {
          GoogleSignIn().signOut();
        }
        await deleteSubcollection(userId, "unliked");
        await deleteSubcollection(userId, "wishlisted");
        await FirebaseFirestore.instance
            .collection("user")
            .doc(userId)
            .delete();
        await user.delete().whenComplete(() {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => LandingAgent(
                index: 0,
              ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        });
      }
    } catch (e) {
      print("Failed to delete account: $e");
      // Handle the exception here
    }
  }

  Widget _buildOperations(BuildContext context) {
    return SizedBox(
      height: 80.h,
      width: 40.w,
      child: Container(
        width: 45.w,
        height: 71.1.h,
        decoration: ShapeDecoration(
          color: lightTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
              child: AutoSizeText(
                "Operations and Preferences",
                style: announcementTextStyle.copyWith(
                    fontSize:
                        height(context) * 36 / 814 > width(context) * 36 / 1440
                            ? width(context) * 36 / 1440
                            : height(context) * 36 / 814),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    google
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 1.h,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    1.4.w, 2.25.h, 1.4.w, 2.25.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          2.w,
                                    ),
                                    AutoSizeText(
                                      "Change Email",
                                      minFontSize: 0,
                                      maxLines: 1,
                                      style: blackBodyTextStyle.copyWith(
                                          fontSize: height(context) * 12 / 814 >
                                                  width(context) * 12 / 1440
                                              ? width(context) * 12 / 1440
                                              : height(context) * 12 / 814),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 5.5.h > 9.7.w ? 9.7.w : 5.5.h,
                                      width: 5.5.h > 9.7.w ? 9.7.w : 5.5.h,
                                      decoration: BoxDecoration(
                                        color: darkAccent,
                                        borderRadius:
                                            BorderRadius.circular(180),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: .7.h,
                                                horizontal: .42.w),
                                            onPressed: () =>
                                                changeEmail(context),
                                            icon: Icon(
                                              Icons.email_outlined,
                                              color: lightTextColor,
                                              size: height(context) * 25 / 814 >
                                                      width(context) * 25 / 1440
                                                  ? width(context) * 25 / 1440
                                                  : height(context) * 25 / 814,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(.55.w, 0, .55.w, 0),
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
                          height: 1.h,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 2.w,
                              ),
                              AutoSizeText(
                                "Change Password",
                                style: blackBodyTextStyle.copyWith(
                                    fontSize: height(context) * 12 / 814 >
                                            width(context) * 12 / 1440
                                        ? width(context) * 12 / 1440
                                        : height(context) * 12 / 814),
                              ),
                              const Spacer(),
                              Container(
                                height: 5.5.h > 9.7.w ? 9.7.w : 5.5.h,
                                width: 5.5.h > 9.7.w ? 9.7.w : 5.5.h,
                                decoration: BoxDecoration(
                                  color: darkAccent,
                                  borderRadius: BorderRadius.circular(180),
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: .7.h, horizontal: .42.w),
                                    onPressed: () =>
                                        sendPasswordChangeEmail(context),
                                    icon: Icon(Icons.lock_outline,
                                        color: lightTextColor,
                                        size: height(context) * 25 / 814 >
                                                width(context) * 25 / 1440
                                            ? width(context) * 25 / 1440
                                            : height(context) * 25 / 814),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(.55.w, 0, .55.w, 0),
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
                          height: 1.h,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 2.w,
                              ),
                              AutoSizeText(
                                "Sign Out",
                                style: blackBodyTextStyle.copyWith(
                                    fontSize: height(context) * 12 / 814 >
                                            width(context) * 12 / 1440
                                        ? width(context) * 12 / 1440
                                        : height(context) * 12 / 814),
                              ),
                              const Spacer(),
                              Container(
                                height: 5.5.h > 9.7.w ? 9.7.w : 5.5.h,
                                width: 5.5.h > 9.7.w ? 9.7.w : 5.5.h,
                                decoration: BoxDecoration(
                                  color: darkAccent,
                                  borderRadius: BorderRadius.circular(180),
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: .7.h, horizontal: .42.w),
                                    onPressed: () => signOut(),
                                    icon: Icon(
                                      Icons.logout,
                                      color: lightTextColor,
                                      size: height(context) * 25 / 814 >
                                              width(context) * 25 / 1440
                                          ? width(context) * 25 / 1440
                                          : height(context) * 25 / 814,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(.55.w, 0, .55.w, 0),
                          child: Divider(
                            height: .12.h,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteAccount(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.4.h, horizontal: .84.w),
                        child: buildButton(brightAccent, "Delete"),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
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
          title: AutoSizeText(
            "Change Email",
            style: blackBodyTextStyle.copyWith(
                fontSize:
                    height(context) * 12 / 814 > width(context) * 12 / 1440
                        ? width(context) * 12 / 1440
                        : height(context) * 12 / 814),
          ),
          content: Container(
            height: 20.h,
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
              child: AutoSizeText(
                "Cancel",
                style: blackBodyTextStyle.copyWith(
                    fontSize:
                        height(context) * 12 / 814 > width(context) * 12 / 1440
                            ? width(context) * 12 / 1440
                            : height(context) * 12 / 814),
              ),
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
              child: AutoSizeText(
                "Change",
                style: blackBodyTextStyle.copyWith(
                    fontSize:
                        height(context) * 12 / 814 > width(context) * 12 / 1440
                            ? width(context) * 12 / 1440
                            : height(context) * 12 / 814),
              ),
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
      SnackBar(
        content: AutoSizeText(
          "Password Change Email Sent",
          style: blackBodyTextStyle.copyWith(
              fontSize: height(context) * 12 / 814 > width(context) * 12 / 1440
                  ? width(context) * 12 / 1440
                  : height(context) * 12 / 814),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, _) {
        return Container(
          height: double.infinity,
          decoration: backgroundColor,
          child: Column(
            children: [
              // Space Above Header
              SizedBox(
                height: 1.5.h,
              ),
              const BuildHeader(),
              // Space Below Header
              SizedBox(
                height: 2.5.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: buildPrefs(context),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
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
        );
      }),
    );
  }
}
