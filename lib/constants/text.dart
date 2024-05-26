import 'package:flutter/material.dart';

import 'colors.dart';

const headerTextStyle = TextStyle(
  fontSize: 25,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);

const whiteButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  height: 0.09,
);

const announcementTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 80,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w700,
  height: 1.5,
);

const italicAnnouncementTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 80,
  fontStyle: FontStyle.italic,
  fontFamily: 'Lora',
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const bodyTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontFamily: 'Questral',
  fontWeight: FontWeight.w400,
  height: 0.5,
);

const buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 25,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    height: 0.06,
    overflow: TextOverflow.ellipsis);

const authTextStyle = TextStyle(
  color: Color(0xFF333333),
  fontSize: 16,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  height: 0,
);

const authHeadingStyle = TextStyle(
  color: Color(0xFF333333),
  fontSize: 32,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
  height: 0,
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
