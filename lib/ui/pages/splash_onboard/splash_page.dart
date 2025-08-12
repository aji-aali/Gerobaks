import 'dart:async';

import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/onboarding',
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: AssetImage('assets/img_logo_trust.png'),
              image: AssetImage('assets/img_gerobaks_trust.png'),
            ),
          ),
        ),
      ),
    );
  }
}
