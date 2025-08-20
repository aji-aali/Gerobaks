import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/services/notification_service.dart';
import 'package:bank_sha/utils/toast_helper.dart';
import 'package:bank_sha/services/sign_up_service.dart';
import 'package:bank_sha/services/user_service.dart';
import 'package:bank_sha/models/user_model.dart';
import 'package:flutter/material.dart';

class SignUpSuccessPage extends StatefulWidget {
  const SignUpSuccessPage({super.key});

  @override
  State<SignUpSuccessPage> createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessPage> {
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Akun Berhasil\nTerdaftar',
              style: blackTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            Text(
              'Bersih bareng, Hijau bareng,\nMulai bareng kami.',
              style: greyTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: greenColor.withOpacity(0.5))
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: greenColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '+15 Poin',
                    style: greeTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Anda mendapatkan 15 poin awal!',
              style: blackTextStyle.copyWith(fontWeight: medium),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            _isLoading
                ? const CircularProgressIndicator()
                : CustomFilledButton(
                    title: 'Mulai',
                    width: 183,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      try {
                        // Menyelesaikan proses registrasi dan menyimpan data
                        final signUpService = await SignUpService.getInstance();
                        await signUpService.markOnboardingComplete();
                        
                        // Get user data from arguments or create a default user
                        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
                        if (args != null) {
                          final userService = await UserService.getInstance();
                          await userService.init();
                          
                          if (args.containsKey('email') && args.containsKey('password')) {
                            await userService.registerUser(
                              name: args['fullName'] ?? 'User',
                              email: args['email'],
                              password: args['password'],
                              phone: args['phone'],
                            );
                          }
                        }
                        
                        // Menampilkan notifikasi pendaftaran berhasil
                        await NotificationService().showNotification(
                          id: DateTime.now().millisecond,
                          title: 'Selamat Bergabung!',
                          body: 'Akun Anda telah berhasil terdaftar di Gerobaks dengan 15 poin',
                        );
                        
                        // Menampilkan toast pendaftaran berhasil
                        if (mounted) {
                          ToastHelper.showToast(
                            context: context,
                            message: 'Registrasi berhasil! +15 poin',
                            isSuccess: true,
                          );
                          
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ToastHelper.showToast(
                            context: context,
                            message: 'Error: ${e.toString()}',
                            isSuccess: false,
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
