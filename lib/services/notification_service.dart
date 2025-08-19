import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../services/gemini_ai_service.dart';
import '../services/local_storage_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  Timer? _dailyPantunTimer;
  Timer? _routinePantunTimer;
  bool _isInitialized = false;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannels();
    await _scheduleDailyPantun();
    await _startRoutinePantunNotifications();
    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    // Chat notifications channel
    const chatChannel = AndroidNotificationChannel(
      'chat_notifications',
      'Chat Notifications',
      description: 'Notifications for new chat messages',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    // Pickup notifications channel
    const pickupChannel = AndroidNotificationChannel(
      'pickup_notifications',
      'Pickup Notifications',
      description: 'Notifications for waste pickup schedules',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('pickup_sound'),
    );

    // Daily pantun channel
    const pantunChannel = AndroidNotificationChannel(
      'daily_pantun',
      'Daily Pantun',
      description: 'Daily motivational pantun about waste management',
      importance: Importance.defaultImportance,
    );

    // Routine pantun channel
    const routinePantunChannel = AndroidNotificationChannel(
      'routine_pantun',
      'Routine Pantun',
      description: 'Regular motivational pantun reminders every 30-60 minutes',
      importance: Importance.low,
    );

    // Subscription notifications channel
    const subscriptionChannel = AndroidNotificationChannel(
      'subscription_notifications',
      'Subscription Notifications',
      description: 'Notifications about subscription status and renewals',
      importance: Importance.high,
    );

    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(chatChannel);
    
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(pickupChannel);
    
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(pantunChannel);
    
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(routinePantunChannel);
    
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(subscriptionChannel);
  }

  Future<void> _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      if (payload.startsWith('chat:')) {
        // Navigate to specific chat
        // This will be handled by main app navigation
      } else if (payload.startsWith('pickup:')) {
        // Navigate to tracking page
      } else if (payload.startsWith('subscription:')) {
        // Navigate to subscription page
      }
    }
  }

  // Chat notification with subscription badge
  Future<void> showChatNotification({
    required String conversationId,
    required String senderName,
    required String message,
    required String userSubscriptionStatus,
  }) async {
    if (!_isInitialized) return;

    final subscriptionBadge = _getSubscriptionBadge(userSubscriptionStatus);
    String title;
    
    if (userSubscriptionStatus.toLowerCase() == 'none' || userSubscriptionStatus.toLowerCase() == '') {
      title = '$subscriptionBadge $senderName (Anda belum berlangganan)';
    } else {
      title = '$subscriptionBadge $senderName';
    }
    
    final androidDetails = AndroidNotificationDetails(
      'chat_notifications',
      'Chat Notifications',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      styleInformation: BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
      color: _getSubscriptionColor(userSubscriptionStatus),
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      conversationId.hashCode,
      title,
      message.length > 100 ? '${message.substring(0, 100)}...' : message,
      details,
      payload: 'chat:$conversationId',
    );
  }

  // Pickup notification
  Future<void> showPickupNotification({
    required String title,
    required String message,
    required DateTime scheduledTime,
    String? address,
  }) async {
    if (!_isInitialized) return;

    final androidDetails = AndroidNotificationDetails(
      'pickup_notifications',
      'Pickup Notifications',
      channelDescription: 'Notifications for waste pickup schedules',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      when: scheduledTime.millisecondsSinceEpoch,
      styleInformation: BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        contentTitle: '🚛 $title',
        htmlFormatContentTitle: true,
        summaryText: address,
      ),
      color: Colors.green,
      colorized: true,
      actions: [
        const AndroidNotificationAction(
          'track_pickup',
          'Track Pickup',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'reschedule',
          'Reschedule',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      scheduledTime.hashCode,
      '🚛 $title',
      message,
      details,
      payload: 'pickup:${scheduledTime.toIso8601String()}',
    );
  }

  // Daily pantun notification
  Future<void> _scheduleDailyPantun() async {
    final storage = await LocalStorageService.getInstance();
    final lastPantunDate = await storage.getString('last_pantun_date');
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastPantunDate != today) {
      // Show pantun immediately instead of scheduling
      await _showDailyPantunNow();
    }
  }

  Future<void> _showDailyPantunNow() async {
    try {
      final geminiService = GeminiAIService();
      final pantun = await geminiService.generateDailyPantun();
      
      final androidDetails = AndroidNotificationDetails(
        'daily_pantun',
        'Daily Pantun',
        channelDescription: 'Daily motivational pantun about waste management',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: BigTextStyleInformation(
          pantun,
          htmlFormatBigText: true,
          contentTitle: '🌱 Pantun Hari Ini dari Gerobaks',
          htmlFormatContentTitle: true,
        ),
        color: Colors.green[400],
        colorized: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        'daily_pantun'.hashCode,
        '🌱 Pantun Hari Ini dari Gerobaks',
        pantun,
        details,
      );

      // Mark today as pantun sent
      final storage = await LocalStorageService.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      await storage.saveString('last_pantun_date', today);
      
    } catch (e) {
      print('Error showing pantun notification: $e');
      // Fallback with simple pantun
      await _showFallbackPantun();
    }
  }

  Future<void> _showFallbackPantun() async {
    final pantuns = [
      'Bunga melati harum semerbak\nPagi hari burung berkicau\nSampah dipilah jangan sepak\nLingkungan bersih hati pun rau',
      'Gerobaks hadir solusi besar\nSampah terkelola hidup makin pas\nDaur ulang sampah jadi guna\nBumi lestari untuk nanti',
    ];
    
    final randomPantun = pantuns[Random().nextInt(pantuns.length)];
    
    final androidDetails = AndroidNotificationDetails(
      'daily_pantun',
      'Daily Pantun',
      channelDescription: 'Daily motivational pantun about waste management',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      styleInformation: BigTextStyleInformation(
        randomPantun,
        htmlFormatBigText: true,
        contentTitle: '🌱 Pantun Hari Ini dari Gerobaks',
        htmlFormatContentTitle: true,
      ),
      color: Colors.green[400],
      colorized: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      'daily_pantun'.hashCode,
      '🌱 Pantun Hari Ini dari Gerobaks',
      randomPantun,
      details,
    );
  }

  // Start routine pantun notifications every 30-60 minutes
  Future<void> _startRoutinePantunNotifications() async {
    final isEnabled = await isRoutinePantunEnabled();
    if (isEnabled) {
      _scheduleNextRoutinePantun();
    }
  }

  void _scheduleNextRoutinePantun() {
    // Cancel previous timer if exists
    _routinePantunTimer?.cancel();
    
    // Random interval between 30-60 minutes
    final random = Random();
    final minutesInterval = 30 + random.nextInt(31); // 30-60 minutes
    final duration = Duration(minutes: minutesInterval);
    
    _routinePantunTimer = Timer(duration, () async {
      // Check if routine pantun is still enabled before showing
      final isEnabled = await isRoutinePantunEnabled();
      if (isEnabled) {
        await _showRoutinePantunNotification();
        _scheduleNextRoutinePantun(); // Schedule next one
      }
    });
  }

  Future<void> _showRoutinePantunNotification() async {
    if (!_isInitialized) return;
    
    final pantunList = [
      // Pantun tentang kebersihan lingkungan
      'Bunga melati harum semerbak\nPagi hari burung berkicau\nSampah dipilah jangan abaikan\nLingkungan bersih hati pun rau',
      
      'Kupu kupu hinggap di bunga\nWarna warni sangat indah\nGerobaks hadir untuk kita\nSampah teratur hidup berubah',
      
      'Anak ayam turun sepuluh\nMati satu tinggal sembilan\nJadwal sampah jangan terlupa\nGerobaks siap setiap hari',
      
      'Burung merpati terbang tinggi\nHinggap di dahan beringin\nYuk gunakan aplikasi ini\nSampah bersih jadi rejeki',
      
      'Bintang di langit berkelip\nCahayanya sangat terang\nSampah organik dan plastik\nPilah yuk jangan bercampur',
      
      // Pantun motivasi menggunakan aplikasi
      'Pisang emas dibawa berlayar\nMasak dibeli dari negeri\nGerobaks mudah untuk diandalkan\nBuka aplikasi sekarang juga',
      
      'Kalau ada jarum patah\nJangan disimpan dalam peti\nKalau sampah sudah menumpuk\nSegera buat jadwal di Gerobaks',
      
      'Tepung tapioka dibuat onde\nRasanya manis sangat enak\nJangan lupa buka Gerobaks\nJadwal sampah mudah dibuat',
      
      'Ikan paus berenang di laut\nGelombang besar tak mengapa\nSampah menumpuk jangan biarkan\nGerobaks solusi terdepan',
      
      'Pohon mangga berbuah lebat\nRasanya manis menyegarkan\nRutin pakai aplikasi ini\nSampah bersih lingkungan sehat',
      
      // Pantun reward dan manfaat
      'Burung elang terbang melayang\nSayapnya lebar mengembang\nKumpulkan poin dari Gerobaks\nReward menarik siap menanti',
      
      'Mentimun muda dimakan ulat\nDaunnya layu tak berbunga\nSemakin rajin pakai Gerobaks\nPoin reward semakin bertambah',
      
      'Kapal layar berlayar jauh\nAngin kencang mendorong cepat\nGerobaks bantu kelola sampah\nLingkungan bersih hidup sehat',
      
      'Bebek berenang di kolam\nAirnya jernih tak beriak\nRajin jadwal angkut sampah\nHidup bersih jadi berkah',
      
      'Sinar matahari sangat terang\nMenyinari bumi penuh kasih\nGerobaks hadir solusi lengkap\nSampah teratur hidup bersih'
    ];
    
    final random = Random();
    final selectedPantun = pantunList[random.nextInt(pantunList.length)];
    
    final androidDetails = AndroidNotificationDetails(
      'routine_pantun',
      'Routine Pantun',
      channelDescription: 'Regular motivational pantun reminders every 30-60 minutes',
      importance: Importance.low,
      priority: Priority.low,
      styleInformation: BigTextStyleInformation(
        selectedPantun,
        htmlFormatBigText: true,
        contentTitle: '🌿 Pantun Motivasi Gerobaks',
        htmlFormatContentTitle: true,
      ),
      color: Colors.green[300],
      colorized: true,
      autoCancel: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false, // Don't add badge for routine notifications
      presentSound: false, // Silent notification
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use different ID each time to avoid overwriting
    final notificationId = DateTime.now().millisecondsSinceEpoch % 1000000;
    
    await _notifications.show(
      notificationId,
      '🌿 Pantun Motivasi Gerobaks',
      selectedPantun.split('\n').join(' • '), // Convert to single line for preview
      details,
      payload: 'routine_pantun',
    );
  }

  // Subscription notification
  Future<void> showSubscriptionNotification({
    required String title,
    required String message,
    required String subscriptionStatus,
    String? actionUrl,
  }) async {
    if (!_isInitialized) return;

    final badge = _getSubscriptionBadge(subscriptionStatus);
    String finalTitle;
    
    if (subscriptionStatus.toLowerCase() == 'none' || subscriptionStatus.toLowerCase() == '') {
      finalTitle = '$badge $title - Anda belum berlangganan';
    } else {
      finalTitle = '$badge $title';
    }
    
    final androidDetails = AndroidNotificationDetails(
      'subscription_notifications',
      'Subscription Notifications',
      channelDescription: 'Notifications about subscription status and renewals',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        contentTitle: finalTitle,
        htmlFormatContentTitle: true,
      ),
      color: _getSubscriptionColor(subscriptionStatus),
      colorized: true,
      actions: actionUrl != null ? [
        const AndroidNotificationAction(
          'open_subscription',
          'Kelola Langganan',
          showsUserInterface: true,
        ),
      ] : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      title.hashCode,
      '$badge $title',
      message,
      details,
      payload: actionUrl != null ? 'subscription:$actionUrl' : null,
    );
  }

  String _getSubscriptionBadge(String status) {
    switch (status.toLowerCase()) {
      case 'basic':
        return '🏠';
      case 'premium':
        return '⭐';
      case 'pro':
        return '🏢';
      default:
        return '!'; // Warning icon for no subscription
    }
  }

  Color _getSubscriptionColor(String status) {
    switch (status.toLowerCase()) {
      case 'basic':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      case 'pro':
        return Colors.amber;
      default:
        return Colors.red; // Red for no subscription to draw attention
    }
  }

  // Schedule pickup reminder (immediate notification)
  Future<void> schedulePickupReminder({
    required DateTime pickupTime,
    required String address,
  }) async {
    final reminderTime = pickupTime.subtract(const Duration(minutes: 30));
    
    if (reminderTime.isAfter(DateTime.now())) {
      // Show immediate notification instead of scheduling
      await _notifications.show(
        pickupTime.hashCode,
        '🚛 Pickup Reminder',
        'Your waste pickup is scheduled for ${pickupTime.hour}:${pickupTime.minute.toString().padLeft(2, '0')} at $address',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'pickup_notifications',
            'Pickup Notifications',
            channelDescription: 'Notifications for waste pickup schedules',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'pickup:${pickupTime.toIso8601String()}',
      );
    }
  }

  // Legacy methods for backward compatibility
  Future<void> init() async {
    await initialize();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) return;

    const androidDetails = AndroidNotificationDetails(
      'gerobaks_channel',
      'Gerobaks Notifications',
      channelDescription: 'Notifikasi untuk aplikasi Gerobaks',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> showLoginSuccessNotification() async {
    await showNotification(
      id: DateTime.now().millisecond,
      title: 'Login Berhasil',
      body: 'Anda berhasil login ke Gerobaks',
    );
  }

  Future<void> showSignUpSuccessNotification() async {
    await showNotification(
      id: DateTime.now().millisecond,
      title: 'Selamat Bergabung!',
      body: 'Akun Gerobaks Anda berhasil dibuat. Selamat menjadi bagian dari komunitas hijau!',
    );
  }

  // Show subscription reminder for non-subscribed users
  Future<void> showSubscriptionReminder() async {
    if (!_isInitialized) return;

    const title = 'Dapatkan Pengalaman Terbaik!';
    const message = 'Berlangganan sekarang untuk akses penuh ke semua fitur Gerobaks dan layanan premium.';
    
    final androidDetails = AndroidNotificationDetails(
      'subscription_notifications',
      'Subscription Notifications',
      channelDescription: 'Notifications about subscription status and renewals',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: const BigTextStyleInformation(
        message,
        htmlFormatBigText: true,
        contentTitle: '! $title - Anda belum berlangganan',
        htmlFormatContentTitle: true,
      ),
      color: Colors.red,
      colorized: true,
      actions: const [
        AndroidNotificationAction(
          'open_subscription',
          'Berlangganan Sekarang',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'remind_later',
          'Ingatkan Nanti',
          showsUserInterface: false,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      'subscription_reminder'.hashCode,
      '! $title',
      message,
      details,
      payload: 'subscription:/subscription-plans',
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // Enable/disable routine pantun notifications
  Future<void> enableRoutinePantun() async {
    final storage = await LocalStorageService.getInstance();
    await storage.saveBool('routine_pantun_enabled', true);
    await _startRoutinePantunNotifications();
  }

  Future<void> disableRoutinePantun() async {
    final storage = await LocalStorageService.getInstance();
    await storage.saveBool('routine_pantun_enabled', false);
    _routinePantunTimer?.cancel();
  }

  Future<bool> isRoutinePantunEnabled() async {
    final storage = await LocalStorageService.getInstance();
    return await storage.getBool('routine_pantun_enabled', defaultValue: true);
  }

  // Test method to show routine pantun immediately
  Future<void> showTestRoutinePantun() async {
    await _showRoutinePantunNotification();
  }

  void dispose() {
    _dailyPantunTimer?.cancel();
    _routinePantunTimer?.cancel();
  }
}
