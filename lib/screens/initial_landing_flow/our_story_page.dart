import 'package:flutter/material.dart';
import 'package:internhs/constants/colors.dart';

class OurStoryPage extends StatefulWidget {
  const OurStoryPage({super.key});

  @override
  State<OurStoryPage> createState() => _OurStoryPageState();
}

class _OurStoryPageState extends State<OurStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourStoryBG,
      body: Column(children: []),
    );
  }
}
