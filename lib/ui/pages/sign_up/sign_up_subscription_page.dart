import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/models/subscription_model.dart';
import 'package:bank_sha/services/subscription_service.dart';
import 'package:bank_sha/ui/pages/subscription/payment_gateway_page.dart';

class SignUpSubscriptionPage extends StatefulWidget {
  const SignUpSubscriptionPage({super.key});

  @override
  State<SignUpSubscriptionPage> createState() => _SignUpSubscriptionPageState();
}

class _SignUpSubscriptionPageState extends State<SignUpSubscriptionPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<SubscriptionPlan> _plans = [];

  @override
  void initState() {
    super.initState();
    _plans = _subscriptionService.getAvailablePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  return _buildPlanCard(_plans[index]);
                },
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 120,
            height: 40,
            margin: const EdgeInsets.only(bottom: 20),
            child: Image.asset(
              'assets/img_gerobakss.png',
              fit: BoxFit.contain,
            ),
          ),
          Text(
            'Selamat Datang! 🎉',
            style: blackTextStyle.copyWith(
              fontSize: 24,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih paket langganan untuk mendapatkan pengalaman terbaik dengan Gerobaks',
            style: greyTextStyle.copyWith(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: greenColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: greenColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: greenColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Anda bisa melewati step ini dan berlangganan kapan saja melalui menu Profile',
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                      color: greenColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.isPopular ? greenColor : Colors.grey.withOpacity(0.3),
          width: plan.isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Popular badge
          if (plan.isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: greenColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Text(
                  'PALING POPULER',
                  style: whiteTextStyle.copyWith(
                    fontSize: 10,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getPlanColor(plan.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getPlanEmoji(plan.type),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: blackTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: semiBold,
                            ),
                          ),
                          Text(
                            plan.description,
                            style: greyTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Price
                Row(
                  children: [
                    Text(
                      plan.formattedPrice,
                      style: blackTextStyle.copyWith(
                        fontSize: 28,
                        fontWeight: bold,
                        color: _getPlanColor(plan.type),
                      ),
                    ),
                    Text(
                      '/${plan.durationText}',
                      style: greyTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Features
                ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: greenColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: blackTextStyle.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 20),
                
                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _selectPlan(plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getPlanColor(plan.type),
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Pilih ${plan.name}',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Skip button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _skipSubscription,
              style: OutlinedButton.styleFrom(
                foregroundColor: greyColor,
                side: BorderSide(color: greyColor.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Nanti Saja',
                style: greyTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Anda bisa berlangganan kapan saja melalui menu Profile',
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getPlanEmoji(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.basic:
        return '🏠';
      case SubscriptionType.premium:
        return '⭐';
      case SubscriptionType.pro:
        return '🏢';
    }
  }

  Color _getPlanColor(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.basic:
        return Colors.blue;
      case SubscriptionType.premium:
        return Colors.purple;
      case SubscriptionType.pro:
        return Colors.amber[700]!;
    }
  }

  void _selectPlan(SubscriptionPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentGatewayPage(
          plan: plan,
          isFromSignup: true,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Payment successful, go to home
        _completeSignup(hasSubscription: true);
      }
    });
  }

  void _skipSubscription() {
    _completeSignup(hasSubscription: false);
  }

  void _completeSignup({required bool hasSubscription}) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hasSubscription 
            ? 'Selamat! Akun Anda berhasil dibuat dengan langganan aktif'
            : 'Akun Anda berhasil dibuat. Anda bisa berlangganan kapan saja',
          style: whiteTextStyle,
        ),
        backgroundColor: greenColor,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate to sign-in page
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/sign-in',
      (route) => false,
    );
  }
}
