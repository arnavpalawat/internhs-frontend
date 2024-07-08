import 'package:flutter/cupertino.dart';

/// Device Dimensions
// Width
double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Height
double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

int landingAgentIndex = 0;
