import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/device.dart';

Widget buildLoadingIndicator(BuildContext context, color) {
  // Build the loading indicator
  return Center(
    child: LoadingAnimationWidget.twoRotatingArc(
      color: color,
      size: height(context) * 20 / 814 > width(context) * 20 / 814
          ? width(context) * 20 / 814
          : height(context) * 20 / 814,
    ),
  );
}
