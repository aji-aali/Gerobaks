import 'dart:async';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';
import 'package:bank_sha/ui/pages/address/select_address_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bank_sha/models/information_model.dart';
import 'package:bank_sha/utils/modal_helpers.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // String untuk menyimpan waktu yang akan ditampilkan
  String _currentTimeString = "";
  // Timer untuk update waktu secara berkala
  late Timer _timer;
  
  // Method untuk memperbarui string waktu
  void _updateTime() {
    final now = DateTime.now();
    final String formattedTime = DateFormat('HH:mm:ss').format(now);
    
    // Hanya setState jika component masih mounted
    if (mounted) {
      setState(() {
        _currentTimeString = formattedTime;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    
    // Inisialisasi waktu pertama kali
    _updateTime();
    
    // Set timer untuk memperbarui waktu setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }
  
  @override
  void dispose() {
    // Membersihkan timer saat widget dihancurkan
    _timer.cancel();
    super.dispose();
  }
  
  // Helper method untuk membuat poin fitur dengan icon dalam bagian Tentang Kami
  Widget buildFeaturePoint({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: greenColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: greenColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: greyTextStyle.copyWith(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Definisikan padding yang konsisten untuk seluruh halaman
    const horizontalPadding = 24.0;
    
    return Scaffold(
      appBar: const CustomAppBarHome(),
      backgroundColor: uicolor,
      body: ListView(
        physics: const BouncingScrollPhysics(), // Smooth bouncy scroll effect
        children: [
          // Container untuk semua konten dengan padding yang konsisten
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                // Greeting dengan padding yang lebih seimbang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: buildGreeting(),
                ),
                
                // Quick Picks dengan padding konsisten dan jarak yang lebih baik
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: buildQuickPicks(context),
                ),
                
                // Spacer yang proporsional antara konten
                const SizedBox(height: 28),
                
                // Informasi Carousel dengan struktur yang lebih terorganisir
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Text(
                        'Informasi',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildComingSoonCarousel(),
                  ],
                ),
                
                // About Us dengan padding konsisten
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: buildAboutUs(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Membuat carousel Informasi dengan modal details
  Widget buildComingSoonCarousel() {
    // Menggunakan model data dari information_model.dart
    return CarouselSlider.builder(
      itemCount: informationList.length,
      options: CarouselOptions(
        height: 200,
        viewportFraction: 0.92,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        enlargeFactor: 0.15,
        pauseAutoPlayOnTouch: true,
        padEnds: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final item = informationList[index];
        return GestureDetector(
          onTap: () {
            // Menampilkan modal dengan animasi slide up dan navigasi
            showInformationDetailModal(context, item);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: greenui,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Background image dengan gradient overlay
                  Positioned.fill(
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay untuk teks yang lebih terlihat
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Teks content
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: whiteTextStyle.copyWith(
                            fontSize: 22,
                            fontWeight: bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.description,
                          style: whiteTextStyle.copyWith(
                            fontSize: 13,
                            height: 1.4,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Indikator "Info"
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: greenColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Text(
                        'Info',
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  // Indikator bisa diklik dengan icon kecil di pojok kiri atas
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.touch_app_rounded,
                        size: 14,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGreeting() {
    // Get current time untuk setiap build
    DateTime now = DateTime.now();
    String greeting = '';
    
    // Determine the appropriate greeting based on time of day
    int hour = now.hour;
    if (hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (hour < 15) {
      greeting = 'Selamat Siang';
    } else if (hour < 18) {
      greeting = 'Selamat Sore';
    } else {
      greeting = 'Selamat Malam';
    }
    
    // Format the date: e.g., "Senin, 15 April 2023"
    String formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting dengan efek visual yang lebih baik
          Row(
            children: [
              Text(
                '$greeting, ',
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                  letterSpacing: 0.2,
                ),
              ),
              Flexible(
                child: Text(
                  'Akbar Bintang', // Replace with actual username from state management or shared preferences
                  style: greentextstyle2.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tanggal dan jam dengan layout yang lebih seimbang
          Row(
            children: [
              // Container untuk tanggal
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: greyColor),
                    const SizedBox(width: 6),
                    Text(
                      formattedDate,
                      style: greyTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Spacer antara tanggal dan jam
              const SizedBox(width: 8),
              
              // Container untuk jam
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: greyColor),
                    const SizedBox(width: 6),
                    Text(
                      _currentTimeString,
                      style: greyTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan modal dengan animasi slide-up
  void _showOptionsModal(BuildContext context, List<Map<String, dynamic>> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Konfigurasi untuk slide-up animation yang lebih halus
      enableDrag: true,
      useSafeArea: true,
      builder: (context) {
        // Gunakan AnimatedContainer untuk tambahan efek animasi pada konten
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          height: MediaQuery.of(context).size.height * 0.75, // Modal akan mengambil 75% tinggi layar
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                spreadRadius: -2,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar di bagian atas untuk UX yang lebih baik
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Header dengan tombol tutup
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Row(
                  children: [
                    Text(
                      'Semua Pilihan',
                      style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: blackColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Daftar pilihan dengan deskripsi
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Delay sebentar untuk menyelesaikan animasi ripple sebelum menutup modal
                          Future.delayed(const Duration(milliseconds: 150), () {
                            Navigator.pop(context); // Tutup modal
                            // Handle navigasi berdasarkan rute
                            if (item['title'] == 'Jadwal Baru') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SelectAddressPage(),
                                ),
                              );
                            } else {
                              Navigator.pushNamed(context, item['route']);
                            }
                          });
                        },
                        splashColor: greenColor.withOpacity(0.1),
                        highlightColor: greenColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Row(
                            children: [
                              // Icon dengan background dan efek yang sama seperti di menu utama
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: greenColor.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: greenColor.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: greenColor.withOpacity(0.05),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    item['icon'],
                                    color: greenColor,
                                    size: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: blackTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['subtitle'],
                                      style: greyTextStyle.copyWith(
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: greenColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildQuickPicks(BuildContext context) {
    List<Map<String, dynamic>> quickItems = [
      {
        'icon': Icons.note_add_outlined,
        'title': 'Jadwal Baru',
        'subtitle': 'Buat Jadwal Pengambilan Sampah Anda',
        'route': '/tambah-jadwal',
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Pantau',
        'subtitle': 'Pantau truk pengangkut sampah di sekitar Anda',
        'route': '/tracking_full',
      },
      {
        'icon': Icons.assignment_outlined,
        'title': 'Keluhan',
        'subtitle': 'Kirim dan kelola keluhan tentang layanan kami',
        'route': '/buatKeluhan',
      },
      {
        'icon': Icons.redeem,
        'title': 'Reward',
        'subtitle': 'Kumpulkan dan tukarkan poin reward Anda',
        'route': '/reward',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 0), // Adjusted margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Improved Point Balance Card with soft colors
          Hero(
            tag: 'point-balance',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/reward');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF6BCE7D), // Warna yang lebih fresh dan vibrant
                        const Color(0xFF3D9E4A), // Lebih kontras untuk efek gradient yang lebih baik
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: greenColor.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        spreadRadius: -6,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Upper part with points balance
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Ikon dengan efek glassmorphism
                            Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/ic_stars.png',
                                width: 28,
                                height: 28,
                                color: Colors.white.withOpacity(1),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Points',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: medium,
                                    color: Colors.white.withOpacity(0.95),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      '0',
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 26,
                                        fontWeight: extraBold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      ' pts',
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: medium,
                                        color: Colors.white.withOpacity(0.95),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Tombol tukar dengan efek yang lebih menonjol
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                    spreadRadius: -3,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Tukarkan',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 13,
                                      fontWeight: bold,
                                      letterSpacing: 0.3,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider with improved appearance
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.08),
                      ),
                      // Bottom part with info text - softer appearance
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white.withOpacity(0.7),
                              size: 15,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Kumpulkan poin dengan jadwal rutin',
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: regular,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Header for Menu Pilihan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilihan',
                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
              ),
              TextButton(
                onPressed: () {
                  // Tampilkan modal dengan animasi slide up
                  _showOptionsModal(context, quickItems);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lihat Semua',
                  style: greentextstyle2.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // More Compact Menu Grid with just icons and names
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(quickItems.length, (index) {
              final item = quickItems[index];
              return InkWell(
                onTap: () {
                  // Handle special navigation for "Jadwal Baru"
                  if (item['title'] == 'Jadwal Baru') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectAddressPage(),
                      ),
                    );
                  } else {
                    Navigator.pushNamed(context, item['route']);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width - 48 - 24) / 4, // 4 items per row, minus padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon dengan background dan efek yang lebih menarik
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: greenColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: greenColor.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: greenColor.withOpacity(0.05),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            item['icon'],
                            color: greenColor,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Text dengan styling yang lebih baik
                      Text(
                        item['title'],
                        style: blackTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: medium,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildAboutUs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row dengan konsistensi styling yang sama dengan bagian lain
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: greenColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.eco_rounded,
                        size: 14,
                        color: greenColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tentang Kami',
                    style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/about-us');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Selengkapnya',
                  style: greentextstyle2.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Card dengan desain yang ditingkatkan
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: -5,
                ),
              ],
              border: Border.all(
                color: greenColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  // Hero image dengan overlay gradient modern
                  Stack(
                    children: [
                      // Background image - lebih tinggi untuk tampilan yang lebih baik
                      Image.asset(
                        'assets/img_gerobaks_trust.png',
                        width: double.infinity,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay yang lebih smooth
                      Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                      // Logo dan judul dengan styling yang ditingkatkan
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            // Logo dalam container dengan gradient subtle
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: -2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/img_logo.png',
                                width: 38,
                                height: 38,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Teks dengan styling yang lebih modern
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bersih Itu Sehat!',
                                    style: whiteTextStyle.copyWith(
                                      fontWeight: bold,
                                      fontSize: 18,
                                      letterSpacing: 0.3,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Platform layanan angkut sampah terpercaya',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: medium,
                                      height: 1.3,
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Content section dengan desain yang lebih informatif
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feature points dengan icon untuk setiap poin
                        buildFeaturePoint(
                          icon: Icons.recycling_rounded,
                          title: 'Pengelolaan Sampah Modern',
                          description: 'Kami berkomitmen menciptakan lingkungan yang bersih melalui pengelolaan sampah yang modern dan berkelanjutan.',
                        ),
                        const SizedBox(height: 14),
                        buildFeaturePoint(
                          icon: Icons.eco_outlined,
                          title: 'Ramah Lingkungan',
                          description: 'Mendukung upaya daur ulang dan pengolahan sampah yang ramah lingkungan.',
                        ),
                        const Divider(height: 24, thickness: 0.5, color: Color(0xFFEEEEEE)),
                        
                        // Action button dengan styling yang lebih menarik
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/about-us');
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: whiteColor,
                              backgroundColor: greenColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pelajari Lebih Lanjut',
                                  style: whiteTextStyle.copyWith(
                                    fontWeight: semiBold,
                                    fontSize: 14,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
