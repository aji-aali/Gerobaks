import 'package:bank_sha/models/user_model.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static UserService? _instance;
  late LocalStorageService _localStorage;
  
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
    
    // Create new user with 15 initial points
    final user = UserModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      points: 15, // New users start with 15 points
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    
    // Save user credentials separately for login
    await _localStorage.saveUserData({
      'id': user.id,
      'email': email,
      'password': password, // In a real app, hash this password
      'name': name,
    });
    
    // Save complete user object
    await _localStorage.saveUser(user);
    
    return user;
  }
  
  // Login user
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final userData = await _localStorage.getUserData();
    
    if (userData == null ||
        userData['email'] != email ||
        userData['password'] != password) {
      throw Exception('Invalid credentials');
    }
    
    // Get the full user model
    final user = await _localStorage.getUser();
    
    if (user == null) {
      throw Exception('User data not found');
    }
    
    // Update last login time
    final updatedUser = user.copyWith(lastLogin: DateTime.now());
    await _localStorage.saveUser(updatedUser);
    
    return updatedUser;
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
