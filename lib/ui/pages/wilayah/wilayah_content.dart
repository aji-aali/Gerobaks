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

                // Marker tempat sampah 1
                Marker(
                  point: LatLng(-0.503106, 117.150248),
                  width: 30,
                  height: 60,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/ic_tempat_sampah.png',
                    width: 35,
                    height: 35,
                    color: greenColor,
                  ),
                ),

                // Marker tempat sampah 2
                Marker(
                  point: LatLng(-0.503248, 117.150693),
                  width: 30,
                  height: 60,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/ic_tempat_sampah.png',
                    width: 35,
                    height: 35,
                    color: redcolor,
                  ),
                ),

                // Marker tempat sampah 3
                Marker(
                  point: LatLng(-0.502784, 117.149304),
                  width: 30,
                  height: 60,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/ic_tempat_sampah.png',
                    width: 35,
                    height: 35,
                    color: redcolor,
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
