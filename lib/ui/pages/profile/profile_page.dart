import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/profile/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      appBar: const CustomAppHeader(
        title: 'Profile',
        imageAssetPath: 'assets/ic_edit_profile2.png',
        onActionPressed: null, // Atau tambahkan fungsi kalau perlu
      ),
      body: const ProfileContent(),
    );
  }
}
