import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'dart:ui' as ui;

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
    // Create a gradient background that's more subtle
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.white.withOpacity(0.95),
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.history_outlined,
                    activeIcon: Icons.history_rounded,
                    label: 'Activity',
                    index: 1,
                  ),
                  // Space for FAB with better proportions
                  const SizedBox(width: 70),
                  _buildNavItem(
                    isImage: true,
                    imagePath: 'assets/ic_tempat_sampah.png',
                    activeImagePath: 'assets/ic_tempat_sampah.png',
                    label: 'Lokasi',
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    IconData? icon,
    IconData? activeIcon,
    String? imagePath,
    String? activeImagePath,
    required String label,
    required int index,
    bool isImage = false,
  }) {
    final isSelected = currentIndex == index;
    
    // Define a soft gray for inactive items
    final inactiveColor = Color(0xFF9E9E9E);
    
    return Expanded(
      child: InkWell(
        onTap: () => onTabTapped(index),
        customBorder: const CircleBorder(),
        splashColor: greenColor.withOpacity(0.1),
        highlightColor: greenColor.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6),
          // Menghapus border indikator
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated container with background indication for selected items
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                height: isSelected ? 42 : 38,
                width: isSelected ? 42 : 38,
                decoration: BoxDecoration(
                  color: isSelected ? greenColor.withOpacity(0.1) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isImage
                      ? Image.asset(
                          isSelected ? (activeImagePath ?? imagePath!) : imagePath!,
                          color: isSelected ? greenColor : inactiveColor,
                          width: isSelected ? 26 : 22,
                          height: isSelected ? 26 : 22,
                          filterQuality: FilterQuality.high,
                        )
                      : Icon(
                          isSelected ? activeIcon ?? icon : icon,
                          color: isSelected ? greenColor : inactiveColor,
                          size: isSelected ? 26 : 22,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              // Text label with animated transition
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                style: isSelected
                    ? greentextstyle2.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                        letterSpacing: 0.2,
                        height: 1.2,
                      )
                    : TextStyle(
                        color: inactiveColor,
                        fontSize: 11,
                        fontWeight: medium,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.1,
                        height: 1.2,
                      ),
                child: Text(label),
              ),
              // Subtle indication for selected item with space
              SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
