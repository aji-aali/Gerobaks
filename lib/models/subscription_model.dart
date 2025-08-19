enum SubscriptionType {
  basic,
  premium,
  pro,
}

enum PaymentStatus {
  pending,
  success,
  failed,
  expired,
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationInDays;
  final SubscriptionType type;
  final List<String> features;
  final bool isPopular;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInDays,
    required this.type,
    required this.features,
    this.isPopular = false,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      durationInDays: json['durationInDays'],
      type: SubscriptionType.values.firstWhere(
        (e) => e.toString() == 'SubscriptionType.${json['type']}',
        orElse: () => SubscriptionType.basic,
      ),
      features: List<String>.from(json['features']),
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationInDays': durationInDays,
      'type': type.toString().split('.').last,
      'features': features,
      'isPopular': isPopular,
    };
  }

  String get formattedPrice => 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  String get durationText => durationInDays == 30 ? '1 Bulan' : '$durationInDays Hari';
}

class UserSubscription {
  final String id;
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final PaymentStatus status;
  final double amount;
  final String? paymentMethod;
  final String? transactionId;

  UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.amount,
    this.paymentMethod,
    this.transactionId,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'],
      planId: json['planId'],
      planName: json['planName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      amount: json['amount'].toDouble(),
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'planName': planName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
    };
  }

  bool get isActive => DateTime.now().isBefore(endDate) && status == PaymentStatus.success;
  bool get isExpired => DateTime.now().isAfter(endDate);
  int get daysRemaining => isActive ? endDate.difference(DateTime.now()).inDays : 0;
  
  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Menunggu Pembayaran';
      case PaymentStatus.success:
        return isExpired ? 'Berakhir' : 'Aktif';
      case PaymentStatus.failed:
        return 'Gagal';
      case PaymentStatus.expired:
        return 'Berakhir';
    }
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool isActive;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.isActive = true,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'isActive': isActive,
    };
  }
}
