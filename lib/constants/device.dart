import 'package:firebase_auth/firebase_auth.dart';
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

final FirebaseAuth auth = FirebaseAuth.instance;
