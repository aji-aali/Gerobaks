import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/ui/widgets/shared/form.dart';
import 'package:bank_sha/ui/widgets/shared/layout.dart';
import 'package:flutter/material.dart';

class SingUpPage extends StatelessWidget {
  const SingUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Container(
            width: 169,
            height: 88,
            margin: const EdgeInsets.only(top: 100, bottom: 50),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img_logo_name.png'),
              ),
            ),
          ),
          Text(
            'Sign Up',
            style: blackTextStyle.copyWith(fontSize: 25, fontWeight: semiBold),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomGoogleButton(
                  title: 'Sign Up With Google',
                  width: double.infinity,
                  onPressed: () {},
                  imagePath: 'assets/img_logo_google.png',
                ),
                CustomDividerLayout(title: 'OR'),
                // Note Email Input
                const CustomFormField(title: 'Full Name'),
                const SizedBox(height: 16),
                // Note Password Input
                const CustomFormField(title: 'Email Address'),
                const SizedBox(height: 8),
                CustomFormField(title: 'Password', obscureText: true),

                const SizedBox(height: 30),
                CustomFilledButton(
                  title: 'Continue',
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-up-uplod-profile');
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 35),
          CustomTextButton(
            title: 'Sign In',
            onPressed: () {
              Navigator.pushNamed(context, '/sign-in');
            },
          ),
        ],
      ),
    );
  }
}
