import 'dart:async';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';
import 'package:bank_sha/ui/pages/address/select_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk HapticFeedback
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bank_sha/ui/widgets/informasi_detail_modal.dart';

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
    
    // Inisialisasi data lokal untuk format tanggal Indonesia
    initializeDateFormatting('id_ID');
    
    // Set waktu awal
    _updateTime();
    
    // Setup timer untuk update setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }
  
  @override
  void dispose() {
    // Cancel timer saat widget di-dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: CustomAppBar(
        withMenu: true,
        notifications: true,
        title: '',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          return Future.value();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            buildGreeting(),
            buildHeader(),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Informasi dengan tindakan "Lihat Semua"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informasi',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                          letterSpacing: 0.1,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implementasi aksi untuk "Lihat Semua"
                          // TODO: Navigate to all information
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: greenColor,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          minimumSize: const Size(50, 25), // Smaller tappable area
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Lihat Semua',
                          style: greenTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Informasi Carousel dengan struktur yang lebih terorganisir
                  SizedBox(
                    width: double.infinity,
                    child: buildComingSoonCarousel(),
                  ),
                ],
              ),
            ),
            buildWalletCard(),
            buildLevel(),
            buildServices(),
            buildLatestTransactions(),
            buildSendAgain(),
            buildFriendlyTips(),
          ],
        ),
      ),
    );
  }

  // Membuat carousel Informasi 
  Widget buildComingSoonCarousel() {
    // Daftar item Informasi dengan konten detail untuk modal
    final List<Map<String, dynamic>> comingSoonItems = [
      {
        'image': 'assets/img_pesut.jpeg',
        'title': 'Halo, Samarinda',
        'description': 'Kami akan segera hadir di Kota Samarinda, Stay Tuned!',
        'detailContent': 'Gerobaks dengan bangga mengumumkan akan segera hadir di Kota Samarinda, Kalimantan Timur. Kami berkomitmen untuk memberikan layanan pengelolaan sampah terbaik bagi masyarakat Samarinda dengan dukungan teknologi terkini. Pantau terus informasi terbaru mengenai peluncuran layanan kami di kota pesut ini.',
        'additionalInfo': [
          {
            'label': 'Tanggal Peluncuran',
            'value': 'September 2025'
          },
          {
            'label': 'Area Layanan',
            'value': 'Samarinda Kota, Samarinda Ulu, Samarinda Ilir, dan sekitarnya'
          },
          {
            'label': 'Layanan Tersedia',
            'value': 'Pengambilan Sampah, Daur Ulang, dan Penukaran Poin'
          }
        ]
      },
      {
        'image': 'assets/img_gerobaks.png',
        'title': 'Fitur Baru',
        'description': 'Nikmati pengalaman baru menggunakan aplikasi Gerobaks!',
        'detailContent': 'Kami telah memperbarui aplikasi Gerobaks dengan berbagai fitur inovatif untuk meningkatkan pengalaman pengguna. Fitur notifikasi real-time memungkinkan Anda mendapatkan pemberitahuan saat petugas pengambilan sampah tiba. Selain itu, sistem penukaran poin telah ditingkatkan dengan lebih banyak pilihan hadiah dan proses yang lebih cepat.',
        'additionalInfo': [
          {
            'label': 'Fitur Utama',
            'value': 'Notifikasi Real-time, Tracking Petugas, Penukaran Poin yang Ditingkatkan'
          },
          {
            'label': 'Update Version',
            'value': 'v2.5.0'
          },
          {
            'label': 'Kapan Tersedia',
            'value': 'Sudah tersedia, silakan update aplikasi Anda'
          }
        ]
      },
      {
        'image': 'assets/img_card3.png',
        'title': 'Green City',
        'description': 'Bersama Gerobaks menuju kota yang lebih hijau dan bersih',
        'detailContent': 'Program Green City adalah inisiatif Gerobaks bekerja sama dengan pemerintah kota untuk menciptakan lingkungan perkotaan yang lebih bersih dan hijau. Melalui program ini, kami mengajak seluruh masyarakat untuk berpartisipasi aktif dalam pemilahan sampah dan mendukung upaya daur ulang. Setiap kontribusi Anda dalam program ini akan dihargai dengan poin yang dapat ditukarkan dengan berbagai hadiah menarik.',
        'additionalInfo': [
          {
            'label': 'Target Program',
            'value': 'Pengurangan sampah perkotaan hingga 30% dalam 2 tahun'
          },
          {
            'label': 'Cara Berpartisipasi',
            'value': 'Pilah sampah, gunakan layanan Gerobaks, ajak teman dan keluarga'
          },
          {
            'label': 'Rewards',
            'value': 'Sertifikat digital, diskon layanan, dan hadiah eksklusif'
          }
        ]
      }
    ];

    return CarouselSlider.builder(
      itemCount: comingSoonItems.length,
      options: CarouselOptions(
        height: 200, // Sedikit lebih pendek untuk proporsi yang lebih baik
        viewportFraction: 0.92,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        enlargeFactor: 0.15, // Sedikit lebih kecil untuk tampilan yang lebih seragam
        pauseAutoPlayOnTouch: true,
        padEnds: true, // Memberikan padding di ujung-ujung carousel
      ),
      itemBuilder: (context, index, realIndex) {
        final item = comingSoonItems[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            onTap: () {
              // Berikan feedback haptic
              HapticFeedback.mediumImpact();
              
              // Tampilkan modal dengan animasi slide up
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: true,
                backgroundColor: Colors.transparent,
                transitionAnimationController: AnimationController(
                  vsync: Scaffold.of(context),
                  duration: const Duration(milliseconds: 400),
                ),
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.92, // Hampir full screen
                  minChildSize: 0.5, // Minimum setengah layar
                  maxChildSize: 0.95, // Maksimum hampir full screen
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: InformasiDetailModal(
                        title: item['title'],
                        description: item['description'],
                        image: item['image'],
                        content: item['detailContent'],
                        additionalInfo: List<Map<String, String>>.from(item['additionalInfo']),
                      ),
                    );
                  },
                ),
              );
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
                        item['image'],
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
                            item['title'],
                            style: whiteTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['description'],
                            style: whiteTextStyle.copyWith(
                              fontSize: 13,
                              height: 1.4,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indikator "Info" dengan ikon tap
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Info',
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.touch_app,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Indikator interactive dengan animasi
                    Positioned(
                      bottom: 46,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
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
              Expanded(
                child: Text(
                  'User',
                  style: blackTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: bold,
                    color: greenColor,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Tanggal dan jam dengan efek visual yang lebih baik
          Row(
            children: [
              Text(
                formattedDate,
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                  letterSpacing: 0.1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: greyColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Real-time clock
              Text(
                _currentTimeString,
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    // Konten lainnya yang ada di file asli
    return Container();
  }

  Widget buildWalletCard() {
    // Konten lainnya yang ada di file asli
    return Container();
  }

  Widget buildLevel() {
    // Konten lainnya yang ada di file asli
    return Container();
  }

  Widget buildServices() {
    // Konten lainnya yang ada di file asli
    return Container();
  }

  Widget buildLatestTransactions() {
    // Konten lainnya yang ada di file asli
    return Container();
  }

  Widget buildSendAgain() {
    // Konten lainnya yang ada di file asli
    return Container();
  }

  Widget buildFriendlyTips() {
    // Konten lainnya yang ada di file asli
    return Container();
  }
}
