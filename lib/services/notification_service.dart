import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  // Flag untuk mencegah multiple init
  bool _initialized = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Cek apakah sudah diinisialisasi
    if (_initialized) {
      debugPrint('NotificationService sudah diinisialisasi sebelumnya');
      return;
    }
    
    // Pengaturan untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    // Pengaturan untuk iOS
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    // Inisialisasi pengaturan
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Inisialisasi plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Callback saat notifikasi ditekan
        debugPrint('Notifikasi ditekan: ${notificationResponse.payload}');
      },
    );
    
    // Buat channel notifikasi dengan pengaturan suara khusus
    await _createNotificationChannel();
    
    // Set flag inisialisasi berhasil
    _initialized = true;
    debugPrint('NotificationService berhasil diinisialisasi');
  }
  
  // Membuat channel khusus untuk Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'gerobaks_channel', // id
      'Gerobaks Notifications', // name
      description: 'Notifikasi untuk aplikasi Gerobaks', // description
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    try {
      // Membuat channel notifikasi khusus
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
          
      print('Channel notifikasi berhasil dibuat: ${channel.id}');
      print('Sound file yang digunakan: notification_sound.wav');
    } catch (e) {
      print('Error saat membuat notification channel: $e');
    }
  }

  // Fungsi untuk meminta izin notifikasi
  Future<bool> _requestPermissions() async {
    if (flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>() !=
        null) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
                  
      // Meminta izin untuk Android 13 ke atas
      final bool? granted = await androidImplementation?.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  // Fungsi untuk menampilkan notifikasi
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Debug info
    print('===== DEBUG NOTIFIKASI =====');
    print('ID Notifikasi: $id');
    print('Judul: $title');
    print('Isi: $body');
    
    // Meminta izin terlebih dahulu
    bool permissionGranted = await _requestPermissions();
    print('Izin notifikasi diberikan: $permissionGranted');
    
    if (!permissionGranted) {
      print('Izin notifikasi tidak diberikan, notifikasi mungkin tidak akan muncul');
    }

    // Channel untuk Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'gerobaks_channel', // ID channel
      'Gerobaks Notifications', // Nama channel
      channelDescription: 'Notifikasi untuk aplikasi Gerobaks',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
      enableVibration: true,
      enableLights: true,
      channelShowBadge: true,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );
    
    print('Android sound file: notification_sound.wav di folder raw');

    // Channel untuk iOS
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification_sound.wav',
    );
    
    print('iOS sound file: notification_sound.wav di folder Resources');

    // Pengaturan platform
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    try {
      // Tampilkan notifikasi
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
      print('Notifikasi berhasil ditampilkan');
    } catch (e) {
      print('Error menampilkan notifikasi: $e');
      print('Stack trace: ${StackTrace.current}');
    }
    print('===== END DEBUG NOTIFIKASI =====');
  }

  // Fungsi untuk notifikasi login berhasil
  Future<void> showLoginSuccessNotification() async {
    await showNotification(
      id: DateTime.now().millisecond, // ID unik berdasarkan waktu
      title: 'Login Berhasil',
      body: 'Anda berhasil login ke Gerobaks',
    );
  }
  
  // Fungsi untuk notifikasi pendaftaran berhasil
  Future<void> showSignUpSuccessNotification() async {
    await showNotification(
      id: DateTime.now().millisecond, // ID unik berdasarkan waktu
      title: 'Selamat Bergabung!',
      body: 'Akun Anda telah berhasil terdaftar di Gerobaks',
    );
  }
}
