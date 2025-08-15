import 'dart:async';

import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpBatch2Page extends StatefulWidget {
  const SignUpBatch2Page({super.key});

  @override
  State<SignUpBatch2Page> createState() => _SignUpBatch2PageState();
}

class _SignUpBatch2PageState extends State<SignUpBatch2Page> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  Timer? _timer;
  int _countDown = 120; // 2 minutes
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _countDown = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String get _formattedTime {
    int minutes = _countDown ~/ 60;
    int seconds = _countDown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final phone = arguments?['phone'] ?? '';

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [

                  // Logo Section with proper spacing
                  const SizedBox(height: 60),

                  // Logo GEROBAKS
                  Container(
                    width: 250,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(
                      'assets/img_gerobakss.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: greenColor,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'GEROBAKS',
                              style: greeTextStyle.copyWith(
                                fontSize: 28,
                                fontWeight: bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Verifikasi OTP',
                    style: blackTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Langkah 2 dari 5 - Konfirmasi Nomor HP',
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Masukkan kode OTP yang dikirim ke\n$phone',
                    textAlign: TextAlign.center,
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Progress Indicator
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: greyColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        height: 50,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: greyColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: greenColor, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: greyColor.withOpacity(0.5)),
                            ),
                          ),
                          style: blackTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: semiBold,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _otpFocusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 30),

                  // Timer and Resend
                  if (!_canResend)
                    Text(
                      'Kirim ulang OTP dalam $_formattedTime',
                      style: greyTextStyle.copyWith(fontSize: 14),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        _startTimer();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Kode OTP telah dikirim ulang',
                              style: whiteTextStyle.copyWith(fontSize: 14),
                            ),
                            backgroundColor: greenColor,
                          ),
                        );
                      },
                      child: Text(
                        'Kirim Ulang OTP',
                        style: greeTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),

                  const Spacer(),

                  const SizedBox(height: 30),

                  // Verify Button
                  CustomFilledButton(
                    title: 'Verifikasi',
                    onPressed: () {
                      String otpCode = _otpControllers
                          .map((controller) => controller.text)
                          .join();

                      if (otpCode.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Masukkan kode OTP lengkap',
                              style: whiteTextStyle.copyWith(fontSize: 14),
                            ),
                            backgroundColor: redcolor,
                          ),
                        );
                        return;
                      }

                      // Pass all data to next page
                      Navigator.pushNamed(
                        context,
                        '/sign-up-batch-3',
                        arguments: {
                          ...?arguments,
                          'otpCode': otpCode,
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-in');
                        },
                        child: Text(
                          'Sign In',
                          style: greeTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}