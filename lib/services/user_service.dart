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
    print("Registering user: $name ($email)");
    
    // Check if user already exists
    final existingUser = await _getUserByEmail(email);
    if (existingUser != null) {
      print("Email already in use: $email");
      throw Exception('Email already in use');
    }

    final String userId = const Uuid().v4();
    final DateTime now = DateTime.now();

    // Create user model first
    final newUser = UserModel(
      id: userId,
      name: name,
      email: email,
      phone: phone,
      points: 15,
      profilePicUrl: 'assets/img_profile.png',
      createdAt: now,
      lastLogin: now,
    );
    
    print("Created new user model: ${newUser.name} (${newUser.id})");
    
    // Convert to JSON for storage - this ensures all fields use the correct keys
    final Map<String, dynamic> userData = newUser.toJson();
    // Add password for authentication
    userData['password'] = password;

    try {
      // Save credentials for auto-login
      await _localStorage.saveCredentials(email, password);
      print("Saved credentials for: $email");

      // Save user data with password
      await _localStorage.saveUserData(userData);
      print("Saved user data for: $email");

      // Save user model
      await _localStorage.saveUser(newUser);
      print("Saved user model for: ${newUser.name}");
      
      // Notify listeners about the new user
      _notifyUserChange(newUser);
      print("Notified listeners about new user: ${newUser.name}");

      // Double-check the user was saved
      final checkUser = await _localStorage.getUser();
      if (checkUser != null) {
        print("Verification - User found: ${checkUser.name} (${checkUser.email})");
      } else {
        print("WARNING: User not found after saving!");
      }

      return newUser;
    } catch (e) {
      print("Error saving user: $e");
      throw Exception("Failed to save user: $e");
    }
  }

  // Login user
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    // For logging purposes
    print("Attempting to log in user: $email");
    
    // First, try to get user from localStorage to check if they already registered
    final userData = await _localStorage.getUserData();
    print("User data from localStorage: ${userData != null ? 'Found' : 'Not found'}");
    
    // If the user exists in localStorage and credentials match
    if (userData != null &&
        userData['email'] == email &&
        userData['password'] == password) {
      
      print("Email and password match for local user");
      
      // Get the user model
      UserModel? user = await _localStorage.getUser();
      
      // If we have a user model, update lastLogin
      if (user != null) {
        print("Found user model for: ${user.name}");
        final updatedUser = user.copyWith(lastLogin: DateTime.now());
        await _localStorage.saveUser(updatedUser);
        
        // Explicitly set login flag to true
        await _localStorage.saveBool(_localStorage.getLoginKey(), true);
        
        _notifyUserChange(updatedUser);
        return updatedUser;
      } else {
        // We have userData but no UserModel, create one
        print("Creating user model from userData");
        final newUser = UserModel(
          id: userData['id'] ?? const Uuid().v4(),
          name: userData['name'] ?? 'User',
          email: userData['email'],
          phone: userData['phone'],
          address: userData['address'],
          profilePicUrl: userData['profilePicUrl'] ?? userData['profile_picture'],
          points: userData['points'] ?? 15,
          createdAt: userData['createdAt'] != null 
              ? DateTime.parse(userData['createdAt']) 
              : DateTime.now(),
          lastLogin: DateTime.now(),
        );
        
        await _localStorage.saveUser(newUser);
        
        // Explicitly set login flag to true
        await _localStorage.saveBool(_localStorage.getLoginKey(), true);
        
        _notifyUserChange(newUser);
        return newUser;
      }
    }
    
    // If not found in localStorage, check mock data
    final mockUserData = UserDataMock.getUserByEmail(email);
    print("Mock user data: ${mockUserData != null ? 'Found' : 'Not found'}");
    
    if (mockUserData != null && mockUserData['password'] == password) {
      print("Email and password match for mock user");
      
      // Create user model from mock data
      final user = UserModel(
        id: const Uuid().v4(),
        name: mockUserData['name'],
        email: mockUserData['email'],
        phone: mockUserData['phone'],
        address: mockUserData['address'],
        profilePicUrl: mockUserData['profile_picture'],
        points: mockUserData['points'] ?? 15,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Save mock user data for future sessions
      final userData = user.toJson();
      userData['password'] = password;
      
      await _localStorage.saveUserData(userData);
      await _localStorage.saveUser(user);
      await _localStorage.saveCredentials(email, password);
      
      // Explicitly set login flag to true
      await _localStorage.saveBool(_localStorage.getLoginKey(), true);

      _notifyUserChange(user);
      return user;
    }

    print("No matching user found for email: $email");
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

  // Log out - modified to preserve user data
  Future<void> logout() async {
    // Log out the user (changing login status) without deleting data
    await _localStorage.logout();
    
    // Notify listeners that the user has logged out
    _notifyUserChange(null);
    
    print("User logged out via UserService");
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
