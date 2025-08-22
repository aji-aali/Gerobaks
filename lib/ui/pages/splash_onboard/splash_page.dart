import 'dart:async';

import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/utils/auth_helper.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/services/user_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Attempt auto-login after a brief delay to show the splash screen
    Timer(const Duration(seconds: 2), () async {
      // Try to auto-login with saved credentials
      final bool autoLoginSuccess = await AuthHelper.tryAutoLogin();
      
      if (autoLoginSuccess && mounted) {
        print("Auto-login successful, navigating to home page");
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/home',
          (route) => false,
        );
      } else if (mounted) {
        print("Auto-login failed or not attempted, navigating to onboarding");
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding',
          (route) => false,
        );
      }
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
