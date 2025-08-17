import 'package:bank_sha/ui/pages/popupiklan.dart';
import 'package:bank_sha/ui/pages/wilayah/wilayah_page.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/activity/activity_page.dart';
import 'package:bank_sha/ui/pages/profile/profile_page.dart';
import 'package:bank_sha/ui/pages/tambah_jadwal_page.dart';
import 'package:bank_sha/ui/pages/home/home_content.dart';
import 'package:bank_sha/ui/widgets/shared/navbar.dart';
import 'package:bank_sha/ui/pages/address/select_address_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    ActivityPage(),
    WilayahPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // Tampilkan popup iklan setelah build selesai
    Future.delayed(const Duration(milliseconds: 500), () {
      showIklanPopup(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectAddressPage()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: greenColor,
        child: Icon(Icons.add, color: whiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_currentIndex],
      ),
    );
  }
}
