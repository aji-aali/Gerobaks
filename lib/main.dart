import 'package:bank_sha/ui/pages/buat_keluhan/buat_keluhan_page.dart';
import 'package:bank_sha/ui/pages/profile/List/about_us.dart';
import 'package:bank_sha/ui/pages/reward/reward_page.dart';
import 'package:bank_sha/ui/pages/tracking/tracking_full_screen.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_full_screen.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_page.dart';
import 'package:bank_sha/services/notification_service.dart';
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
import 'package:bank_sha/ui/pages/sign_up/sign_up_page.dart';
import 'package:bank_sha/ui/pages/splash_onboard/splash_page.dart';
import 'package:bank_sha/ui/pages/tambah_jadwal_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('id_ID', null);
  
  // Inisialisasi layanan notifikasi secara eksplisit
  try {
    await NotificationService().init();
    print("Notifikasi berhasil diinisialisasi");
  } catch (e) {
    print("Error saat inisialisasi notifikasi: $e");
  }
  
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
        '/sign-up': (context) => SingUpPage(),
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
        '/about-us': (context) => AboutUs(),0
        'wilayah_full': (context) => const WilayahFullScreen(),
      },
    );
  }
}
