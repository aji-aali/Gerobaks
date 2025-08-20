import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = await LocalStorageService.getInstance();
    final data = await storage.getUserData();
    if (mounted) {
      setState(() {
        userData = data;
      });
    }
  }

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
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                userData?['profile_picture'] ?? 'assets/img_profile.png',
              ),
            ),
            const SizedBox(height: 16),

            // Nama
            Text(
              userData?['name'] ?? 'Loading...',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              userData?['email'] ?? 'Loading...',
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
                  userData?['phone'] ?? 'Loading...',
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
                  userData?['address'] ?? 'Loading...',
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
