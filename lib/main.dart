import 'package:bank_sha/ui/pages/buat_keluhan/buat_keluhan_page.dart';
import 'package:bank_sha/ui/pages/profile/List/about_us.dart';
import 'package:bank_sha/ui/pages/reward/reward_page.dart';
import 'package:bank_sha/ui/pages/tracking/tracking_full_screen.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_full_screen.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:bank_sha/ui/pages/home/home_page.dart';
import 'package:bank_sha/ui/pages/tracking/tracking_page.dart';
import 'package:bank_sha/ui/pages/noftification_page.dart';
import 'package:bank_sha/ui/pages/splash_onboard/onboarding_page.dart';
import 'package:bank_sha/ui/pages/sign_in/sign_in_page.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_success_page.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_uplod_profile_page.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_1.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_2.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_3.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_4.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_5.dart';
import 'package:bank_sha/ui/pages/splash_onboard/splash_page.dart';
import 'package:bank_sha/ui/pages/tambah_jadwal_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('id_ID', null);
  print('[DEBUG] ORS_API_KEY: ${dotenv.env['ORS_API_KEY']}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashPage(),
        '/onboarding': (context) => OnboardingPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up-batch-1': (context) => const SignUpBatch1Page(),
        '/sign-up-batch-2': (context) => const SignUpBatch2Page(),
        '/sign-up-batch-3': (context) => const SignUpBatch3Page(),
        '/sign-up-batch-4': (context) => const SignUpBatch4Page(),
        '/sign-up-batch-5': (context) => const SignUpBatch5Page(),
        '/sign-up-uplod-profile': (context) => const SignUpUplodProfilePage(),
        '/sign-up-success': (context) => SignUpSuccessPage(),
        '/home': (context) => HomePage(),
        '/notif': (context) => NotificationPage(),
        '/tambah-jadwal': (context) => const TambahJadwalPage(),
        '/tracking': (context) => const TrackingPage(),
        '/wilayah': (context) => const WilayahPage(),
        '/reward': (context) => const RewardPage(),
        '/tracking_full': (context) => const TrackingFullScreen(),
        '/buatKeluhan': (context) => const BuatKeluhanPage(),
        '/about-us': (context) => AboutUs(),
        'wilayah_full': (context) => const WilayahFullScreen(),
      },
    );
  }
}
