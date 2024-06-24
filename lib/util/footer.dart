import 'package:flutter/material.dart';
import 'package:internhs/constants/device.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/text.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> with SingleTickerProviderStateMixin {
  late AnimationController _controllerGS;
  late Animation<double> _animationGS;
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    _controllerGS = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationGS = CurvedAnimation(
      parent: _controllerGS,
      curve: Curves.easeInOut,
    ).drive(Tween<double>(begin: 0, end: 15));

    _controllerGS.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controllerGS.dispose();
    super.dispose();
  }

  void _onGSHover(PointerEvent details) {
    _controllerGS.forward();
    setState(() {
      hovering = true;
    });
  }

  void _onGSExit(PointerEvent details) {
    _controllerGS.reverse();
    setState(() {
      hovering = false;
    });
  }

  Widget buildButton() {
    return MouseRegion(
      onEnter: _onGSHover,
      onExit: _onGSExit,
      child: Column(
        children: [
          Container(
            width: width(context) * 0.081 + _animationGS.value,
            height: height(context) * 0.045,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: ShapeDecoration(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Email Us",
                  style: buttonTextStyle.copyWith(fontSize: 15),
                ),
                const Spacer(),
                hovering
                    ? AnimatedOpacity(
                        opacity: hovering ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: _animationGS.value > 0
                            ? Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: _animationGS.value > 10 ? 15.0 : 0.0,
                              )
                            : Container(width: 0),
                      )
                    : Container(
                        width: 0,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendEmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'xyz@email.com',
      queryParameters: {
        'subject': 'Hello from Flutter!',
        'body': 'This is a test email sent from my Flutter app.',
      },
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch $_emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height(context) * 0.03,
              ),
              Center(
                child: Container(
                  width: width(context) * 0.7,
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: height(context) * 0.03,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Text(
                    "Contact",
                    style: italicAnnouncementTextStyle.copyWith(fontSize: 36),
                  ),
                ),
              ),
              SizedBox(
                width: width(context) * 0.8,
                child: Text(
                  "Need Help? Contact InternHS @",
                  style: announcementTextStyle.copyWith(fontSize: 48),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "arnavpalawat@gmail.com",
                        style:
                            italicAnnouncementTextStyle.copyWith(fontSize: 24),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendEmail();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildButton(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Based In: ",
                              style: italicAnnouncementTextStyle.copyWith(
                                  fontSize: 24),
                            ),
                            TextSpan(
                              text: "Westford, MA",
                              style: italicAnnouncementTextStyle.copyWith(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
