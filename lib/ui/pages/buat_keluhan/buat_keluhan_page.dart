import 'package:bank_sha/ui/pages/buat_keluhan/buat_keluhan_form.dart';
import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/shared/appbar.dart';

class BuatKeluhanPage extends StatefulWidget {
  const BuatKeluhanPage({super.key});

  @override
  State<BuatKeluhanPage> createState() => _BuatKeluhanPageState();
}

class _BuatKeluhanPageState extends State<BuatKeluhanPage> {
  // Data dummy untuk hasil keluhan yang sudah ada
  final List<Map<String, dynamic>> daftarKeluhan = [
    {
      'id': '1723456789012',
      'nama': 'Ghani',
      'judul': 'Sampah belum diambil',
      'kategori': 'Pengambilan Sampah',
      'prioritas': 'Tinggi',
      'tanggal': '2025-08-01',
      'status': 'Sedang Diproses',
      'lokasi': 'Jl. Merdekan No. 123, Samarinda',
    },
    {
      'id': '1723456789013',
      'nama': 'Ghani',
      'judul': 'Petugas datang terlambat',
      'kategori': 'Jadwal Terlambat',
      'prioritas': 'Normal',
      'tanggal': '2025-07-30',
      'status': 'Selesai',
      'lokasi': 'Jl. Merdekan No. 123, Samarinda',
    },
  ];

  void _navigateToKeluhanForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuatKeluhanForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uicolor,
      appBar: CustomAppBar(
        title: 'Daftar Keluhan',
        rightImageAsset: 'assets/ic_plus.png',
        onRightImagePressed: _navigateToKeluhanForm,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    greenColor.withOpacity(0.1),
                    greenColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: greenColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt_rounded, color: greenColor, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        '📋 Riwayat Keluhan Anda',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Berikut adalah daftar keluhan yang telah Anda sampaikan. Pantau status penanganan keluhan Anda di sini.',
                    style: greyTextStyle.copyWith(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard(
                        'Total Keluhan',
                        daftarKeluhan.length.toString(),
                        Icons.description_rounded,
                        Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Selesai',
                        daftarKeluhan
                            .where((k) => k['status'] == 'Selesai')
                            .length
                            .toString(),
                        Icons.check_circle_rounded,
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Action Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [greenColor, greenColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: greenColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: whiteColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_circle_rounded,
                      color: whiteColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✨ Punya Keluhan Baru?',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
                        Text(
                          'Sampaikan keluhan Anda dengan mudah',
                          style: whiteTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToKeluhanForm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Buat Sekarang',
                        style: TextStyle(
                          color: greenColor,
                          fontWeight: semiBold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Keluhan Terkini',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
                Text(
                  '${daftarKeluhan.length} Keluhan',
                  style: greyTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Daftar Keluhan
            daftarKeluhan.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: daftarKeluhan.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final keluhan = daftarKeluhan[index];
                      return _buildKeluhanCard(keluhan);
                    },
                  ),

            const SizedBox(height: 80), // Extra space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToKeluhanForm,
        backgroundColor: greenColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Buat Keluhan',
          style: whiteTextStyle.copyWith(fontWeight: semiBold),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: greyTextStyle.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeluhanCard(Map<String, dynamic> keluhan) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan ID dan Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ID: ${keluhan['id']}',
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(keluhan['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(keluhan['status']).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  keluhan['status'],
                  style: TextStyle(
                    color: _getStatusColor(keluhan['status']),
                    fontSize: 11,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Judul Keluhan
          Text(
            keluhan['judul'],
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
          ),

          const SizedBox(height: 8),

          // Info Pelapor
          Row(
            children: [
              Icon(Icons.person_rounded, color: greyColor, size: 16),
              const SizedBox(width: 6),
              Text(
                keluhan['nama'],
                style: greyTextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Detail Info
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  keluhan['kategori'],
                  Icons.category_rounded,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoChip(
                  keluhan['prioritas'],
                  Icons.priority_high_rounded,
                  _getPrioritasColor(keluhan['prioritas']),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Lokasi dan Tanggal
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: greyColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  keluhan['lokasi'],
                  style: greyTextStyle.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(Icons.access_time_rounded, color: greyColor, size: 16),
              const SizedBox(width: 6),
              Text(
                keluhan['tanggal'],
                style: greyTextStyle.copyWith(fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Action untuk lihat detail
                    _showDetailKeluhan(keluhan);
                  },
                  icon: Icon(
                    Icons.visibility_rounded,
                    size: 16,
                    color: greenColor,
                  ),
                  label: Text(
                    'Lihat Detail',
                    style: TextStyle(color: greenColor, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: greenColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: semiBold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: greyColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Keluhan',
            style: blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda belum memiliki keluhan apapun.\nBuat keluhan pertama Anda sekarang.',
            style: greyTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _navigateToKeluhanForm,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Keluhan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailKeluhan(Map<String, dynamic> keluhan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Detail Keluhan',
              style: blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
            ),
            const SizedBox(height: 20),

            // Detail content - you can expand this
            Text(
              'ID: ${keluhan['id']}',
              style: greyTextStyle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              keluhan['judul'],
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green.shade600;
      case 'sedang diproses':
        return Colors.orange.shade600;
      case 'menunggu':
        return Colors.blue.shade600;
      default:
        return greyColor;
    }
  }

  Color _getPrioritasColor(String prioritas) {
    switch (prioritas.toLowerCase()) {
      case 'rendah':
        return Colors.green.shade600;
      case 'normal':
        return Colors.blue.shade600;
      case 'tinggi':
        return Colors.orange.shade600;
      case 'urgent':
        return Colors.red.shade600;
      default:
        return greyColor;
    }
  }
}
