import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/mitra/jadwal/jadwal_mitra_page.dart';
import 'package:bank_sha/ui/pages/mitra/pengambilan/pengambilan_list_page.dart';
import 'package:bank_sha/ui/pages/mitra/laporan/laporan_mitra_page.dart';
import 'package:bank_sha/ui/pages/mitra/profile/profile_mitra_page.dart';
import 'package:bank_sha/utils/user_data_mock.dart';
import 'package:bank_sha/services/local_storage_service.dart';
import 'package:bank_sha/ui/widgets/shared/navbar_mitra.dart';
import 'package:flutter/material.dart';

class MitraDashboardPage extends StatefulWidget {
  const MitraDashboardPage({super.key});

  @override
  State<MitraDashboardPage> createState() => _MitraDashboardPageState();
}

class _MitraDashboardPageState extends State<MitraDashboardPage> {
  int _currentIndex = 0;
  Map<String, dynamic>? currentUser;

  final List<Widget> _pages = [
    const MitraDashboardContent(),
    const JadwalMitraPage(),
    const PengambilanListPage(),
    const LaporanMitraPage(),
    const ProfileMitraPage(),
  ];

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
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to pengambilan page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PengambilanListPage(),
              ),
            );
          },
          elevation: 4,
          highlightElevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.white, width: 3),
          ),
          backgroundColor: greenColor,
          child: Icon(
            Icons.local_shipping_rounded,
            color: whiteColor,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBarMitra(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

class MitraDashboardContent extends StatefulWidget {
  const MitraDashboardContent({super.key});

  @override
  State<MitraDashboardContent> createState() => _MitraDashboardContentState();
}

class _MitraDashboardContentState extends State<MitraDashboardContent> {
  Map<String, dynamic>? currentUser;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final localStorage = await LocalStorageService.getInstance();
    final userData = await localStorage.getUserData();
    if (userData != null && mounted) {
      setState(() {
        currentUser = userData;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadCurrentUser();
    // Add additional refresh logic here as needed
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  // Helper methods for date formatting
  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Pagi';
    } else if (hour < 15) {
      return 'Siang';
    } else if (hour < 18) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    // Get current date for greeting
    final DateTime now = DateTime.now();
    final String dateStr =
        '${_getDayName(now.weekday)}, ${now.day} ${_getMonthName(now.month)} ${now.year}';

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: greenColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset('assets/img_gerobakss.png', height: 32),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement notifications
                      },
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      tooltip: 'Notifikasi',
                      splashRadius: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        color: greenColor,
        backgroundColor: Colors.white,
        displacement: 40,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner with date
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Selamat ${_getGreeting()}, ',
                          style: blackTextStyle.copyWith(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: semiBold,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            currentUser != null
                                ? currentUser!['name'].split(' ')[0]
                                : 'Mitra',
                            style: greentextstyle2.copyWith(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: semiBold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: greyColor),
                        const SizedBox(width: 6),
                        Text(
                          dateStr,
                          style: greyTextStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Welcome Card with improved design
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      greenColor,
                      greenColor.withOpacity(0.85),
                      greenColor.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: greenColor.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: isSmallScreen ? 48 : 52,
                          width: isSmallScreen ? 48 : 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.8),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                currentUser != null &&
                                        currentUser!['profile_picture'] != null
                                    ? currentUser!['profile_picture']
                                    : 'assets/img_friend1.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Area Kerja',
                                style: whiteTextStyle.copyWith(
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontWeight: medium,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                currentUser != null
                                    ? '${currentUser!['work_area']}'
                                    : 'Jakarta Selatan',
                                style: whiteTextStyle.copyWith(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: isSmallScreen ? 10 : 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.badge_rounded,
                                      color: whiteColor.withOpacity(0.9),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'ID: ${currentUser != null ? currentUser!['employee_id'] : 'DRV-0000'}',
                                        style: whiteTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: medium,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 6 : 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'AKTIF',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: whiteColor.withOpacity(0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Jam Kerja: 08:00 - 17:00',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Stats Title with Responsive Layout
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 4,
                      decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Statistik Hari Ini',
                      style: blackTextStyle.copyWith(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: semiBold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        _refreshKey.currentState?.show();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10 : 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: greenColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              color: greenColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Refresh',
                              style: greentextstyle2.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Responsive Grid Layout for Stats
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: isSmallScreen ? 12 : 16,
                  mainAxisSpacing: isSmallScreen ? 12 : 16,
                  childAspectRatio: isSmallScreen ? 1.2 : 1.3,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  List<Map<String, dynamic>> stats = [
                    {
                      'title': 'Pengambilan',
                      'value': currentUser != null
                          ? '${currentUser!['total_collections'] ~/ 100}'
                          : '12',
                      'icon': Icons.local_shipping_rounded,
                      'color': const Color(0xFF3B82F6), // Vibrant blue
                    },
                    {
                      'title': 'Selesai',
                      'value': '8',
                      'icon': Icons.check_circle_rounded,
                      'color': const Color(0xFF22C55E), // Vibrant green
                    },
                    {
                      'title': 'Pending',
                      'value': '4',
                      'icon': Icons.pending_rounded,
                      'color': const Color(0xFFF97316), // Vibrant orange
                    },
                    {
                      'title': 'Rating',
                      'value': currentUser != null
                          ? '${currentUser!['rating']}'
                          : '4.8',
                      'icon': Icons.star_rounded,
                      'color': const Color(0xFFEAB308), // Vibrant amber
                    },
                  ];

                  final stat = stats[index];

                  return Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: stat['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                stat['icon'],
                                color: stat['color'],
                                size: 24,
                              ),
                            ),
                            Text(
                              stat['value'],
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 28,
                                fontWeight: extraBold,
                                color: stat['color'],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          stat['title'],
                          style: blackTextStyle.copyWith(
                            fontSize: isSmallScreen ? 14 : 15,
                            fontWeight: semiBold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Vehicle Information Card - Responsive
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 4,
                      decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Informasi Kendaraan',
                      style: blackTextStyle.copyWith(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF0F766E).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: isSmallScreen ? 56 : 64,
                      height: isSmallScreen ? 56 : 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F766E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Color(0xFF0F766E),
                        size: 36,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser != null
                                ? currentUser!['vehicle_type']
                                : 'Truck Sampah',
                            style: blackTextStyle.copyWith(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: semiBold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Plat No: ${currentUser != null ? currentUser!['vehicle_plate'] : 'B 1234 ABC'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: medium,
                                color: const Color(0xFF0F766E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Actions - Responsive Design
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 4,
                      decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Aksi Cepat',
                      style: blackTextStyle.copyWith(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: isSmallScreen ? 10 : 12,
                  mainAxisSpacing: isSmallScreen ? 10 : 12,
                  childAspectRatio: isSmallScreen ? 1.2 : 1.3,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  List<Map<String, dynamic>> actions = [
                    {
                      'title': 'Lihat Jadwal',
                      'subtitle': 'Jadwal pengambilan hari ini',
                      'icon': Icons.schedule_rounded,
                      'color': const Color(0xFF3B82F6), // Vibrant blue
                      'onTap': () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JadwalMitraPage(),
                          ),
                        );
                      },
                    },
                    {
                      'title': 'Mulai Pengambilan',
                      'subtitle': 'Mulai rute pengambilan',
                      'icon': Icons.play_arrow_rounded,
                      'color': greenColor, // Match green theme
                      'onTap': () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PengambilanListPage(),
                          ),
                        );
                      },
                    },
                    {
                      'title': 'Laporan',
                      'subtitle': 'Buat laporan harian',
                      'icon': Icons.assignment_rounded,
                      'color': const Color(0xFF6366F1), // Better purple
                      'onTap': () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LaporanMitraPage(),
                          ),
                        );
                      },
                    },
                    {
                      'title': 'Bantuan',
                      'subtitle': 'Hubungi support',
                      'icon': Icons.help_rounded,
                      'color': const Color(0xFFF97316), // Warmer orange
                      'onTap': () {
                        // Navigate to help
                      },
                    },
                  ];

                  final action = actions[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: action['color'].withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: action['onTap'],
                        splashColor: action['color'].withOpacity(0.1),
                        highlightColor: action['color'].withOpacity(0.05),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: action['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  action['icon'],
                                  color: action['color'],
                                  size: 28,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    action['title'],
                                    style: blackTextStyle.copyWith(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    action['subtitle'],
                                    style: greyTextStyle.copyWith(
                                      fontSize: isSmallScreen ? 11 : 12,
                                      fontWeight: medium,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Bottom spacing
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
