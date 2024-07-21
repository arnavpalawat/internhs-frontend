import 'package:flutter/material.dart';

/// Pagewide Theme Colours

// Background
const backgroundColor = BoxDecoration(
  gradient: RadialGradient(
    center: Alignment(1.07, 0.50),
    radius: 1.5,
    colors: [
      Colors.white,
      Color(0xFF3866BF),
    ],
  ),
);

const Color darkBackgroundColor = Color(0xFF6C8ECC);

const Color lightBackgroundColor = Color(0xFFE0E7F5);

const Color darkTextColor = Color(0xFF0C0A08);

const Color lightTextColor = Color(0xFFE0E7F5);

const Color headerColor = Color(0xFF6C8DCC);

const brightAccent = Color(0xFFDC493A);

const darkAccent = Color(0xFF012A43);

const borderColor = Color(0x59666666);

const headerTextColors = [Color(0xFFFFFFFF), darkBackgroundColor];

ShapeDecoration authBoxDecorations = ShapeDecoration(
  color: lightBackgroundColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);

const borderStyle = OutlineInputBorder(
  borderSide: BorderSide(
    width: 1,
    color: borderColor,
  ),
);
