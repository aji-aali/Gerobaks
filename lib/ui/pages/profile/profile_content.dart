import 'package:bank_sha/ui/pages/profile/List/about_us.dart';
import 'package:bank_sha/ui/pages/profile/List/myprofile.dart';
import 'package:bank_sha/ui/pages/profile/List/privacy_policy.dart';
import 'package:bank_sha/ui/pages/profile/List/settings/settings.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/sign_in/sign_in_page.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: uicolor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),

          // Profile Info
          Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/img_profile.png'),
              ),
              const SizedBox(height: 12),
              Text(
                'Akbar',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'official@gerobaks.com',
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: regular,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Menu Items
          CustomAppMenu(
            iconURL: 'assets/ic_profile_profile.png',
            title: 'My profile',
            page: Myprofile(), // ganti dengan halaman yang sesuai
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_my_rewards.png',
            title: 'Langganan Saya',
            page: Container(), // Will be handled with navigation
            onTap: () {
              Navigator.pushNamed(context, '/my-subscription');
            },
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_kebijakan.png',
            title: 'Privacy policy',
            page: PrivacyPolicy(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_aboutus.png',
            title: 'About us',
            page: AboutUs(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_setting.png',
            title: 'Settings',
            page: const Settings(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_logout_profile.png',
            title: 'Log out',
            page: const SignInPage(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
