import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bank_sha/models/user_model.dart';

class LocalStorageService {
  static const String _chatKey = 'chat_conversations';
  static const String _notificationKey = 'notifications';
  static const String _subscriptionKey = 'user_subscription';
  static const String _userKey = 'user_data';
  static const String _pointsKey = 'user_points';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _lastLoginKey = 'last_login';
  static const String _addressesKey = 'saved_addresses';
  static const String _settingsKey = 'app_settings';

  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._internal();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Chat Storage
  Future<void> saveConversations(
    List<Map<String, dynamic>> conversations,
  ) async {
    final String conversationsJson = jsonEncode(conversations);
    await _preferences!.setString(_chatKey, conversationsJson);
  }

  Future<List<Map<String, dynamic>>> getConversations() async {
    final String? conversationsJson = _preferences!.getString(_chatKey);
    if (conversationsJson != null) {
      final List<dynamic> decoded = jsonDecode(conversationsJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Notification Storage
  Future<void> saveNotifications(
    List<Map<String, dynamic>> notifications,
  ) async {
    final String notificationsJson = jsonEncode(notifications);
    await _preferences!.setString(_notificationKey, notificationsJson);
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final String? notificationsJson = _preferences!.getString(_notificationKey);
    if (notificationsJson != null) {
      final List<dynamic> decoded = jsonDecode(notificationsJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Subscription Storage
  Future<void> saveSubscription(Map<String, dynamic> subscription) async {
    final String subscriptionJson = jsonEncode(subscription);
    await _preferences!.setString(_subscriptionKey, subscriptionJson);
  }

  Future<Map<String, dynamic>?> getSubscription() async {
    final String? subscriptionJson = _preferences!.getString(_subscriptionKey);
    if (subscriptionJson != null) {
      return jsonDecode(subscriptionJson);
    }
    return null;
  }

  Future<void> clearSubscription() async {
    await _preferences!.remove(_subscriptionKey);
  }

  // Credentials Storage
  Future<void> saveCredentials(String email, String password) async {
    final credentials = {'email': email, 'password': password};
    final String credentialsJson = jsonEncode(credentials);
    await _preferences!.setString(_credentialsKey, credentialsJson);
  }

  Future<Map<String, String>?> getCredentials() async {
    final String? credentialsJson = _preferences!.getString(_credentialsKey);
    if (credentialsJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(credentialsJson);
      return {'email': decoded['email'], 'password': decoded['password']};
    }
    return null;
  }

  // User Data Storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final String userJson = jsonEncode(userData);
    await _preferences!.setString(_userKey, userJson);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final String? userJson = _preferences!.getString(_userKey);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }
  
  // Enhanced User Management
  Future<void> saveUser(UserModel user) async {
    await saveUserData(user.toJson());
    await saveBool(_isLoggedInKey, true);
    await saveString(_lastLoginKey, DateTime.now().toIso8601String());
  }
  
  Future<UserModel?> getUser() async {
    final userData = await getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }
  
  Future<void> updateUserPoints(int points) async {
    final user = await getUser();
    if (user != null) {
      final updatedUser = user.copyWith(points: points);
      await saveUser(updatedUser);
    }
  }
  
  Future<int> getUserPoints() async {
    final user = await getUser();
    return user?.points ?? 0;
  }
  
  Future<void> addPoints(int amount) async {
    final currentPoints = await getUserPoints();
    await updateUserPoints(currentPoints + amount);
  }
  
  Future<void> saveAddress(String address) async {
    final user = await getUser();
    if (user != null) {
      List<String> savedAddresses = user.savedAddresses ?? [];
      if (!savedAddresses.contains(address)) {
        savedAddresses.add(address);
        await saveUser(user.copyWith(savedAddresses: savedAddresses));
      }
    }
  }
  
  Future<List<String>> getSavedAddresses() async {
    final user = await getUser();
    return user?.savedAddresses ?? [];
  }
  
  Future<bool> isLoggedIn() async {
    return await getBool(_isLoggedInKey, defaultValue: false);
  }
  
  Future<void> logout() async {
    await remove(_isLoggedInKey);
    await remove(_userKey);
  }

  // Generic storage methods
  Future<void> saveString(String key, String value) async {
    await _preferences!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return _preferences!.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await _preferences!.setBool(key, value);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    return _preferences!.getBool(key) ?? defaultValue;
  }

  Future<void> saveInt(String key, int value) async {
    await _preferences!.setInt(key, value);
  }

  Future<int> getInt(String key, {int defaultValue = 0}) async {
    return _preferences!.getInt(key) ?? defaultValue;
  }

  Future<void> remove(String key) async {
    await _preferences!.remove(key);
  }

  Future<void> clear() async {
    await _preferences!.clear();
  }

  // Check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    final subscription = await getSubscription();
    if (subscription == null) return false;

    final endDate = DateTime.parse(subscription['endDate']);
    return DateTime.now().isBefore(endDate);
  }
}
