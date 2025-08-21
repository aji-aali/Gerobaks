import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../blocs/tracking/tracking_bloc.dart';
import '../../../blocs/tracking/tracking_event.dart';
import '../../../blocs/tracking/tracking_state.dart';
import 'dart:math' as math;
import 'package:bank_sha/ui/widgets/skeleton/skeleton_items.dart';

class WilayahContent extends StatefulWidget {
  const WilayahContent({super.key});

  @override
  State<WilayahContent> createState() => _WilayahContentState();
}

class _WilayahContentState extends State<WilayahContent> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    context.read<TrackingBloc>().add(FetchRoute());
    _simulateLoading();
  }
  
  // Method to show trash point details in a bottom modal
  void _showTrashPointDetails(
    BuildContext context, 
    String name, 
    LatLng location, 
    {
      required bool isAvailable,
      required int capacity,
      required int currentUsage,
      required String lastEmptied,
    }
  ) {
    // Calculate usage percentage
    final usagePercent = (currentUsage / capacity * 100).round();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Title with status indicator
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAvailable ? greenColor : redcolor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Status
            Row(
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 8),
                Text(
                  isAvailable ? "Tersedia" : "Penuh",
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                    color: isAvailable ? greenColor : redcolor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Location coordinates
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  "${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}",
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Usage bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Kapasitas",
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    Text(
                      "$usagePercent% terisi",
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                        color: usagePercent > 80 ? redcolor : greenColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: currentUsage / capacity,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      usagePercent > 80 ? redcolor : greenColor,
                    ),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$currentUsage / $capacity kg",
                  style: greyTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Last emptied info
            Row(
              children: [
                const Icon(Icons.history, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Terakhir dikosongkan: $lastEmptied",
                  style: greyTextStyle,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action button
            ElevatedButton(
              onPressed: isAvailable 
                ? () {
                    Navigator.pop(context);
                    // Navigate to schedule pickup page
                    Navigator.pushNamed(context, '/home');
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isAvailable ? "Jadwalkan Pengambilan" : "Tidak Tersedia",
                style: whiteTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate map data loading
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // Map skeleton loader
  Widget _buildMapSkeletonLoader() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonItems.card(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.85,
              borderRadius: 12,
            ),
            const SizedBox(height: 20),
            SkeletonItems.text(width: 180, height: 20),
            const SizedBox(height: 8),
            SkeletonItems.text(width: 240, height: 14),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show skeleton loading
    if (_isLoading) {
      return _buildMapSkeletonLoader();
    }
    
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        // Titik-titik polygon zona hijau
        final List<LatLng> greenZone = [
          LatLng(-0.502473, 117.148738), // Titik A
          LatLng(-0.503042, 117.148523), // Titik B
          LatLng(-0.503959, 117.151090), // Titik C
          LatLng(-0.503240, 117.151347), // Titik D
        ];

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(-0.5035, 117.1500),
            initialZoom: 17.6,
          ),
          children: [
            // Peta dasar
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.truckmap',
            ),

            // Zona hijau sebagai polygon
            PolygonLayer(
              polygons: [
                Polygon(
                  points: greenZone,
                  color: Colors.blue.withOpacity(0.3),
                  borderColor: Colors.blue,
                  borderStrokeWidth: 2,
                ),
              ],
            ),

            // Marker tujuan dan tempat sampah
            MarkerLayer(
              markers: [
                // Marker tujuan
                // Marker(
                //   point: state.destination,
                //   width: 60,
                //   height: 60,
                //   alignment: Alignment.center,
                //   child: const Icon(
                //     Icons.location_pin,
                //     size: 35,
                //     color: Colors.red,
                //   ),
                // ),

                // Marker tempat sampah 1 - Kosong (Hijau)
                Marker(
                  point: LatLng(-0.503106, 117.150248),
                  width: 30,
                  height: 60,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _showTrashPointDetails(
                        context, 
                        "Tempat Sampah A", 
                        LatLng(-0.503106, 117.150248),
                        isAvailable: true,
                        capacity: 30,
                        currentUsage: 5,
                        lastEmptied: "Hari ini, 08:30",
                      );
                    },
                    child: Image.asset(
                      'assets/ic_tempat_sampah.png',
                      width: 35,
                      height: 35,
                      color: greenColor,
                    ),
                  ),
                ),

                // Marker tempat sampah 2 - Penuh (Merah)
                Marker(
                  point: LatLng(-0.503248, 117.150693),
                  width: 30,
                  height: 60,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _showTrashPointDetails(
                        context, 
                        "Tempat Sampah B", 
                        LatLng(-0.503248, 117.150693),
                        isAvailable: false,
                        capacity: 50,
                        currentUsage: 48,
                        lastEmptied: "Kemarin, 15:45",
                      );
                    },
                    child: Image.asset(
                      'assets/ic_tempat_sampah.png',
                      width: 35,
                      height: 35,
                      color: redcolor,
                    ),
                  ),
                ),

                // Marker tempat sampah 3 - Penuh (Merah)
                Marker(
                  point: LatLng(-0.502784, 117.149304),
                  width: 30,
                  height: 60,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _showTrashPointDetails(
                        context, 
                        "Tempat Sampah C", 
                        LatLng(-0.502784, 117.149304),
                        isAvailable: false,
                        capacity: 40,
                        currentUsage: 38,
                        lastEmptied: "2 hari lalu, 10:20",
                      );
                    },
                    child: Image.asset(
                      'assets/ic_tempat_sampah.png',
                      width: 35,
                      height: 35,
                      color: redcolor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
