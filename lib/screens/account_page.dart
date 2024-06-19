import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../util/header.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController _countryController = TextEditingController();
  TextEditingController _remoteController = TextEditingController();
  TextEditingController _radiusController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  late Map<String, TextEditingController> findController = {
    "country": _countryController,
    "Remote": _remoteController,
    "Search Radius": _radiusController,
    "Age in Hours": _ageController
  };
  Widget _buildPref(String type, int length) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: height(context) * 0.01,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width(context) * 0.02,
              ),
              Text("$type: "),
              const Spacer(),
              SizedBox(
                width: length.toDouble(),
                height: 30,
                child: TextField(
                  controller: findController[type],
                  cursorColor: Colors.white,
                  style: const DefaultTextStyle.fallback()
                      .style
                      .copyWith(color: Colors.white, height: 1),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: headerColor,
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
                width: width(context) * 0.02,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Divider(
            height: 1,
            color: headerColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildPrefs() {
    return SizedBox(
      height: height(context) * 0.65,
      width: width(context) * 0.25,
      child: Container(
        width: width(context) * 579 / 1280,
        height: height(context) * 592 / 832,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Column(
          children: [
            _buildPref("Country", 182),
            _buildPref("Search Radius", 83),
            _buildPref("Remote", 83),
            _buildPref("Age in Hours", 132),
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
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildPrefs(),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: height(context) * 0.05,
                ),
                // TODO: Operations
              ],
            )
          ],
        ),
      ),
    );
  }
}
