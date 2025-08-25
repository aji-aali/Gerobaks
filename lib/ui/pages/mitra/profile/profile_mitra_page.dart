import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/utils/user_data_mock.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/ui/pages/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';

class ProfileMitraPage extends StatefulWidget {
  const ProfileMitraPage({super.key});

  @override
  State<ProfileMitraPage> createState() => _ProfileMitraPageState();
}

class _ProfileMitraPageState extends State<ProfileMitraPage> {
  Map<String, dynamic>? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final localStorage = await LocalStorageService.getInstance();
    final userData = await localStorage.getUserData();
    if (userData != null) {
      final user = UserDataMock.getUserByEmail(userData['email']);
      setState(() {
        currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: greenColor,
        elevation: 0,
        title: Text(
          'Profil Mitra',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Picture
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenColor.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              currentUser!['name'].substring(0, 1),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: bold,
                                color: greenColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentUser!['name'],
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser!['employee_id'],
                          style: greyTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: greenColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: greenColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Mitra Aktif',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: greenColor,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Rating',
                          value: currentUser!['rating'].toString(),
                          icon: Icons.star_rounded,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Pengambilan',
                          value: currentUser!['total_collections'].toString(),
                          icon: Icons.local_shipping_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Vehicle Info
                  _buildInfoSection(
                    title: 'Informasi Kendaraan',
                    items: [
                      _buildInfoItem(
                        'Jenis Kendaraan',
                        currentUser!['vehicle_type'],
                        Icons.local_shipping_rounded,
                      ),
                      _buildInfoItem(
                        'Nomor Plat',
                        currentUser!['vehicle_plate'],
                        Icons.confirmation_number_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Work Info
                  _buildInfoSection(
                    title: 'Informasi Kerja',
                    items: [
                      _buildInfoItem(
                        'Area Kerja',
                        currentUser!['work_area'],
                        Icons.location_on_rounded,
                      ),
                      _buildInfoItem(
                        'Status',
                        currentUser!['status'],
                        Icons.work_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Contact Info
                  _buildInfoSection(
                    title: 'Informasi Kontak',
                    items: [
                      _buildInfoItem(
                        'Email',
                        currentUser!['email'],
                        Icons.email_rounded,
                      ),
                      _buildInfoItem(
                        'Nomor Telepon',
                        currentUser!['phone'],
                        Icons.phone_rounded,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Edit profile
                          },
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('Edit Profil'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: greenColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Change password
                          },
                          icon: const Icon(Icons.lock_rounded),
                          label: const Text('Ubah Password'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: greyColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final localStorage = await LocalStorageService.getInstance();
                            await localStorage.logout();
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
          ),
          Text(
            title,
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: greyColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
