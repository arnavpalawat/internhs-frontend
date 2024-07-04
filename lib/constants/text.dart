import 'package:flutter/material.dart';

import 'colors.dart';

/// Announcement Styles
const announcementTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 80,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w700,
  height: 1.5,
);

const italicAnnouncementTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 80,
  fontStyle: FontStyle.italic,
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
  height: 1.5,
);
const announcementBodyTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 24,
  fontFamily: 'Questral',
  fontWeight: FontWeight.w400,
  height: 0.5,
);

const blackBodyTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 20,
  fontFamily: 'Inter',
  height: 1,
);

/// Button Styles
const lightButtonTextStyle = TextStyle(
  color: lightTextColor,
  fontSize: 16,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);

const darkButtonTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 16,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);

/// Authentication Styles
const authTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 16,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  height: 0,
);

const authHeadingStyle = TextStyle(
  color: darkTextColor,
  fontSize: 32,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
  height: 0,
);

/// Header Text Styles
const lightHeaderTextStyle = TextStyle(
  color: lightTextColor,
  fontSize: 25,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);
const darkHeaderTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 25,
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.ellipsis,
);
const darkAccentHeaderTextStyle = TextStyle(
  color: darkTextColor,
  fontSize: 25,
  fontStyle: FontStyle.italic,
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
);

const lightAccentHeaderTextStyle = TextStyle(
  color: lightTextColor,
  fontSize: 25,
  fontStyle: FontStyle.italic,
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
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
