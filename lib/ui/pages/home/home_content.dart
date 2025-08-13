import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';
import 'package:bank_sha/ui/widgets/shared/buttons.dart';
import 'package:bank_sha/ui/pages/address/select_address_page.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarHome(),
      backgroundColor: uicolor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildInfoCard(),
          buildQuickPicks(context),
          buildAboutUs(context),
        ],
      ),
    );
  }

  Widget buildInfoCard() {
    final PageController pageController = PageController(
      initialPage: 1000,
      viewportFraction: 0.85,
    );

    final List<Map<String, dynamic>> cardData = [
      {
        'image': 'assets/img_truksampah.png',
        'text': 'Jumlah Yang Membuat Jadwal Pengambilan Hari Ini ada ',
        'count': '17',
      },
      {
        'image': 'assets/img_truksampah.png',
        'text': 'Tempat Sampah Yang Telah\nDiambil Hari Ini ada ',
        'count': '17',
      },
      {
        'image': 'assets/img_card3.png',
        'text': 'Jumlah Yang Membuat Jadwal Pengambilan Hari Ini ada ',
        'count': '25',
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index) {
            final data = cardData[index % cardData.length];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(data['image']!, fit: BoxFit.cover),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text.rich(
                          TextSpan(
                            style: blackTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: semiBold,
                              color: Colors.green,
                            ),
                            children: [
                              TextSpan(text: data['text']),
                              TextSpan(
                                text: data['count'],
                                style: blackTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildQuickPicks(BuildContext context) {
    List<Map<String, dynamic>> quickItems = [
      {
        'icon': Icons.note_add_outlined,
        'title': 'Jadwal Baru',
        'subtitle': 'Buat Jadwal Pengamb..',
        'route': '/tambah-jadwal',
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Tracking Truk',
        'subtitle': 'Tracking truk sekitar',
        'route': '/tracking_full',
      },
      {
        'icon': Icons.assignment_outlined,
        'title': 'Keluhan',
        'subtitle': 'Keluhan Yang Kamu B..',
        'route': '/buatKeluhan',
      },
      {
        'icon': Icons.redeem,
        'title': 'Reward',
        'subtitle': 'Kumpulan Reward',
        'route': '/reward',
      },
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = 24 * 2;
    double spacing = 12;
    double itemWidth = (screenWidth - horizontalPadding - spacing) / 2;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Advanced Point Balance Card - Made clickable and interactive
          InkWell(
            onTap: () {
              // Navigate to reward page when card is tapped
              Navigator.pushNamed(context, '/reward');
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: greenui,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: greenColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Upper part with points balance
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Left side with icon and title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/ic_stars.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Point Balance',
                                  style: greentextstyle2.copyWith(
                                    fontSize: 14,
                                    fontWeight: medium,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '0 pts',
                                  style: greentextstyle2.copyWith(
                                    fontSize: 24,
                                    fontWeight: extraBold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Right side with action button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Tukarkan',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: semiBold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: whiteColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Divider(
                    color: greenColor.withOpacity(0.2),
                    height: 1,
                  ),
                  // Bottom part with info text
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: greentext,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kumpulkan poin dengan jadwal rutin',
                          style: greentextstyle2.copyWith(
                            fontSize: 12,
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Pilihan',
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: quickItems.map((item) {
              return GestureDetector(
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
                child: SizedBox(
                  width: itemWidth,
                  height: 120,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: greenColor.withOpacity(0.2),
                          child: Icon(
                            item['icon'],
                            color: blackColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['title'],
                          style: blackTextStyle.copyWith(fontWeight: semiBold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'],
                          style: greyTextStyle.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildAboutUs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Kami',
            style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/img_logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bersih Itu Sehat!',
                            style: blackTextStyle.copyWith(
                              fontWeight: bold,
                              fontSize: 20,
                              color: greenColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Platform layanan angkut sampah terpercaya dan ramah lingkungan.',
                            style: greyTextStyle.copyWith(
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.emoji_nature, size: 20, color: greenColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kami berkomitmen menciptakan lingkungan yang bersih melalui pengelolaan sampah yang modern, praktis, dan berkelanjutan.',
                        style: blackTextStyle.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextButton(
                    title: 'Pelajari Lebih Lanjut',
                    onPressed: () {
                      Navigator.pushNamed(context, '/about-us');
                    },
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
