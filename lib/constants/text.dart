import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'colors.dart';

/// Announcement Styles
final announcementTextStyle = GoogleFonts.poppins(
  textStyle: TextStyle(
    color: darkTextColor,
    fontSize: Device.height * 80 / 814,
    fontWeight: FontWeight.bold,
    height: 1.5,
  ),
);

final italicAnnouncementTextStyle = GoogleFonts.lora(
  textStyle: TextStyle(
    color: darkTextColor,
    fontSize: Device.height * 80 / 814,
    fontStyle: FontStyle.italic,
    height: 1.5,
  ),
);

final announcementBodyTextStyle = GoogleFonts.questrial(
  textStyle: const TextStyle(
      color: darkTextColor,
      fontSize: 24,
      height: 1.5,
      fontWeight: FontWeight.normal),
);

final blackBodyTextStyle = GoogleFonts.inter(
  textStyle: const TextStyle(
      color: darkTextColor,
      fontSize: 20,
      height: 1,
      fontWeight: FontWeight.normal),
);

/// Button Styles
final lightButtonTextStyle = GoogleFonts.inter(
  textStyle: const TextStyle(
    color: lightTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
);

final darkButtonTextStyle = GoogleFonts.inter(
  textStyle: const TextStyle(
    color: darkTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
);

/// Authentication Styles
final authTextStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
      color: darkTextColor, fontSize: 16, fontWeight: FontWeight.normal),
);

final authHeadingStyle = GoogleFonts.poppins(
  textStyle: const TextStyle(
      color: darkTextColor, fontSize: 32, fontWeight: FontWeight.normal),
);

/// Header Text Styles
final lightHeaderTextStyle = GoogleFonts.inter(
  textStyle: const TextStyle(
    color: lightTextColor,
    fontSize: 25,
    fontWeight: FontWeight.w400,
  ),
);

final darkHeaderTextStyle = GoogleFonts.inter(
  textStyle: const TextStyle(
    color: darkTextColor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  ),
);

final darkAccentHeaderTextStyle = GoogleFonts.lora(
  textStyle: const TextStyle(
      color: darkTextColor,
      fontSize: 25,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.normal),
);

final lightAccentHeaderTextStyle = GoogleFonts.lora(
  textStyle: const TextStyle(
      color: lightTextColor,
      fontSize: 25,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.normal),
);

InputDecoration textFieldDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(
    vertical: 16.0,
    horizontal: 12.0,
  ),
  enabledBorder: borderStyle,
  focusedBorder: borderStyle,
  border: borderStyle.copyWith(
    borderRadius: BorderRadius.circular(12),
  ),
);
