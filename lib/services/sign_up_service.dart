import 'package:bank_sha/models/user_model.dart';
import 'package:bank_sha/services/user_service.dart';
import 'package:bank_sha/services/local_storage_service.dart';

class SignUpService {
  final UserService _userService;
  final LocalStorageService _localStorageService;

  SignUpService(this._userService, this._localStorageService);

  // Factory constructor to get instance with initialized services
  static Future<SignUpService> getInstance() async {
    final userService = await UserService.getInstance();
    await userService.init();
    final localStorageService = await LocalStorageService.getInstance();
    return SignUpService(userService, localStorageService);
  }

  // Register a new user with initial data
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    // Register the user, which will assign 15 initial points
    final user = await _userService.registerUser(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    
    // If address is provided, save it
    if (address != null && address.isNotEmpty) {
      await _userService.saveAddress(address);
    }
    
    // Additional registration steps could be added here
    
    return user;
  }
  
  // Complete registration and store any final data
  Future<void> completeRegistration(UserModel user) async {
    // Add timestamp for registration completion
    final updatedUser = user.copyWith(
      isVerified: true,
      lastLogin: DateTime.now(),
    );
    
    await _localStorageService.saveUser(updatedUser);
  }
  
  // Check if a user has already completed the onboarding process
  Future<bool> hasCompletedOnboarding() async {
    return await _localStorageService.getBool('completed_onboarding', defaultValue: false);
  }
  
  // Mark onboarding as completed
  Future<void> markOnboardingComplete() async {
    await _localStorageService.saveBool('completed_onboarding', true);
  }
}
