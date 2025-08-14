import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';

class Myprofile extends StatelessWidget {
  const Myprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      appBar: const CustomAppNotif(title: 'My Profile', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profil
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/img_profile.png'),
            ),
            const SizedBox(height: 16),

            // Nama
            Text(
              'Ghani',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              'official@gerobaks.com',
              style: greyTextStyle.copyWith(fontSize: 14, fontWeight: regular),
            ),

            const SizedBox(height: 32),

            // Info Tambahan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No. Telepon',
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
                Text(
                  '081234567890',
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Alamat', style: blackTextStyle.copyWith(fontSize: 14)),
                Text(
                  'Samarinda, Indonesia',
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Tombol Edit
            CustomFilledButton(
              title: 'Edit Profile',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
