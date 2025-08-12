import 'dart:convert';
import 'dart:math' as math;
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  TrackingBloc() : super(TrackingState.initial()) {
    on<FetchRoute>(_onFetchRoute);
    on<UpdateTruckLocation>(_onUpdateLocation);
  }

  void _onUpdateLocation(
    UpdateTruckLocation event,
    Emitter<TrackingState> emit,
  ) {
    final bearing = calculateBearing(event.position, state.destination);
    emit(state.copyWith(truckPosition: event.position, truckBearing: bearing));
  }

  Future<void> _onFetchRoute(
    FetchRoute event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final apiKey = dotenv.env['ORS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      emit(
        state.copyWith(isLoading: false, error: 'ORS_API_KEY tidak ditemukan'),
      );
      return;
    }

    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${state.truckPosition.longitude},${state.truckPosition.latitude}&end=${state.destination.longitude},${state.destination.latitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates =
            data['features'][0]['geometry']['coordinates'] as List;

        final route = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();

        double bearing = 0.0;
        if (route.length >= 2) {
          bearing = calculateBearing(route[0], route[1]);
        }

        emit(
          state.copyWith(
            routePoints: route,
            truckBearing: bearing,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, error: 'Gagal ambil rute'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  double calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * (math.pi / 180);
    final lon1 = start.longitude * (math.pi / 180);
    final lat2 = end.latitude * (math.pi / 180);
    final lon2 = end.longitude * (math.pi / 180);

    final dLon = lon2 - lon1;

    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = math.atan2(y, x);
    return (bearing * (180 / math.pi) + 360) % 360;
  }
}
