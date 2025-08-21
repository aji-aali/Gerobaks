import 'package:bank_sha/models/user_model.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/utils/user_data_mock.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static UserService? _instance;
  late LocalStorageService _localStorage;

  final List<Function(UserModel?)> _userChangeListeners = [];

  void addUserChangeListener(Function(UserModel?) listener) {
    _userChangeListeners.add(listener);
  }

  void removeUserChangeListener(Function(UserModel?) listener) {
    _userChangeListeners.remove(listener);
  }

  void _notifyUserChange(UserModel? user) {
    for (var listener in _userChangeListeners) {
      listener(user);
    }
  }

  // Singleton pattern
  static Future<UserService> getInstance() async {
    _instance ??= UserService._internal();
    return _instance!;
  }

  UserService._internal();

  // Initialize the service with localStorage
  Future<void> init() async {
    _localStorage = await LocalStorageService.getInstance();
  }

  // Register a new user
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    // Check if user already exists
    final existingUser = await _getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('Email already in use');
    }

    final String userId = const Uuid().v4();
    final DateTime now = DateTime.now();

    // Create user data
    final Map<String, dynamic> userData = {
      'id': userId,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'points': 15,
      'profile_picture': 'assets/img_profile.png',
      'createdAt': now.toIso8601String(),
      'lastLogin': now.toIso8601String(),
    };

    // Save credentials for auto-login
    await _localStorage.saveCredentials(email, password);

    // Save user data
    await _localStorage.saveUserData(userData);

    // Create and save user model
    final user = UserModel(
      id: userId,
      name: name,
      email: email,
      phone: phone,
      points: 15,
      profilePicUrl: 'assets/img_profile.png',
      createdAt: now,
      lastLogin: now,
    );

    await _localStorage.saveUser(user);

    return user;
  }

  // Login user
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    // Check credentials against mock data first
    final mockUserData = UserDataMock.getUserByEmail(email);

    if (mockUserData != null && mockUserData['password'] == password) {
      // Create user model from mock data
      final user = UserModel(
        id: const Uuid().v4(),
        name: mockUserData['name'],
        email: mockUserData['email'],
        phone: mockUserData['phone'],
        address: mockUserData['address'],
        profilePicUrl: mockUserData['profile_picture'],
        points: 15,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Save mock user data for future sessions
      await _localStorage.saveUserData(mockUserData);
      await _localStorage.saveUser(user);
      await _localStorage.saveCredentials(email, password);

      _notifyUserChange(user);
      return user;
    }

    // If not in mock data, try local storage
    final userData = await _localStorage.getUserData();
    if (userData != null &&
        userData['email'] == email &&
        userData['password'] == password) {
      final user = await _localStorage.getUser();
      if (user != null) {
        final updatedUser = user.copyWith(lastLogin: DateTime.now());
        await _localStorage.saveUser(updatedUser);
        _notifyUserChange(updatedUser);
        return updatedUser;
      }
    }

    return null;
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final isLoggedIn = await _localStorage.isLoggedIn();
    if (!isLoggedIn) {
      return null;
    }

    return await _localStorage.getUser();
  }

  // Update user profile
  Future<UserModel> updateUserProfile({
    String? name,
    String? phone,
    String? address,
    String? profilePicUrl,
  }) async {
    final user = await _localStorage.getUser();

    if (user == null) {
      throw Exception('User not logged in');
    }

    final updatedUser = user.copyWith(
      name: name ?? user.name,
      phone: phone ?? user.phone,
      address: address ?? user.address,
      profilePicUrl: profilePicUrl ?? user.profilePicUrl,
    );

    await _localStorage.saveUser(updatedUser);
    _notifyUserChange(updatedUser);
    return updatedUser;
  }

  // Add points to user
  Future<int> addPoints(int amount) async {
    await _localStorage.addPoints(amount);
    return await _localStorage.getUserPoints();
  }

  // Use points (deduct from user's balance)
  Future<int> usePoints(int amount) async {
    final currentPoints = await _localStorage.getUserPoints();

    if (currentPoints < amount) {
      throw Exception('Not enough points');
    }

    await _localStorage.updateUserPoints(currentPoints - amount);
    return await _localStorage.getUserPoints();
  }

  // Save an address
  Future<List<String>> saveAddress(String address) async {
    await _localStorage.saveAddress(address);
    return await _localStorage.getSavedAddresses();
  }

  // Get all saved addresses
  Future<List<String>> getSavedAddresses() async {
    return await _localStorage.getSavedAddresses();
  }

  // Log out
  Future<void> logout() async {
    await _localStorage.logout();
  }

  // Helper method to find user by email
  Future<Map<String, dynamic>?> _getUserByEmail(String email) async {
    final userData = await _localStorage.getUserData();
    if (userData != null && userData['email'] == email) {
      return userData;
    }
    return null;
  }
}
