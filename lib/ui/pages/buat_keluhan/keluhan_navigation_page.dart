import 'package:bank_sha/ui/pages/buat_keluhan/buat_keluhan_page.dart';
import 'package:bank_sha/ui/pages/buat_keluhan/keluhan_page_new.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';

class KeluhanNavigationPage extends StatefulWidget {
  const KeluhanNavigationPage({super.key});

  @override
  State<KeluhanNavigationPage> createState() => _KeluhanNavigationPageState();
}

class _KeluhanNavigationPageState extends State<KeluhanNavigationPage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const KeluhanPage(), // New implementation
    const BuatKeluhanPage(), // Original implementation
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: whiteColor,
        selectedItemColor: greenColor,
        unselectedItemColor: greyColor,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_rounded),
            label: 'Modern UI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outlined),
            label: 'Original UI',
          ),
        ],
      ),
    );
  }
}
