import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internhs/util/api_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/device.dart';
import '../constants/text.dart';

// TextEditingController instances for input fields
TextEditingController countryController = TextEditingController();
TextEditingController radiusController = TextEditingController();
TextEditingController ageController = TextEditingController();
String remote = "Yes"; // Initial value for the dropdown

/// Builds the preference widgets based on the [type] and [length] parameters.
Widget _buildPref(String type, double length, BuildContext context) {
  if (type == "Remote") {
    return _buildRemotePref(context, type);
  } else {
    return _buildTextFieldPref(context, type, length);
  }
}

/// Builds the dropdown widget for the "Remote" preference.
Widget _buildRemotePref(BuildContext context, String type) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(height: 1.h),
      Padding(
        padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 2.w),
            _buildLabel(context, type),
            const Spacer(),
            _buildDropdown(context),
            SizedBox(width: 2.w),
          ],
        ),
      ),
      _buildDivider(),
    ],
  );
}

/// Builds the text field widget for other preferences.
Widget _buildTextFieldPref(BuildContext context, String type, double length) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(height: 1.h),
      Padding(
        padding: EdgeInsets.fromLTRB(1.4.w, 2.25.h, 1.4.w, 2.25.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 2.w),
            _buildLabel(context, type),
            const Spacer(),
            _buildTextField(context, type, length),
            SizedBox(width: 2.w),
          ],
        ),
      ),
      _buildDivider(),
    ],
  );
}

/// Builds the label widget for the preferences.
Widget _buildLabel(BuildContext context, String type) {
  return AutoSizeText(
    "$type: ",
    maxLines: 1,
    minFontSize: 0,
    style: blackBodyTextStyle.copyWith(
      fontSize: height(context) * 12 / 814 > width(context) * 12 / 1440
          ? width(context) * 12 / 1440
          : height(context) * 12 / 814,
    ),
  );
}

/// Builds the dropdown widget for the "Remote" preference.
Widget _buildDropdown(BuildContext context) {
  return SizedBox(
    height: 7.h,
    width: 8.w,
    child: DropdownButton<String>(
      style: blackBodyTextStyle.copyWith(
        fontSize: height(context) * 16 / 814 > width(context) * 16 / 1440
            ? width(context) * 16 / 1440
            : height(context) * 16 / 814,
      ),
      value: remote,
      onChanged: (String? newValue) {
        if (newValue != null) {
          remote = newValue;
        }
      },
      items:
          <String>['Yes', 'No'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: AutoSizeText(
            value,
            minFontSize: 0,
            maxLines: 1,
            style: blackBodyTextStyle.copyWith(
              fontSize: height(context) * 16 / 814 > width(context) * 16 / 1440
                  ? width(context) * 16 / 1440
                  : height(context) * 16 / 814,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

/// Builds the text field widget for other preferences.
Widget _buildTextField(BuildContext context, String type, double length) {
  return SizedBox(
    width: length.toDouble(),
    height: 3.65.h,
    child: Center(
      child: TextField(
        controller: _getControllerForType(type),
        cursorColor: lightBackgroundColor,
        style: lightButtonTextStyle.copyWith(
          fontSize: height(context) * 12 / 814 > width(context) * 12 / 1440
              ? width(context) * 12 / 1440
              : height(context) * 12 / 814,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: darkAccent,
          contentPadding:
              EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 1.38.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}

/// Gets the appropriate TextEditingController for the given [type].
TextEditingController _getControllerForType(String type) {
  switch (type) {
    case "Country":
      return countryController;
    case "Search Radius":
      return radiusController;
    case "Age in Hours":
      return ageController;
    default:
      return TextEditingController();
  }
}

/// Builds the divider widget.
Widget _buildDivider() {
  return Padding(
    padding: EdgeInsets.fromLTRB(.55.w, 0, .55.w, 0),
    child: Divider(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    ),
  );
}

/// Builds the button widget with the given [color] and [text].
Widget _buildButton(Color color, String text, BuildContext context) {
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
                          : height(context) * 12 / 814,
                    ),
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
                          : height(context) * 12 / 814,
                ),
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

  /// Handles the "Go!" button press.
  Future<void> _handleGoButtonPress() async {
    var api = ApiService();
    setState(() {
      loading = true;
    });
    try {
      await api.scrapeJobs(
        countryValue: countryController.text,
        radiusValue: radiusController.text,
        remoteValue: remote == "Yes",
        ageValue: ageController.text,
      );
    } catch (e) {
      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

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
        child: loading
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
                            : height(context) * 36 / 814,
                      ),
                    ),
                  ),
                  _buildPref("Country", 22.w, context),
                  _buildPref("Search Radius", 10.1.w, context),
                  _buildPref("Remote", 10.1.w, context),
                  _buildPref("Age in Hours", 22.w, context),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: _handleGoButtonPress,
                    child: _buildButton(darkAccent, "Go!", context),
                  ),
                ],
              ),
      ),
    );
  }
}
