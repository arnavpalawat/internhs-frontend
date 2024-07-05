import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../constants/text.dart';

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
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
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
          padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
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
                  cursorColor: lightBackgroundColor,
                  style:
                      const TextStyle(color: lightBackgroundColor, height: 1),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: darkAccent,
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

Widget _buildButton(Color color, String text, context) {
  return Column(
    children: [
      Container(
        width: width(context) * 0.081,
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
          mainAxisSize: text != "Delete" ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (text == "Delete")
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    text,
                    style: lightButtonTextStyle.copyWith(fontSize: 15),
                  ),
                ),
              )
            else
              Text(
                text,
                style: lightButtonTextStyle.copyWith(fontSize: 15),
              ),
          ],
        ),
      ),
    ],
  );
}

Widget buildPrefs(context) {
  return SizedBox(
    height: height(context) * 0.8,
    width: width(context) * 0.4,
    child: Container(
      width: width(context) * 579 / 1280,
      height: height(context) * 760 / 832,
      decoration: ShapeDecoration(
        color: lightBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
            child: Text(
              "Generate New Internships",
              style: announcementTextStyle.copyWith(fontSize: 36),
            ),
          ),
          _buildPref("Country", 182, context),
          _buildPref("Search Radius", 83, context),
          _buildPref("Remote", 83, context),
          _buildPref("Age in Hours", 132, context),
          SizedBox(
            height: height(context) * 0.15,
          ),
          _buildButton(darkAccent, "Go!", context),
        ],
      ),
    ),
  );
}
