import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';

import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InternHS());
}

class InternHS extends StatelessWidget {
  const InternHS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InternHS',
      home: LandingAgent(),
    );
  }
}
