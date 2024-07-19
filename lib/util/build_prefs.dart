import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internhs/util/api_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../constants/text.dart';

TextEditingController countryController = TextEditingController();
TextEditingController radiusController = TextEditingController();
String remote = "Yes";

TextEditingController ageController = TextEditingController();

Widget _buildPref(String type, double length, BuildContext context) {
  if (type == "Remote") {
    // If type is "Remote", display a dropdown with yes or no
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 2.w,
              ),
              AutoSizeText(
                "$type: ",
                maxLines: 1,
                minFontSize: 0,
                style: blackBodyTextStyle.copyWith(
                    fontSize:
                        height(context) * 12 / 814 > width(context) * 12 / 1440
                            ? width(context) * 12 / 1440
                            : height(context) * 12 / 814),
              ),
              const Spacer(),
              SizedBox(
                height: 7.h,
                width: 8.w,
                child: DropdownButton<String>(
                  value: 'Yes', // Example initial value
                  onChanged: (String? newValue) {
                    // Handle dropdown value change
                  },
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    remote = value;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: AutoSizeText(
                        value,
                        minFontSize: 0,
                        maxLines: 1,
                        style: blackBodyTextStyle.copyWith(
                            fontSize: height(context) * 24 / 814 >
                                    width(context) * 24 / 1440
                                ? width(context) * 24 / 1440
                                : height(context) * 24 / 814),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
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
    );
  } else {
    // For other types, display a text field
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 2.w,
              ),
              AutoSizeText(
                "$type: ",
                maxLines: 1,
                minFontSize: 0,
                style: blackBodyTextStyle.copyWith(
                  fontSize:
                      height(context) * 12 / 814 > width(context) * 12 / 1440
                          ? width(context) * 12 / 1440
                          : height(context) * 12 / 814,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: length.toDouble(),
                height: 3.65.h,
                child: TextField(
                  controller: type == "Country"
                      ? countryController
                      : type == "Search Radius"
                          ? radiusController
                          : type == "Age in Hours"
                              ? ageController
                              : TextEditingController(),
                  cursorColor: lightBackgroundColor,
                  style: lightButtonTextStyle.copyWith(
                      fontSize: height(context) * 12 / 814 >
                              width(context) * 12 / 1440
                          ? width(context) * 12 / 1440
                          : height(context) * 12 / 814),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: darkAccent,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 1.8.h, horizontal: 1.38.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(29.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
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
    );
  }
}

Widget _buildButton(Color color, String text, context) {
  return Column(
    children: [
      Container(
        width: 8.1.w,
        height: 4.h,
        padding: EdgeInsets.symmetric(horizontal: 1.67.w),
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
          mainAxisSize: text != "Delete" ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (text == "Delete")
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: AutoSizeText(
                    text,
                    minFontSize: 0,
                    maxLines: 1,
                    style: lightButtonTextStyle.copyWith(
                        fontSize: height(context) * 12 / 814 >
                                width(context) * 12 / 1440
                            ? width(context) * 12 / 1440
                            : height(context) * 12 / 814),
                  ),
                ),
              )
            else
              AutoSizeText(
                text,
                minFontSize: 0,
                maxLines: 1,
                style: lightButtonTextStyle.copyWith(
                    fontSize:
                        height(context) * 12 / 814 > width(context) * 12 / 1440
                            ? width(context) * 12 / 1440
                            : height(context) * 12 / 814),
              ),
          ],
        ),
      ),
    ],
  );
}

class buildPrefs extends StatefulWidget {
  const buildPrefs({super.key});

  @override
  State<buildPrefs> createState() => _buildPrefsState();
}

class _buildPrefsState extends State<buildPrefs> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      width: 40.w,
      child: Container(
        width: 45.23.w,
        height: 91.3.h,
        decoration: ShapeDecoration(
          color: lightBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: loading == true
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: darkTextColor,
                  size: height(context) * 20 / 814 > width(context) * 20 / 814
                      ? width(context) * 20 / 814
                      : height(context) * 20 / 814,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
                    child: AutoSizeText(
                      "Generate New Internships",
                      maxLines: 1,
                      minFontSize: 0,
                      style: announcementTextStyle.copyWith(
                          fontSize: height(context) * 36 / 814 >
                                  width(context) * 36 / 1440
                              ? width(context) * 36 / 1440
                              : height(context) * 36 / 814),
                    ),
                  ),
                  _buildPref("Country", 22.w, context),
                  _buildPref("Search Radius", 10.1.w, context),
                  _buildPref("Remote", 10.1.w, context),
                  _buildPref("Age in Hours", 22.w, context),
                  SizedBox(
                    height: 15.h,
                  ),
                  GestureDetector(
                      onTap: () async {
                        var api = ApiService();
                        setState(() {
                          loading = true;
                        });
                        await api
                            .scrapeJobs(
                          countryValue: countryController.text,
                          radiusValue: radiusController.text,
                          remoteValue: remote == "Yes" ? true : false,
                          ageValue: ageController.text,
                        )
                            .whenComplete(() {
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      child: _buildButton(darkAccent, "Go!", context)),
                ],
              ),
      ),
    );
  }
}
