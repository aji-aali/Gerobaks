import 'package:latlong2/latlong.dart';

abstract class WilayahEvent {}

class FetchRoute extends WilayahEvent {}

class UpdateTruckLocation extends WilayahEvent {
  final LatLng position;
  UpdateTruckLocation(this.position);
}
