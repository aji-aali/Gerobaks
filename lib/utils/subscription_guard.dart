import 'package:flutter/material.dart';
import 'package:bank_sha/services/subscription_service.dart';
import 'package:bank_sha/ui/pages/subscription/subscription_plans_page.dart';

class SubscriptionGuard {
  static final SubscriptionService _subscriptionService = SubscriptionService();

  static Future<bool> checkSubscriptionAndShowDialog(BuildContext context) async {
    await _subscriptionService.initialize();
    final hasSubscription = _subscriptionService.hasActiveSubscription();
    
    if (!hasSubscription) {
      _showSubscriptionDialog(context);
      return false;
    }
    
    return true;
  }

  static void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berlangganan Diperlukan'),
          content: const Text(
            'Untuk menggunakan layanan ini, Anda perlu berlangganan terlebih dahulu. Silakan pilih paket yang sesuai dengan kebutuhan Anda.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionPlansPage(),
                  ),
                );
              },
              child: const Text('Berlangganan'),
            ),
          ],
        );
      },
    );
  }

  static Widget buildSubscriptionBanner(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkHasSubscription(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        
        final hasSubscription = snapshot.data ?? false;
        if (hasSubscription) {
          return const SizedBox();
        }
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[100]!, Colors.orange[50]!],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[300]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belum Berlangganan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    Text(
                      'Berlangganan untuk menikmati layanan penuh',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionPlansPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: const Text(
                  'Berlangganan',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> _checkHasSubscription() async {
    await _subscriptionService.initialize();
    return _subscriptionService.hasActiveSubscription();
  }
}
