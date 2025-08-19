import 'dart:async';
import 'dart:math';
import '../models/subscription_model.dart';
import '../services/local_storage_service.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final StreamController<UserSubscription?> _subscriptionController =
      StreamController<UserSubscription?>.broadcast();
  
  Stream<UserSubscription?> get subscriptionStream => _subscriptionController.stream;

  UserSubscription? _currentSubscription;
  late LocalStorageService _localStorage;

  Future<void> initialize() async {
    _localStorage = await LocalStorageService.getInstance();
    await _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final subscriptionData = await _localStorage.getSubscription();
    print('DEBUG: LocalStorage subscription data = $subscriptionData');
    
    if (subscriptionData != null) {
      _currentSubscription = UserSubscription.fromJson(subscriptionData);
      _subscriptionController.add(_currentSubscription);
      print('DEBUG: Loaded subscription = $_currentSubscription');
    } else {
      print('DEBUG: No subscription data found in localStorage');
      _currentSubscription = null;
      _subscriptionController.add(null);
    }
  }

  // Get available subscription plans
  List<SubscriptionPlan> getAvailablePlans() {
    return [
      SubscriptionPlan(
        id: 'basic_monthly',
        name: 'Paket Basic',
        description: 'Cocok untuk kebutuhan rumah tangga',
        price: 50000,
        durationInDays: 30,
        type: SubscriptionType.basic,
        features: [
          'Pengangkutan sampah 2x seminggu',
          'Notifikasi jadwal pengangkutan',
          'Customer support via chat',
          'Laporan bulanan',
        ],
      ),
      SubscriptionPlan(
        id: 'premium_monthly',
        name: 'Paket Premium',
        description: 'Paket terpopuler dengan layanan lengkap',
        price: 75000,
        durationInDays: 30,
        type: SubscriptionType.premium,
        isPopular: true,
        features: [
          'Pengangkutan sampah 3x seminggu',
          'Notifikasi real-time',
          'Priority customer support',
          'Laporan detail harian',
          'Recycling reward points',
          'Eco-friendly tips',
        ],
      ),
      SubscriptionPlan(
        id: 'pro_monthly',
        name: 'Paket Pro',
        description: 'Untuk kebutuhan bisnis dan komunitas',
        price: 120000,
        durationInDays: 30,
        type: SubscriptionType.pro,
        features: [
          'Pengangkutan sampah harian',
          'Real-time tracking',
          'Dedicated customer support',
          'Analytics dashboard',
          'Priority scheduling',
          'Bulk waste management',
          'Custom pickup time',
          'Business reports',
        ],
      ),
    ];
  }

  // Get available payment methods
  List<PaymentMethod> getPaymentMethods() {
    return [
      // E-Wallet Methods
      PaymentMethod(
        id: 'qris',
        name: 'QRIS',
        icon: 'assets/ic_qris.png',
        description: 'Scan QR Code untuk pembayaran instant',
        category: 'E-Wallet',
      ),
      PaymentMethod(
        id: 'shopeepay',
        name: 'ShopeePay',
        icon: 'assets/ic_shopeepay.png',
        description: 'Bayar dengan ShopeePay',
        category: 'E-Wallet',
      ),
      PaymentMethod(
        id: 'dana',
        name: 'DANA',
        icon: 'assets/ic_dana.png',
        description: 'Bayar dengan DANA',
        category: 'E-Wallet',
      ),
      PaymentMethod(
        id: 'gopay',
        name: 'GoPay',
        icon: 'assets/ic_gopay.png',
        description: 'Bayar dengan GoPay',
        category: 'E-Wallet',
      ),
      PaymentMethod(
        id: 'ovo',
        name: 'OVO',
        icon: 'assets/ic_ovo.png',
        description: 'Bayar dengan OVO',
        category: 'E-Wallet',
      ),
      // Bank Transfer Methods
      PaymentMethod(
        id: 'bca',
        name: 'BCA Virtual Account',
        icon: 'assets/img_bank_bca.png',
        description: 'Transfer melalui BCA Virtual Account',
        category: 'Bank Transfer',
      ),
      PaymentMethod(
        id: 'mandiri',
        name: 'Mandiri Virtual Account',
        icon: 'assets/img_bank_mandiri.png',
        description: 'Transfer melalui Mandiri Virtual Account',
        category: 'Bank Transfer',
      ),
      PaymentMethod(
        id: 'bni',
        name: 'BNI Virtual Account',
        icon: 'assets/img_bank_bni.png',
        description: 'Transfer melalui BNI Virtual Account',
        category: 'Bank Transfer',
      ),
      PaymentMethod(
        id: 'ocbc',
        name: 'OCBC Virtual Account',
        icon: 'assets/img_bank_ocbc.png',
        description: 'Transfer melalui OCBC Virtual Account',
        category: 'Bank Transfer',
      ),
    ];
  }

  // Process subscription payment
  Future<UserSubscription> processPayment(
    SubscriptionPlan plan,
    PaymentMethod paymentMethod,
  ) async {
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    
    final now = DateTime.now();
    final subscription = UserSubscription(
      id: _generateId(),
      planId: plan.id,
      planName: plan.name,
      startDate: now,
      endDate: now.add(Duration(days: plan.durationInDays)),
      status: PaymentStatus.success, // In real app, this would be pending initially
      amount: plan.price,
      paymentMethod: paymentMethod.name,
      transactionId: _generateTransactionId(),
    );

    // Save to local storage
    await _localStorage.saveSubscription(subscription.toJson());
    
    _currentSubscription = subscription;
    _subscriptionController.add(_currentSubscription);
    
    return subscription;
  }

  // Get current subscription
  UserSubscription? getCurrentSubscription() {
    return _currentSubscription;
  }

  // Clear subscription (for testing)
  Future<void> clearSubscription() async {
    await _localStorage.clearSubscription();
    _currentSubscription = null;
    _subscriptionController.add(null);
    print('DEBUG: Subscription cleared');
  }

  // Check if user has active subscription
  bool hasActiveSubscription() {
    return _currentSubscription?.isActive ?? false;
  }

  // Cancel subscription
  Future<void> cancelSubscription() async {
    if (_currentSubscription != null) {
      final cancelledSubscription = UserSubscription(
        id: _currentSubscription!.id,
        planId: _currentSubscription!.planId,
        planName: _currentSubscription!.planName,
        startDate: _currentSubscription!.startDate,
        endDate: DateTime.now(), // End now
        status: PaymentStatus.expired,
        amount: _currentSubscription!.amount,
        paymentMethod: _currentSubscription!.paymentMethod,
        transactionId: _currentSubscription!.transactionId,
      );
      
      await _localStorage.saveSubscription(cancelledSubscription.toJson());
      _currentSubscription = cancelledSubscription;
      _subscriptionController.add(_currentSubscription);
    }
  }

  // Extend subscription
  Future<UserSubscription> extendSubscription(SubscriptionPlan plan) async {
    if (_currentSubscription != null) {
      final startDate = _currentSubscription!.isActive 
          ? _currentSubscription!.endDate 
          : DateTime.now();
      
      final newSubscription = UserSubscription(
        id: _generateId(),
        planId: plan.id,
        planName: plan.name,
        startDate: startDate,
        endDate: startDate.add(Duration(days: plan.durationInDays)),
        status: PaymentStatus.success,
        amount: plan.price,
        transactionId: _generateTransactionId(),
      );
      
      await _localStorage.saveSubscription(newSubscription.toJson());
      _currentSubscription = newSubscription;
      _subscriptionController.add(_currentSubscription);
      
      return newSubscription;
    }
    
    throw Exception('No existing subscription to extend');
  }

  // Get subscription history (for now, just return current if exists)
  List<UserSubscription> getSubscriptionHistory() {
    return _currentSubscription != null ? [_currentSubscription!] : [];
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _generateTransactionId() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return 'TRX${List.generate(8, (index) => chars[random.nextInt(chars.length)]).join()}';
  }

  void dispose() {
    _subscriptionController.close();
  }
}
