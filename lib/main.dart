import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InternHS());
}

class InternHS extends StatefulWidget {
  const InternHS({super.key});

  @override
  State<InternHS> createState() => _InternHSState();
}

class _InternHSState extends State<InternHS> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      print(Device.pixelRatio);
      return LayoutBuilder(builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            setState(() {
              MediaQuery.of(context);
            });
          },
        );
        return MaterialApp(
          title: 'InternHS',
          home: LandingAgent(),
        );
      });
    });
  }
}
