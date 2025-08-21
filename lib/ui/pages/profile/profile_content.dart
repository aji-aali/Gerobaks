import 'package:bank_sha/ui/pages/profile/List/about_us.dart';
import 'package:bank_sha/ui/pages/profile/List/myprofile.dart';
import 'package:bank_sha/ui/pages/profile/List/privacy_policy.dart';
import 'package:bank_sha/ui/pages/profile/List/settings/settings.dart';
import 'package:bank_sha/ui/pages/profile/points_history_page.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/ui/widgets/shared/profile_picture_picker.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/ui/widgets/shared/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/sign_in/sign_in_page.dart';
import 'package:bank_sha/ui/widgets/skeleton/skeleton_items.dart';
import 'package:bank_sha/models/user_model.dart';
import 'package:bank_sha/services/user_service.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _isLoading = true;
  UserModel? _user;
  late UserService _userService;
  
  @override
  void initState() {
    super.initState();
    // Load real user data
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    try {
      _userService = await UserService.getInstance();
      await _userService.init();
      
      final user = await _userService.getCurrentUser();
      
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Skeleton loading for profile
  Widget _buildSkeletonLoading() {
    return Container(
      color: uicolor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          
          // Profile Info Skeleton
          Column(
            children: [
              SkeletonItems.circle(size: 120),
              const SizedBox(height: 12),
              SkeletonItems.text(width: 120, height: 16),
              const SizedBox(height: 4),
              SkeletonItems.text(width: 180, height: 14),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Menu Items Skeleton
          for (int i = 0; i < 6; i++) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  SkeletonItems.circle(size: 24),
                  const SizedBox(width: 12),
                  SkeletonItems.text(width: 120, height: 16),
                  const Spacer(),
                  SkeletonItems.circle(size: 18),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildSkeletonLoading();
    }
    
    return Container(
      color: uicolor,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Profile Info
            Column(
              children: [
              ProfilePicturePicker(
                currentPicture: _user?.profilePicUrl ?? 'assets/img_profile.png',
                onPictureSelected: (String newPicture) async {
                  try {
                    await _userService.updateUserProfile(
                      profilePicUrl: newPicture,
                    );
                    _loadUserData(); // Refresh data
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengubah foto profil: $e')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                _user?.name ?? 'Pengguna',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _user?.email ?? 'email@gerobaks.com',
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: regular,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: greenColor.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: greenColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_user?.points ?? 0} Poin',
                      style: greeTextStyle.copyWith(
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

            // Menu Items
            CustomAppMenu(
            iconURL: 'assets/ic_profile_profile.png',
            title: 'My profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Myprofile()),
              );
            },
            page: Container(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_stars.png',
            title: 'Riwayat Poin',
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const PointsHistoryPage(),
                ),
              );
            },
            page: Container(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_my_rewards.png',
            title: 'Langganan Saya',
            onTap: () {
              Navigator.pushNamed(context, '/my-subscription');
            },
            page: Container(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_kebijakan.png',
            title: 'Privacy policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
              );
            },
            page: Container(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_aboutus.png',
            title: 'About us',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUs()),
              );
            },
            page: Container(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_setting.png',
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
            page: Container(),
          ),
          CustomAppMenu(
            iconURL: 'assets/ic_logout_profile.png',
            title: 'Log out',
            onTap: () async {
              // Show confirmation dialog using DialogHelper
              final confirm = await DialogHelper.showConfirmDialog(
                context: context,
                title: 'Logout',
                message: 'Apakah Anda yakin ingin keluar?',
                confirmText: 'Ya, Keluar',
                cancelText: 'Batal',
                icon: Icons.logout,
              );
                
              if (confirm) {
                // Logout and redirect to sign in page
                await _userService.logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    ),
                    (route) => false,
                  );
                }
              }
            },
            page: const SignInPage(),
          ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
