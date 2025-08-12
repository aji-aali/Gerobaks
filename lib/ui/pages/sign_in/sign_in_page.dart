import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/ui/widgets/shared/form.dart';
import 'package:bank_sha/ui/widgets/shared/layout.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          // Logo diperkecil ukurannya tanpa mengubah jarak
          Container(
            width: 50, // diperkecil dari 169
            height: 50, // diperkecil dari 88
            margin: const EdgeInsets.only(top: 110, bottom: 70),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img_gerobakss.png'),
                fit: BoxFit.contain, // pastikan gambar tidak terpotong
              ),
            ),
          ),
          Text(
            'Sign In',
            style: blackTextStyle.copyWith(fontSize: 25, fontWeight: semiBold),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomGoogleButton(
                  title: 'Sign in With Google',
                  width: double.infinity,
                  onPressed: () {},
                  imagePath: 'assets/img_logo_google.png',
                ),
                const CustomDividerLayout(title: 'OR'),
                // Note Email Input
                const CustomFormField(title: 'Email Address'),
                const SizedBox(height: 16),
                // Note Password Input
                const CustomFormField(title: 'Password', obscureText: true),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lupa password',
                    style: greentextstyle2.copyWith(
                      fontWeight: regular,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomFilledButton(
                  title: 'Sign In',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          CustomTextButton(
            title: 'Create New Account',
            onPressed: () {
              Navigator.pushNamed(context, '/sign-up');
            },
          ),
        ],
      ),
    );
  }
}
