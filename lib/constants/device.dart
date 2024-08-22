import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

final isMobile = kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

int opportunityScreen =
    0; // 0 = inactive, 1 = On Ops Screen, 2 = On Wishlist Screen
