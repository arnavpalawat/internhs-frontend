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

const Color whatWeDoBG = Color(0xFF3866BF);
// Header
const Color headerColor = Color(0xFF6C8DCC);

const Color accentColor = Color(0xFF184753);

const headerTextColors = [Color(0xFFFFFFFF), Color(0xFF3C5FB4)];

const accentColor2 = Color(0xFF857189);

ShapeDecoration authBoxDecorations = ShapeDecoration(
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);

const borderStyle = OutlineInputBorder(
  borderSide: const BorderSide(
    width: 1,
    color: Color(0x59666666),
  ),
);
