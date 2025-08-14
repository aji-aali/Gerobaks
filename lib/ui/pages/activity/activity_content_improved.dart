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
    
    // Filter berdasarkan pencarian
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      final searchQuery = widget.searchQuery!.toLowerCase();
      result = result.where((activity) => 
        activity.title.toLowerCase().contains(searchQuery) ||
        activity.address.toLowerCase().contains(searchQuery) ||
        activity.status.toLowerCase().contains(searchQuery)
      ).toList();
    }
    
    // Urutkan berdasarkan tanggal (terbaru ke lama)
    result.sort((a, b) => b.date.compareTo(a.date));
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filteredActivities = getFilteredActivities();
    
    Widget contentWidget = filteredActivities.isEmpty
        ? Center(
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
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            itemCount: filteredActivities.length,
            itemBuilder: (context, index) {
              return ActivityItemImproved(activity: filteredActivities[index]);
            },
          );
          
    // Wrap with RefreshIndicator if onRefresh is provided
    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async {
          await _simulateLoading();
          if (widget.onRefresh != null) {
            await widget.onRefresh!();
          }
        },
        color: greenColor,
        child: Stack(
          children: [
            contentWidget,
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
