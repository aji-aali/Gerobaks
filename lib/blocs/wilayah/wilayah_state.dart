import 'package:latlong2/latlong.dart';

class WilayahState {
  final List<LatLng> routePoints;
  final LatLng truckPosition;
  final LatLng destination;
  final double truckBearing;
  final bool isLoading;
  final String? error;

  WilayahState({
    required this.routePoints,
    required this.truckPosition,
    required this.destination,
    required this.truckBearing,
    this.isLoading = false,
    this.error,
  });

  factory WilayahState.initial() => WilayahState(
    routePoints: [],
    truckPosition: LatLng(-0.5043299181420043, 117.14985864364043),
    destination: LatLng(-0.5028797174108289, 117.15020096577763),
    truckBearing: 0,
  );

  WilayahState copyWith({
    List<LatLng>? routePoints,
    LatLng? truckPosition,
    LatLng? destination,
    double? truckBearing,
    bool? isLoading,
    String? error,
  }) {
    return WilayahState(
      routePoints: routePoints ?? this.routePoints,
      truckPosition: truckPosition ?? this.truckPosition,
      destination: destination ?? this.destination,
      truckBearing: truckBearing ?? this.truckBearing,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
