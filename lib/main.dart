import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internhs/screens/account_page.dart';
import 'package:internhs/screens/authentication_flow/sign_up_screen.dart';
import 'package:internhs/screens/initial_landing_flow/landing_agent.dart';
import 'package:internhs/screens/opportunities_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase/firebase_options.dart';
import 'screens/authentication_flow/login_screen.dart';

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
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LandingAgent(
            index: 0,
          ),
        ),
        GoRoute(
          path: '/story',
          builder: (context, state) => const LandingAgent(index: 2),
        ),
        GoRoute(
          path: '/pricing',
          builder: (context, state) => const LandingAgent(index: 1),
        ),
        GoRoute(
          path: '/contacts',
          builder: (context, state) => const LandingAgent(index: 3),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/opportunities',
          builder: (context, state) => const OpportunitiesPage(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountPage(),
        ),
      ],
    );

    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return LayoutBuilder(builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            setState(() {
              MediaQuery.of(context);
            });
          },
        );
        return MaterialApp(
          home: LandingAgent(index: 0),
          title: 'InternHS',
        );
      });
    });
  }
}
