import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: whiteColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          children: <Widget>[
            _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
            _buildNavItem(icon: Icons.history, label: 'Activity', index: 1),
            const SizedBox(width: 50), // Space for FAB
            _buildNavItem(
              isImage: true,
              imagePath: 'assets/ic_tempat_sampah.png',
              label: 'Lokasi',
              index: 2,
            ),
            _buildNavItem(icon: Icons.person, label: 'Profile', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    IconData? icon,
    String? imagePath,
    required String label,
    required int index,
    bool isImage = false,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImage
                ? Image.asset(
                    imagePath!,
                    width: 24,
                    height: 24,
                    color: isSelected ? greenColor : blackColor,
                  )
                : Icon(icon, color: isSelected ? greenColor : blackColor),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isSelected
                  ? greeTextStyle.copyWith(fontSize: 10, fontWeight: medium)
                  : blackTextStyle.copyWith(fontSize: 10, fontWeight: medium),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
