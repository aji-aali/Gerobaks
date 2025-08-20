import 'package:flutter/material.dart';
import 'package:bank_sha/models/activity_model_improved.dart';
import 'package:bank_sha/ui/pages/activity/activity_item_improved.dart';
import 'package:bank_sha/shared/theme.dart';

class ActivityContentImproved extends StatefulWidget {
  final DateTime? selectedDate;
  final bool showActive;
  final String? filterCategory;
  final String? searchQuery;
  final Future<void> Function()? onRefresh;

  const ActivityContentImproved({
    Key? key,
    this.selectedDate,
    required this.showActive,
    this.filterCategory,
    this.searchQuery,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<ActivityContentImproved> createState() => _ActivityContentImprovedState();
}

class _ActivityContentImprovedState extends State<ActivityContentImproved> {
  bool _isLoading = false;
  
  Future<void> _simulateLoading() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _isLoading = false;
    });
  }
  
  List<ActivityModel> getFilteredActivities() {
    List<ActivityModel> result = sampleActivities;
    
    // Filter berdasarkan tab aktif/riwayat
    result = result.where((activity) => activity.isActive == widget.showActive).toList();
    
    // Filter berdasarkan tanggal jika ada
    if (widget.selectedDate != null) {
      result = result.where((activity) {
        return activity.date.year == widget.selectedDate!.year &&
               activity.date.month == widget.selectedDate!.month &&
               activity.date.day == widget.selectedDate!.day;
      }).toList();
    }
    
    // Filter berdasarkan kategori
    if (widget.filterCategory != null && widget.filterCategory != 'Semua') {
      if (widget.filterCategory == 'Lainnya') {
        // Untuk filter "Lainnya", tampilkan yang tidak masuk kategori utama
        final mainCategories = ['Dijadwalkan', 'Menuju Lokasi', 'Selesai', 'Dibatalkan'];
        result = result.where((activity) => 
          !mainCategories.contains(activity.getCategory())
        ).toList();
      } else {
        result = result.where((activity) => 
          activity.getCategory() == widget.filterCategory
        ).toList();
      }
    }
    
    // Pencarian telah dihapus, tidak perlu filter ini lagi
    
    // Urutkan berdasarkan tanggal (terbaru ke lama)
    result.sort((a, b) => b.date.compareTo(a.date));
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filteredActivities = getFilteredActivities();
    
    // Widget untuk menampilkan tidak ada aktivitas
    Widget emptyWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada aktivitas',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.showActive
                ? 'Anda belum memiliki aktivitas yang aktif'
                : 'Anda belum memiliki riwayat aktivitas',
            style: greyTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    
    // Widget untuk menampilkan daftar aktivitas
    Widget listWidget = ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      physics: const AlwaysScrollableScrollPhysics(), // Pastikan bisa scroll meskipun konten sedikit
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        return ActivityItemImproved(activity: filteredActivities[index]);
      },
    );
    
    // Tentukan widget konten yang akan ditampilkan
    Widget contentWidget = filteredActivities.isEmpty ? emptyWidget : listWidget;
          
    // Wrap dengan RefreshIndicator jika onRefresh tersedia
    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async {
          // Tampilkan loading indicator jika refresh dimulai
          await _simulateLoading();
          
          // Panggil onRefresh dari parent jika ada
          if (widget.onRefresh != null) {
            await widget.onRefresh!();
          }
        },
        color: greenColor,
        backgroundColor: Colors.white,
        displacement: 40.0, // Jarak displacement yang lebih baik
        strokeWidth: 3.0, // Lebar stroke yang lebih tebal
        child: Stack(
          children: [
            // Pastikan emptyWidget tetap bisa di-scroll untuk pull-to-refresh
            filteredActivities.isEmpty 
                ? Stack(
                    children: [
                      // ListView kosong untuk memungkinkan scroll
                      ListView(),
                      // Widget kosong di atasnya
                      emptyWidget,
                    ],
                  ) 
                : listWidget,
            
            // Overlay loading indicator jika sedang loading
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    
    return contentWidget;
  }
}
