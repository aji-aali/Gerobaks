import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final int _amount = 150000; // Contoh nominal pembayaran
  
  String _formatAmount(int amount) {
    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${amount.toString().replaceAllMapped(formatter, (Match m) => '${m[1]}.')}';
  }
  
  void _goToPaymentPage() {
    // Buat ID transaksi unik menggunakan UUID
    final uuid = Uuid();
    final transactionId = uuid.v4();
    
    Navigator.pushNamed(
      context,
      '/qris-payment',
      arguments: {
        'amount': _amount,
        'transactionId': transactionId,
        'description': 'Pembayaran Layanan Gerobaks',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Konten checkout
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Detail layanan
                    Text(
                      'Detail Layanan',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Item layanan
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: greyColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: greenColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.delete_outline,
                                color: greenColor,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Layanan Pengangkutan Sampah',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Paket Bulanan - 4x Pengambilan',
                                  style: greyTextStyle.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatAmount(_amount),
                            style: greeTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Metode pembayaran
                    Text(
                      'Metode Pembayaran',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // QRIS option
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: greyColor.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'QRIS',
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Bayar dengan QRIS (Semua e-wallet & mobile banking)',
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: greenColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom payment summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                      Text(
                        _formatAmount(_amount),
                        style: greeTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomFilledButton(
                    title: 'Bayar Sekarang',
                    onPressed: _goToPaymentPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
