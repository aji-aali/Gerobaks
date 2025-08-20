import 'package:bank_sha/ui/pages/buat_keluhan/buat_keluhan_page.dart';
import 'package:bank_sha/ui/pages/profile/List/about_us.dart';
import 'package:bank_sha/ui/pages/reward/reward_page.dart';
import 'package:bank_sha/ui/pages/tracking/tracking_full_screen.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_full_screen.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_page.dart';
import 'package:bank_sha/ui/pages/chat/chat_list_page.dart';
import 'package:bank_sha/ui/pages/subscription/subscription_plans_page.dart';
import 'package:bank_sha/ui/pages/subscription/my_subscription_page.dart';
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
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_1.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_2.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_3.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_page_batch_4.dart';
import 'package:bank_sha/ui/pages/sign_up/sign_up_subscription_page.dart';
import 'package:bank_sha/ui/pages/splash_onboard/splash_page.dart';
import 'package:bank_sha/ui/pages/tambah_jadwal_page.dart';

import 'package:bank_sha/services/gemini_ai_service.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/services/subscription_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('id_ID', null);
  
  // Inisialisasi LocalStorage Service
  try {
    await LocalStorageService.getInstance();
    print("LocalStorage berhasil diinisialisasi");
    
    // Inisialisasi SubscriptionService setelah LocalStorage
    await SubscriptionService().initialize();
    print("SubscriptionService berhasil diinisialisasi");
  } catch (e) {
    print("Error saat inisialisasi services: $e");
  }
  
  // Inisialisasi layanan notifikasi secara eksplisit
  try {
    await NotificationService().initialize();
    print("Notifikasi berhasil diinisialisasi");
  } catch (e) {
    print("Error saat inisialisasi notifikasi: $e");
  }

  // Inisialisasi layanan AI Gemini
  try {
    await GeminiAIService().initialize();
    print("Gemini AI berhasil diinisialisasi");
  } catch (e) {
    print("Error saat inisialisasi Gemini AI: $e");
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
        // Sign up batch pages - urutan proses pendaftaran baru
        '/sign-up-batch-1': (context) => const SignUpBatch1Page(),
        '/sign-up-batch-2': (context) => const SignUpBatch2Page(),
        '/sign-up-batch-3': (context) => const SignUpBatch3Page(),
        '/sign-up-batch-4': (context) => const SignUpBatch4Page(),
        '/sign-up-subscription': (context) => const SignUpSubscriptionPage(),
        // Batch 5 removed - redirect to subscription page after batch 4
        // Redirect old sign-up route to the new batch flow
        '/sign-up': (context) => const SignUpBatch1Page(), // Redirect ke halaman batch 1
        '/sign-up-uplod-profile': (context) => const SignUpUplodProfilePage(),
        '/sign-up-success': (context) => SignUpSuccessPage(),
        '/home': (context) => HomePage(),
        '/notif': (context) => NotificationPage(),
        '/chat': (context) => ChatListPage(),
        '/subscription-plans': (context) => SubscriptionPlansPage(),
        '/my-subscription': (context) => MySubscriptionPage(),
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
